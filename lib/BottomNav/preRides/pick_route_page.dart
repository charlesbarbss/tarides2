import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tarides/BottomNav/preRides/map_page.dart';
import 'package:tarides/services/add_favs.dart';
import 'package:tarides/services/add_pedal.dart';
import 'package:tarides/services/add_ride.dart';
import 'package:tarides/utils/distance_calculations.dart';
import 'package:tarides/utils/get_location.dart';
import 'package:tarides/utils/time_calculation.dart';
import 'package:tarides/widgets/button_widget.dart';
import 'package:tarides/widgets/text_widget.dart';
import 'package:google_maps_webservice/places.dart' as location;
import 'package:tarides/widgets/toast_widget.dart';

import '../../utils/keys.dart';

class PickRouteScreeen extends StatefulWidget {
  String team1;
  String team2;
  String team1name;
  String team2name;

  PickRouteScreeen(
      {super.key,
      required this.team1,
      required this.team2,
      required this.team1name,
      required this.team2name});

  @override
  State<PickRouteScreeen> createState() => _PickRouteScreeenState();
}

class _PickRouteScreeenState extends State<PickRouteScreeen> {
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
  late Polyline _poly1 = const Polyline(polylineId: PolylineId('1'));
  late Polyline _poly2 = const Polyline(polylineId: PolylineId('2'));
  late Polyline _poly3 = const Polyline(polylineId: PolylineId('3'));

  Set<Marker> markers = {};

  List<LatLng> polylineCoordinates1 = [];
  List<LatLng> polylineCoordinates2 = [];
  List<LatLng> polylineCoordinates3 = [];
  PolylinePoints polylinePoints = PolylinePoints();

  late LatLng pickUp;
  GoogleMapController? mapController;
  late LatLng dropOff1;
  late LatLng dropOff2;
  late LatLng dropOff3;

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
                    PointLatLng(dropOff1.latitude, dropOff1.longitude));
            if (result.points.isNotEmpty) {
              polylineCoordinates1 = result.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }

            PolylineResult result1 =
                await polylinePoints.getRouteBetweenCoordinates(
                    kGoogleApiKey,
                    PointLatLng(dropOff1.latitude, dropOff1.longitude),
                    PointLatLng(dropOff2.latitude, dropOff2.longitude));
            if (result1.points.isNotEmpty) {
              polylineCoordinates2 = result1.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }
            PolylineResult result2 =
                await polylinePoints.getRouteBetweenCoordinates(
                    kGoogleApiKey,
                    PointLatLng(dropOff2.latitude, dropOff2.longitude),
                    PointLatLng(dropOff3.latitude, dropOff3.longitude));
            if (result2.points.isNotEmpty) {
              polylineCoordinates3 = result2.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }
            setState(() {
              _poly1 = Polyline(
                  color: Colors.blue,
                  polylineId: const PolylineId('route1'),
                  points: polylineCoordinates1,
                  width: 4);
              _poly2 = Polyline(
                  color: Colors.red,
                  polylineId: const PolylineId('route2'),
                  points: polylineCoordinates2,
                  width: 4);
              _poly3 = Polyline(
                  color: Colors.black,
                  polylineId: const PolylineId('route3'),
                  points: polylineCoordinates3,
                  width: 4);

              pickUp = value;
            });
          }
        },
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("pickup"),
        position: LatLng(lat1, long1),
        infoWindow: InfoWindow(title: 'Starting point', snippet: pickup)));
  }

  addMyMarker12(lat1, long1) async {
    markers.add(Marker(
        draggable: true,
        onDragEnd: (value) async {
          drop1 = await getAddressFromLatLng(value.latitude, value.longitude);

          if (polylineCoordinates1 != []) {
            PolylineResult result =
                await polylinePoints.getRouteBetweenCoordinates(
                    kGoogleApiKey,
                    PointLatLng(pickUp.latitude, pickUp.longitude),
                    PointLatLng(value.latitude, value.longitude));
            if (result.points.isNotEmpty) {
              polylineCoordinates1 = result.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }

            PolylineResult result1 =
                await polylinePoints.getRouteBetweenCoordinates(
                    kGoogleApiKey,
                    PointLatLng(value.latitude, value.longitude),
                    PointLatLng(dropOff2.latitude, dropOff2.longitude));
            if (result1.points.isNotEmpty) {
              polylineCoordinates2 = result1.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }
            PolylineResult result2 =
                await polylinePoints.getRouteBetweenCoordinates(
                    kGoogleApiKey,
                    PointLatLng(dropOff2.latitude, dropOff2.longitude),
                    PointLatLng(dropOff3.latitude, dropOff3.longitude));
            if (result2.points.isNotEmpty) {
              polylineCoordinates3 = result2.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }
            setState(() {
              _poly1 = Polyline(
                  color: Colors.blue,
                  polylineId: const PolylineId('route1'),
                  points: polylineCoordinates1,
                  width: 4);
              _poly2 = Polyline(
                  color: Colors.red,
                  polylineId: const PolylineId('route2'),
                  points: polylineCoordinates2,
                  width: 4);
              _poly3 = Polyline(
                  color: Colors.black,
                  polylineId: const PolylineId('route3'),
                  points: polylineCoordinates3,
                  width: 4);

              dropOff1 = value;
            });
          }
        },
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("dropOff"),
        position: LatLng(lat1, long1),
        infoWindow: InfoWindow(title: 'First Point', snippet: drop1)));
  }

  addMyMarker123(lat1, long1) async {
    markers.add(Marker(
        draggable: true,
        onDragEnd: (value) async {
          drop2 = await getAddressFromLatLng(value.latitude, value.longitude);

          if (polylineCoordinates1 != []) {
            PolylineResult result =
                await polylinePoints.getRouteBetweenCoordinates(
                    kGoogleApiKey,
                    PointLatLng(pickUp.latitude, pickUp.longitude),
                    PointLatLng(dropOff1.latitude, dropOff1.longitude));
            if (result.points.isNotEmpty) {
              polylineCoordinates1 = result.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }

            PolylineResult result1 =
                await polylinePoints.getRouteBetweenCoordinates(
                    kGoogleApiKey,
                    PointLatLng(dropOff1.latitude, dropOff1.longitude),
                    PointLatLng(value.latitude, value.longitude));
            if (result1.points.isNotEmpty) {
              polylineCoordinates2 = result1.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }
            PolylineResult result2 =
                await polylinePoints.getRouteBetweenCoordinates(
                    kGoogleApiKey,
                    PointLatLng(value.latitude, value.longitude),
                    PointLatLng(dropOff3.latitude, dropOff3.longitude));
            if (result2.points.isNotEmpty) {
              polylineCoordinates3 = result2.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }
            setState(() {
              _poly1 = Polyline(
                  color: Colors.blue,
                  polylineId: const PolylineId('route1'),
                  points: polylineCoordinates1,
                  width: 4);
              _poly2 = Polyline(
                  color: Colors.red,
                  polylineId: const PolylineId('route2'),
                  points: polylineCoordinates2,
                  width: 4);
              _poly3 = Polyline(
                  color: Colors.black,
                  polylineId: const PolylineId('route3'),
                  points: polylineCoordinates3,
                  width: 4);

              dropOff2 = value;
            });
          }
        },
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("dropOff1"),
        position: LatLng(lat1, long1),
        infoWindow: InfoWindow(title: 'Second Point', snippet: drop2)));
  }

  addMyMarker124(lat1, long1) async {
    markers.add(Marker(
        draggable: true,
        onDragEnd: (value) async {
          drop3 = await getAddressFromLatLng(value.latitude, value.longitude);

          if (polylineCoordinates1 != []) {
            PolylineResult result =
                await polylinePoints.getRouteBetweenCoordinates(
                    kGoogleApiKey,
                    PointLatLng(pickUp.latitude, pickUp.longitude),
                    PointLatLng(dropOff1.latitude, dropOff1.longitude));
            if (result.points.isNotEmpty) {
              polylineCoordinates1 = result.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }

            PolylineResult result1 =
                await polylinePoints.getRouteBetweenCoordinates(
                    kGoogleApiKey,
                    PointLatLng(dropOff1.latitude, dropOff1.longitude),
                    PointLatLng(dropOff2.latitude, dropOff2.longitude));
            if (result1.points.isNotEmpty) {
              polylineCoordinates2 = result1.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }
            PolylineResult result2 =
                await polylinePoints.getRouteBetweenCoordinates(
                    kGoogleApiKey,
                    PointLatLng(dropOff2.latitude, dropOff2.longitude),
                    PointLatLng(value.latitude, value.longitude));
            if (result2.points.isNotEmpty) {
              polylineCoordinates3 = result2.points
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();
            }
            setState(() {
              _poly1 = Polyline(
                  color: Colors.blue,
                  polylineId: const PolylineId('route1'),
                  points: polylineCoordinates1,
                  width: 4);
              _poly2 = Polyline(
                  color: Colors.red,
                  polylineId: const PolylineId('route2'),
                  points: polylineCoordinates2,
                  width: 4);
              _poly3 = Polyline(
                  color: Colors.black,
                  polylineId: const PolylineId('route3'),
                  points: polylineCoordinates3,
                  width: 4);

              dropOff3 = value;
            });
          }
        },
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("dropOff2"),
        position: LatLng(lat1, long1),
        infoWindow: InfoWindow(title: 'Third Point', snippet: drop3)));
  }

  late String pickup = '';
  late String drop1 = '';
  late String drop2 = '';
  late String drop3 = '';
  bool isclicked = false;
  @override
  Widget build(BuildContext context) {
    CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 14.4746,
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      TextWidget(
                        text: 'Rides',
                        fontSize: 24,
                        color: Colors.white,
                        fontFamily: 'Bold',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      onTap: (argument) async {
                        if (pickup == '') {
                          pickUp = argument;
                          pickup = await getAddressFromLatLng(
                              argument.latitude, argument.longitude);

                          addMyMarker1(argument.latitude, argument.longitude);

                          setState(() {});
                        } else if (drop1 == '') {
                          dropOff1 = argument;
                          drop1 = await getAddressFromLatLng(
                              argument.latitude, argument.longitude);

                          addMyMarker12(argument.latitude, argument.longitude);

                          setState(() {});
                        } else if (drop2 == '') {
                          dropOff2 = argument;
                          drop2 = await getAddressFromLatLng(
                              argument.latitude, argument.longitude);

                          addMyMarker123(argument.latitude, argument.longitude);

                          setState(() {});
                        } else if (drop3 == '') {
                          dropOff3 = argument;
                          drop3 = await getAddressFromLatLng(
                              argument.latitude, argument.longitude);

                          addMyMarker124(argument.latitude, argument.longitude);

                          PolylineResult result =
                              await polylinePoints.getRouteBetweenCoordinates(
                                  kGoogleApiKey,
                                  PointLatLng(
                                      pickUp.latitude, pickUp.longitude),
                                  PointLatLng(
                                      dropOff1.latitude, dropOff1.longitude));
                          if (result.points.isNotEmpty) {
                            polylineCoordinates1 = result.points
                                .map((point) =>
                                    LatLng(point.latitude, point.longitude))
                                .toList();
                          }

                          PolylineResult result1 =
                              await polylinePoints.getRouteBetweenCoordinates(
                                  kGoogleApiKey,
                                  PointLatLng(
                                      dropOff1.latitude, dropOff1.longitude),
                                  PointLatLng(
                                      dropOff2.latitude, dropOff2.longitude));
                          if (result1.points.isNotEmpty) {
                            polylineCoordinates2 = result1.points
                                .map((point) =>
                                    LatLng(point.latitude, point.longitude))
                                .toList();
                          }
                          PolylineResult result2 =
                              await polylinePoints.getRouteBetweenCoordinates(
                                  kGoogleApiKey,
                                  PointLatLng(
                                      dropOff2.latitude, dropOff2.longitude),
                                  PointLatLng(
                                      dropOff3.latitude, dropOff3.longitude));
                          if (result2.points.isNotEmpty) {
                            polylineCoordinates3 = result2.points
                                .map((point) =>
                                    LatLng(point.latitude, point.longitude))
                                .toList();
                          }
                          setState(() {
                            _poly1 = Polyline(
                                color: Colors.blue,
                                polylineId: const PolylineId('route1'),
                                points: polylineCoordinates1,
                                width: 4);
                            _poly2 = Polyline(
                                color: Colors.red,
                                polylineId: const PolylineId('route2'),
                                points: polylineCoordinates2,
                                width: 4);
                            _poly3 = Polyline(
                                color: Colors.black,
                                polylineId: const PolylineId('route3'),
                                points: polylineCoordinates3,
                                width: 4);
                          });
                        }
                      },
                      polylines: {_poly1, _poly2, _poly3},
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
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Align(
                              alignment: Alignment.topCenter,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextWidget(
                                                        text: 'TIME',
                                                        fontSize: 12,
                                                        color: Colors.amber,
                                                      ),
                                                      TextWidget(
                                                        text:
                                                            '${calculateTravelTimeInMinutes(calculateDistance(pickUp.latitude, pickUp.longitude, dropOff1.latitude, dropOff1.longitude), 0.30).toStringAsFixed(2)}hrs',
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
                                                        text:
                                                            '${calculateDistance(pickUp.latitude, pickUp.longitude, dropOff1.latitude, dropOff1.longitude).toStringAsFixed(2)}KM',
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
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextWidget(
                                                        text:
                                                            'AVG SPEED (km/h)',
                                                        fontSize: 12,
                                                        color: Colors.amber,
                                                      ),
                                                      TextWidget(
                                                        text: '0.0',
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
                                                        text: 'STOP',
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
                                                    dropOff1.latitude,
                                                    dropOff1.latitude,
                                                    drop1,
                                                    '${calculateDistance(pickUp.latitude, pickUp.longitude, dropOff1.latitude, dropOff1.longitude).toStringAsFixed(2)}KM',
                                                    '${calculateTravelTimeInMinutes(calculateDistance(pickUp.latitude, pickUp.longitude, dropOff1.latitude, dropOff1.longitude), 0.30).toStringAsFixed(2)}hrs');
                                                setState(() {
                                                  isclicked = false;
                                                });
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
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Align(
                              alignment: Alignment.topCenter,
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
                                                    const SizedBox(),
                                                    ButtonWidget(
                                                      color: pickup == '' ||
                                                              drop1 == '' ||
                                                              drop2 == '' ||
                                                              drop3 == ''
                                                          ? Colors.grey
                                                          : Colors.red,
                                                      fontSize: 12,
                                                      width: 50,
                                                      radius: 100,
                                                      height: 35,
                                                      label: 'Save route',
                                                      onPressed: () {
                                                        if (pickup != '' ||
                                                            drop1 != '' ||
                                                            drop2 != '' ||
                                                            drop3 != '') {
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
                                                              '1st Destination: $drop1',
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
                                                              '2nd Destination: $drop2',
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
                                                              '3rd Destination: $drop3',
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
                                                pickup != '' ||
                                                        drop1 != '' ||
                                                        drop2 != '' ||
                                                        drop3 != ''
                                                    ? ButtonWidget(
                                                        color: Colors.amber,
                                                        fontSize: 18,
                                                        width: 300,
                                                        radius: 15,
                                                        height: 50,
                                                        label: 'Confirm',
                                                        onPressed: () {
                                                          addRide(
                                                              pickUp.latitude,
                                                              pickUp.longitude,
                                                              pickup,
                                                              dropOff1.latitude,
                                                              dropOff1
                                                                  .longitude,
                                                              drop1,
                                                              dropOff2.latitude,
                                                              dropOff2
                                                                  .longitude,
                                                              drop2,
                                                              dropOff3.latitude,
                                                              dropOff3
                                                                  .longitude,
                                                              drop3,
                                                              '${calculateDistance(pickUp.latitude, pickUp.longitude, dropOff3.latitude, dropOff3.longitude).toStringAsFixed(2)}KM',
                                                              '${calculateTravelTimeInMinutes(calculateDistance(pickUp.latitude, pickUp.longitude, dropOff3.latitude, dropOff3.longitude), 0.30).toStringAsFixed(2)}hrs',
                                                              widget.team1,
                                                              widget.team2);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MapPage(
                                                                          location1:
                                                                              pickup,
                                                                          location2:
                                                                              drop1,
                                                                          location3:
                                                                              drop2,
                                                                          location4:
                                                                              drop3,
                                                                          distance:
                                                                              '${calculateDistance(pickUp.latitude, pickUp.longitude, dropOff3.latitude, dropOff3.longitude).toStringAsFixed(2)}KM',
                                                                          time:
                                                                              '${calculateTravelTimeInMinutes(calculateDistance(pickUp.latitude, pickUp.longitude, dropOff3.latitude, dropOff3.longitude), 0.30).toStringAsFixed(2)}hrs',
                                                                          poly1:
                                                                              _poly1,
                                                                          poly2:
                                                                              _poly2,
                                                                          poly3:
                                                                              _poly3,
                                                                          loc1:
                                                                              pickUp,
                                                                          loc2:
                                                                              dropOff1,
                                                                          loc3:
                                                                              dropOff2,
                                                                          loc4:
                                                                              dropOff3,
                                                                        )),
                                                          );
                                                        })
                                                    : const SizedBox()
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
                                                      isEqualTo: 'rides')
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
                                                            drop1 =
                                                                data.docs[index]
                                                                    ['end'];
                                                            drop2 =
                                                                data.docs[index]
                                                                    ['end1'];
                                                            drop3 =
                                                                data.docs[index]
                                                                    ['end2'];

                                                            pickUp = LatLng(
                                                                data.docs[index]
                                                                    [
                                                                    'startLat'],
                                                                data.docs[index]
                                                                    [
                                                                    'startLong']);

                                                            dropOff1 = LatLng(
                                                                data.docs[index]
                                                                    ['endLat'],
                                                                data.docs[index]
                                                                    [
                                                                    'endLong']);
                                                            dropOff2 = LatLng(
                                                                data.docs[index]
                                                                    ['endLat1'],
                                                                data.docs[index]
                                                                    [
                                                                    'endLong1']);
                                                            dropOff3 = LatLng(
                                                                data.docs[index]
                                                                    ['endLat2'],
                                                                data.docs[index]
                                                                    [
                                                                    'endLong2']);
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
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              5),
                                                                  child:
                                                                      TextWidget(
                                                                    text: 'to',
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Bold',
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
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
                                                                          'end2'],
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          'Bold',
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
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      text: 'Your Team',
                                      fontSize: 12,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextWidget(
                                      text: widget.team1name,
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'Bold',
                                    ),
                                  ],
                                ),
                                TextWidget(
                                  text: 'VS',
                                  fontSize: 18,
                                  color: Colors.amber,
                                  fontFamily: 'Bold',
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      text: 'Enemy Team',
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextWidget(
                                      text: widget.team2name,
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'Bold',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
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
                    dropOff1.latitude,
                    dropOff1.latitude,
                    drop1,
                    'rides',
                    dropOff2.latitude,
                    dropOff2.latitude,
                    drop2,
                    dropOff3.latitude,
                    dropOff3.latitude,
                    drop3,
                  );
                  Navigator.pop(context);
                  showToast('Routes saved!');
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
}
