import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tarides/homePage.dart';
import 'package:tarides/services/add_favs.dart';
import 'package:tarides/services/add_pedal.dart';
import 'package:tarides/utils/distance_calculations.dart';
import 'package:tarides/utils/get_location.dart';
import 'package:tarides/utils/time_calculation.dart';
import 'package:tarides/widgets/button_widget.dart';
import 'package:tarides/widgets/text_widget.dart';
import 'package:google_maps_webservice/places.dart' as location;

import '../utils/keys.dart';

class PedalScreeen extends StatefulWidget {
  String email;

  PedalScreeen({super.key, required this.email});

  @override
  State<PedalScreeen> createState() => _PedalScreeenState();
}

class _PedalScreeenState extends State<PedalScreeen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer.periodic(const Duration(seconds: 5), (timer) {
      Geolocator.getCurrentPosition().then((position) {
        setState(() {
          lat = position.latitude;
          long = position.longitude;
          hasLoaded = true;
          speed = position.speed;
          pickUp = LatLng(position.latitude, position.longitude);
        });

        addMyMarker1(position.latitude, position.longitude);
        getAddressFromLatLng(position.latitude, position.longitude)
            .then((value) {
          setState(() {
            pickup = value;
          });
        });
        mapController!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                zoom: 14.4746,
                target: LatLng(position.latitude, position.longitude))));
      }).catchError((error) {
        print('Error getting location: $error');
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mapController!.dispose();
  }

  bool hasLoaded = false;

  double lat = 0;
  double long = 0;
  late Polyline _poly = const Polyline(polylineId: PolylineId('new'));

  late Polyline _poly2 = const Polyline(polylineId: PolylineId('2'));

  Set<Marker> markers = {};

  List<LatLng> polylineCoordinates = [];
  List<LatLng> polylineCoordinates1 = [];
  PolylinePoints polylinePoints = PolylinePoints();

  late LatLng pickUp;
  GoogleMapController? mapController;
  late LatLng dropOff;
  late LatLng secondLoc;

  addMyMarker1(lat1, long1) async {
    markers.add(Marker(
        draggable: true,
        onDragEnd: (value) async {
          pickup = await getAddressFromLatLng(value.latitude, value.longitude);

          if (polylineCoordinates1 != []) {
            PolylineResult result =
                await polylinePoints.getRouteBetweenCoordinates(
                    kGoogleApiKey,
                    PointLatLng(value.latitude, value.longitude),
                    PointLatLng(secondLoc.latitude, secondLoc.longitude));
            if (result.points.isNotEmpty) {
              polylineCoordinates = result.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }

            PolylineResult result1 =
                await polylinePoints.getRouteBetweenCoordinates(
              kGoogleApiKey,
              PointLatLng(secondLoc.latitude, secondLoc.longitude),
              PointLatLng(dropOff.latitude, dropOff.longitude),
            );
            if (result.points.isNotEmpty) {
              polylineCoordinates1 = result1.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }
          }
          setState(() {
            _poly = Polyline(
                color: Colors.red,
                polylineId: const PolylineId('route'),
                points: polylineCoordinates,
                width: 4);

            _poly2 = Polyline(
                color: Colors.blue,
                polylineId: const PolylineId('route1'),
                points: polylineCoordinates1,
                width: 4);
            pickUp = value;
          });
        },
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("pickup"),
        position: LatLng(lat1, long1),
        infoWindow: InfoWindow(title: 'Starting Point', snippet: pickup)));
  }

  addMyMarker12(lat1, long1) async {
    markers.add(Marker(
        draggable: true,
        onDragEnd: (value) async {
          second = await getAddressFromLatLng(value.latitude, value.longitude);
          if (polylineCoordinates1 != []) {
            PolylineResult result =
                await polylinePoints.getRouteBetweenCoordinates(
                    kGoogleApiKey,
                    PointLatLng(pickUp.latitude, pickUp.longitude),
                    PointLatLng(value.latitude, value.longitude));
            if (result.points.isNotEmpty) {
              polylineCoordinates = result.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }

            PolylineResult result1 =
                await polylinePoints.getRouteBetweenCoordinates(
              kGoogleApiKey,
              PointLatLng(value.latitude, value.longitude),
              PointLatLng(dropOff.latitude, dropOff.longitude),
            );
            if (result.points.isNotEmpty) {
              polylineCoordinates1 = result1.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }
          }
          setState(() {
            _poly = Polyline(
                color: Colors.red,
                polylineId: const PolylineId('route'),
                points: polylineCoordinates,
                width: 4);

            _poly2 = Polyline(
                color: Colors.blue,
                polylineId: const PolylineId('route1'),
                points: polylineCoordinates1,
                width: 4);
            secondLoc = value;
          });
        },
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("dropOff"),
        position: LatLng(lat1, long1),
        infoWindow: InfoWindow(title: 'Second Point', snippet: second)));
  }

  addMyMarker123(lat1, long1) async {
    markers.add(Marker(
        draggable: true,
        onDragEnd: (value) async {
          drop = await getAddressFromLatLng(value.latitude, value.longitude);
          if (polylineCoordinates1 != []) {
            PolylineResult result =
                await polylinePoints.getRouteBetweenCoordinates(
                    kGoogleApiKey,
                    PointLatLng(pickUp.latitude, pickUp.longitude),
                    PointLatLng(secondLoc.latitude, secondLoc.longitude));
            if (result.points.isNotEmpty) {
              polylineCoordinates = result.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }

            PolylineResult result1 =
                await polylinePoints.getRouteBetweenCoordinates(
              kGoogleApiKey,
              PointLatLng(secondLoc.latitude, secondLoc.longitude),
              PointLatLng(value.latitude, value.longitude),
            );
            if (result.points.isNotEmpty) {
              polylineCoordinates1 = result1.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }
          }
          setState(() {
            _poly = Polyline(
                color: Colors.red,
                polylineId: const PolylineId('route'),
                points: polylineCoordinates,
                width: 4);

            _poly2 = Polyline(
                color: Colors.blue,
                polylineId: const PolylineId('route1'),
                points: polylineCoordinates1,
                width: 4);
            dropOff = value;
          });
        },
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("dropOff1"),
        position: LatLng(lat1, long1),
        infoWindow: InfoWindow(title: 'Ending Point', snippet: drop)));
  }

  late String pickup = '';
  late String drop = '';
  late String second = '';
  bool isclicked = false;

  double speed = 0;
  bool isPause = false;

  @override
  Widget build(BuildContext context) {
    CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 14.4746,
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: pickup == ''
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(top: 90),
                child: FloatingActionButton.small(
                  child: const Icon(
                    Icons.my_location,
                  ),
                  onPressed: () {
                    mapController!.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            zoom: 14.4746,
                            target:
                                LatLng(pickUp.latitude, pickUp.longitude))));
                  },
                ),
              ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: TextWidget(
                    text: 'Pedal',
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'Bold',
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      onTap: (argument) async {
                        if (second == '') {
                          secondLoc = argument;
                          second = await getAddressFromLatLng(
                              argument.latitude, argument.longitude);

                          addMyMarker12(argument.latitude, argument.longitude);

                          setState(() {});
                        } else if (drop == '') {
                          dropOff = argument;
                          drop = await getAddressFromLatLng(
                              argument.latitude, argument.longitude);

                          addMyMarker123(argument.latitude, argument.longitude);

                          PolylineResult result =
                              await polylinePoints.getRouteBetweenCoordinates(
                                  kGoogleApiKey,
                                  PointLatLng(
                                      pickUp.latitude, pickUp.longitude),
                                  PointLatLng(
                                      secondLoc.latitude, secondLoc.longitude));
                          if (result.points.isNotEmpty) {
                            polylineCoordinates = result.points
                                .map((point) =>
                                    LatLng(point.latitude, point.longitude))
                                .toList();
                          }

                          PolylineResult result1 =
                              await polylinePoints.getRouteBetweenCoordinates(
                            kGoogleApiKey,
                            PointLatLng(
                                secondLoc.latitude, secondLoc.longitude),
                            PointLatLng(argument.latitude, argument.longitude),
                          );
                          if (result.points.isNotEmpty) {
                            polylineCoordinates1 = result1.points
                                .map((point) =>
                                    LatLng(point.latitude, point.longitude))
                                .toList();
                          }

                          setState(() {
                            _poly = Polyline(
                                color: Colors.red,
                                polylineId: const PolylineId('route'),
                                points: polylineCoordinates,
                                width: 4);

                            _poly2 = Polyline(
                                color: Colors.blue,
                                polylineId: const PolylineId('route1'),
                                points: polylineCoordinates1,
                                width: 4);
                          });
                        }
                      },
                      polylines: {_poly, _poly2},
                      markers: markers,
                      zoomControlsEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                        _controller.complete(controller);
                      },
                    ),
                    isclicked
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                height: 250,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 150,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.brown[100]!
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    TextWidget(
                                                      text: 'TIME',
                                                      fontSize: 12,
                                                      color: Colors.amber,
                                                    ),
                                                    TextWidget(
                                                      text: speed == 0
                                                          ? '0.0'
                                                          : '${calculateTravelTimeInMinutes(calculateDistance(pickUp.latitude, pickUp.longitude, dropOff.latitude, dropOff.longitude), 0.30).toStringAsFixed(2)}hrs',
                                                      fontSize: 28,
                                                      color: Colors.white,
                                                      fontFamily: 'Bold',
                                                    ),
                                                    const SizedBox(
                                                      width: 125,
                                                      child: Divider(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    TextWidget(
                                                      text: 'TOTAL DISTANCE',
                                                      fontSize: 12,
                                                      color: Colors.amber,
                                                    ),
                                                    TextWidget(
                                                      text: speed == 0
                                                          ? '0.0'
                                                          : '${calculateDistance(pickUp.latitude, pickUp.longitude, dropOff.latitude, dropOff.longitude).toStringAsFixed(2)}KM',
                                                      fontSize: 28,
                                                      color: Colors.white,
                                                      fontFamily: 'Bold',
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const SizedBox(
                                                  height: 125,
                                                  child: VerticalDivider(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    TextWidget(
                                                      text: 'AVG SPEED (km/h)',
                                                      fontSize: 12,
                                                      color: Colors.amber,
                                                    ),
                                                    TextWidget(
                                                      text: speed == 0
                                                          ? '0.0'
                                                          : speed
                                                              .toStringAsFixed(
                                                                  2),
                                                      fontSize: 28,
                                                      color: Colors.white,
                                                      fontFamily: 'Bold',
                                                    ),
                                                    const SizedBox(
                                                      width: 125,
                                                      child: Divider(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    TextWidget(
                                                      text: 'DISTANCE TRAVEL',
                                                      fontSize: 12,
                                                      color: Colors.amber,
                                                    ),
                                                    TextWidget(
                                                      text: '0.0',
                                                      fontSize: 28,
                                                      color: Colors.white,
                                                      fontFamily: 'Bold',
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isclicked = false;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        color: Colors.white),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        45, 11, 45, 11),
                                                    child: TextWidget(
                                                      text: 'PAUSE',
                                                      fontSize: 18,
                                                      fontFamily: 'Bold',
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          ButtonWidget(
                                            width: 150,
                                            color: Colors.red,
                                            radius: 15,
                                            label: 'FINISH',
                                            onPressed: () {
                                              addPedal(
                                                  pickUp.latitude,
                                                  pickUp.longitude,
                                                  pickup,
                                                  dropOff.latitude,
                                                  dropOff.latitude,
                                                  drop,
                                                  '${calculateDistance(pickUp.latitude, pickUp.longitude, dropOff.latitude, dropOff.longitude).toStringAsFixed(2)}KM',
                                                  '${calculateTravelTimeInMinutes(calculateDistance(pickUp.latitude, pickUp.longitude, dropOff.latitude, dropOff.longitude), 0.30).toStringAsFixed(2)}hrs');
                                              setState(() {
                                                isclicked = false;
                                                selectedPageIndex = 4;
                                              });

                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage(
                                                          index: 2,
                                                          email: widget.email,
                                                        )),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const TabBar(
                                        indicatorColor: Colors.red,
                                        labelColor: Colors.red,
                                        unselectedLabelColor: Colors.grey,
                                        tabs: [
                                          Tab(
                                            text: 'Routes',
                                          ),
                                          Tab(
                                            text: 'Saved Routes',
                                          ),
                                        ]),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 220,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: TabBarView(children: [
                                          SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextWidget(
                                                      text:
                                                          'Pin point your location!',
                                                      fontSize: 12,
                                                      fontFamily: 'Bold',
                                                    ),
                                                    ButtonWidget(
                                                      color: second == '' ||
                                                              drop == ''
                                                          ? Colors.grey
                                                          : Colors.red,
                                                      fontSize: 12,
                                                      width: 50,
                                                      radius: 100,
                                                      height: 35,
                                                      label: 'Save route',
                                                      onPressed: () {
                                                        if (second != '' ||
                                                            drop != '') {
                                                          showsaverouteDialog();
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    // searchPickup();
                                                  },
                                                  child: Container(
                                                    height: 35,
                                                    width: 300,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: TextFormField(
                                                      enabled: false,
                                                      decoration:
                                                          InputDecoration(
                                                        prefixIcon: const Icon(
                                                          Icons
                                                              .location_on_rounded,
                                                          color: Colors.amber,
                                                        ),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10100),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        label: TextWidget(
                                                          text:
                                                              'Start point: $pickup',
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 35,
                                                    width: 300,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: TextFormField(
                                                      enabled: false,
                                                      decoration:
                                                          InputDecoration(
                                                        prefixIcon: const Icon(
                                                          Icons
                                                              .location_on_rounded,
                                                          color: Colors.amber,
                                                        ),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10100),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        label: TextWidget(
                                                          text:
                                                              '2nd point: $second',
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 35,
                                                    width: 300,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: TextFormField(
                                                      enabled: false,
                                                      decoration:
                                                          InputDecoration(
                                                        prefixIcon: const Icon(
                                                          Icons
                                                              .location_on_rounded,
                                                          color: Colors.red,
                                                        ),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10100),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        label: TextWidget(
                                                          text:
                                                              'End point: $drop',
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                second == '' || drop == ''
                                                    ? const SizedBox()
                                                    : ButtonWidget(
                                                        color: Colors.red,
                                                        fontSize: 18,
                                                        width: 300,
                                                        radius: 15,
                                                        height: 50,
                                                        label: 'Start',
                                                        onPressed: () {
                                                          if (second != '' &&
                                                              drop != '') {
                                                            setState(() {
                                                              isclicked = true;
                                                            });
                                                          }
                                                        },
                                                      ),
                                              ],
                                            ),
                                          ),
                                          // Saved routes tab
                                          StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('Favs')
                                                  .where('userId',
                                                      isEqualTo: FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid)
                                                  .where('type',
                                                      isEqualTo: 'pedal')
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (snapshot.hasError) {
                                                  print('error');
                                                  return const Center(
                                                      child: Text('Error'));
                                                }
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 50),
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      color: Colors.black,
                                                    )),
                                                  );
                                                }

                                                final data =
                                                    snapshot.requireData;
                                                return SizedBox(
                                                  height: 220,
                                                  width: double.infinity,
                                                  child: ListView.builder(
                                                    itemCount: data.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            pickup =
                                                                data.docs[index]
                                                                    ['start'];
                                                            second =
                                                                data.docs[index]
                                                                    ['end'];
                                                            drop =
                                                                data.docs[index]
                                                                    ['end1'];

                                                            pickUp = LatLng(
                                                                data.docs[index]
                                                                    [
                                                                    'startLat'],
                                                                data.docs[index]
                                                                    [
                                                                    'startLong']);

                                                            secondLoc = LatLng(
                                                                data.docs[index]
                                                                    ['endLat'],
                                                                data.docs[index]
                                                                    [
                                                                    'endLong']);
                                                            dropOff = LatLng(
                                                                data.docs[index]
                                                                    ['endLat1'],
                                                                data.docs[index]
                                                                    [
                                                                    'endLong1']);
                                                          });
                                                        },
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .location_on_rounded,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    TextWidget(
                                                                      text: data
                                                                              .docs[index]
                                                                          [
                                                                          'start'],
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          'Bold',
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .location_on_rounded,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    TextWidget(
                                                                      text: data
                                                                              .docs[index]
                                                                          [
                                                                          'end'],
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          'Bold',
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .location_on_rounded,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          200,
                                                                      child:
                                                                          TextWidget(
                                                                        text: data.docs[index]
                                                                            [
                                                                            'end1'],
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            'Bold',
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            TextWidget(
                                                              text:
                                                                  '${calculateDistance(data.docs[index]['startLat'], data.docs[index]['startLong'], data.docs[index]['endLat'], data.docs[index]['endLong']).toStringAsFixed(2)}KM',
                                                              fontSize: 18,
                                                              fontFamily:
                                                                  'Bold',
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              }),
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showsaverouteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextWidget(
            text: 'You Want to Save your Route?',
            fontSize: 18,
            fontFamily: 'Bold',
          ),
          content: TextWidget(
            text:
                'Save this epic bike route to your favorites for quick access.',
            fontSize: 12,
            fontFamily: 'Medium',
            color: Colors.grey,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: TextWidget(
                        text: 'Cancel',
                        fontSize: 14,
                        fontFamily: 'Bold',
                        color: Colors.red,
                      ),
                    ),
                  )),
            ),
            TextButton(
                onPressed: () {
                  addFav(
                    pickUp.latitude,
                    pickUp.longitude,
                    pickup,
                    secondLoc.latitude,
                    secondLoc.latitude,
                    second,
                    'pedal',
                    dropOff.latitude,
                    dropOff.latitude,
                    drop,
                    0,
                    0,
                    '',
                  );
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.red),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                    child: TextWidget(
                      text: 'Save',
                      fontSize: 14,
                      fontFamily: 'Bold',
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
        );
      },
    );
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  searchPickup() async {
    location.Prediction? p = await PlacesAutocomplete.show(
        mode: Mode.overlay,
        context: context,
        apiKey: kGoogleApiKey,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search Starting Location',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white))),
        components: [location.Component(location.Component.country, "ph")]);

    location.GoogleMapsPlaces places = location.GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    location.PlacesDetailsResponse detail =
        await places.getDetailsByPlaceId(p!.placeId!);

    addMyMarker1(detail.result.geometry!.location.lat,
        detail.result.geometry!.location.lng);

    mapController!.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(detail.result.geometry!.location.lat,
            detail.result.geometry!.location.lng),
        18.0));

    setState(() {
      pickup = detail.result.name;
      pickUp = LatLng(detail.result.geometry!.location.lat,
          detail.result.geometry!.location.lng);
    });
  }

  searchSecond() async {
    location.Prediction? p = await PlacesAutocomplete.show(
        mode: Mode.overlay,
        context: context,
        apiKey: kGoogleApiKey,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search 2nd Location',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white))),
        components: [location.Component(location.Component.country, "ph")]);

    location.GoogleMapsPlaces places = location.GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    location.PlacesDetailsResponse detail =
        await places.getDetailsByPlaceId(p!.placeId!);

    addMyMarker12(detail.result.geometry!.location.lat,
        detail.result.geometry!.location.lng);

    setState(() {
      second = detail.result.name;

      secondLoc = LatLng(detail.result.geometry!.location.lat,
          detail.result.geometry!.location.lng);
    });

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        kGoogleApiKey,
        PointLatLng(pickUp.latitude, pickUp.longitude),
        PointLatLng(detail.result.geometry!.location.lat,
            detail.result.geometry!.location.lng));
    if (result.points.isNotEmpty) {
      polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    }
    setState(() {
      _poly = Polyline(
          color: Colors.red,
          polylineId: const PolylineId('route'),
          points: polylineCoordinates,
          width: 4);
    });

    mapController!.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(detail.result.geometry!.location.lat,
            detail.result.geometry!.location.lng),
        18.0));

    double miny = (pickUp.latitude <= secondLoc.latitude)
        ? pickUp.latitude
        : secondLoc.latitude;
    double minx = (pickUp.longitude <= secondLoc.longitude)
        ? pickUp.longitude
        : secondLoc.longitude;
    double maxy = (pickUp.latitude <= secondLoc.latitude)
        ? secondLoc.latitude
        : pickUp.latitude;
    double maxx = (pickUp.longitude <= secondLoc.longitude)
        ? secondLoc.longitude
        : pickUp.longitude;

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;

    // Accommodate the two locations within the
    // camera view of the map
    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(
            northEastLatitude,
            northEastLongitude,
          ),
          southwest: LatLng(
            southWestLatitude,
            southWestLongitude,
          ),
        ),
        100.0,
      ),
    );
  }

  searchDropoff() async {
    location.Prediction? p = await PlacesAutocomplete.show(
        mode: Mode.overlay,
        context: context,
        apiKey: kGoogleApiKey,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search Ending Location',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white))),
        components: [location.Component(location.Component.country, "ph")]);

    location.GoogleMapsPlaces places = location.GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    location.PlacesDetailsResponse detail =
        await places.getDetailsByPlaceId(p!.placeId!);

    addMyMarker123(detail.result.geometry!.location.lat,
        detail.result.geometry!.location.lng);

    setState(() {
      drop = detail.result.name;

      dropOff = LatLng(detail.result.geometry!.location.lat,
          detail.result.geometry!.location.lng);
    });

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kGoogleApiKey,
      PointLatLng(secondLoc.latitude, secondLoc.longitude),
      PointLatLng(detail.result.geometry!.location.lat,
          detail.result.geometry!.location.lng),
    );
    if (result.points.isNotEmpty) {
      polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    }
    setState(() {
      _poly2 = Polyline(
          color: Colors.blue,
          polylineId: const PolylineId('route1'),
          points: polylineCoordinates,
          width: 4);
    });

    mapController!.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(detail.result.geometry!.location.lat,
            detail.result.geometry!.location.lng),
        18.0));

    double miny = (secondLoc.latitude <= dropOff.latitude)
        ? secondLoc.latitude
        : dropOff.latitude;
    double minx = (secondLoc.longitude <= dropOff.longitude)
        ? secondLoc.longitude
        : dropOff.longitude;
    double maxy = (secondLoc.latitude <= dropOff.latitude)
        ? dropOff.latitude
        : secondLoc.latitude;
    double maxx = (secondLoc.longitude <= dropOff.longitude)
        ? dropOff.longitude
        : secondLoc.longitude;

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;

    // Accommodate the two locations within the
    // camera view of the map
    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(
            northEastLatitude,
            northEastLongitude,
          ),
          southwest: LatLng(
            southWestLatitude,
            southWestLongitude,
          ),
        ),
        100.0,
      ),
    );
  }
}
