import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tarides/services/add_favs.dart';
import 'package:tarides/services/add_pedal.dart';
import 'package:tarides/utils/distance_calculations.dart';
import 'package:tarides/utils/time_calculation.dart';
import 'package:tarides/widgets/button_widget.dart';
import 'package:tarides/widgets/text_widget.dart';
import 'package:google_maps_webservice/places.dart' as location;

import '../utils/keys.dart';

class PedalScreeen extends StatefulWidget {
  const PedalScreeen({super.key});

  @override
  State<PedalScreeen> createState() => _PedalScreeenState();
}

class _PedalScreeenState extends State<PedalScreeen> {
  late Polyline _poly = const Polyline(polylineId: PolylineId('new'));

  Set<Marker> markers = {};

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  late LatLng pickUp;
  GoogleMapController? mapController;
  late LatLng dropOff;

  addMyMarker1(lat1, long1) async {
    markers.add(Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("pickup"),
        position: LatLng(lat1, long1),
        infoWindow: const InfoWindow(title: 'Pick-up Location')));
  }

  addMyMarker12(lat1, long1) async {
    markers.add(Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("dropOff"),
        position: LatLng(lat1, long1),
        infoWindow: const InfoWindow(title: 'Drop-off Location')));
  }

  late String pickup = '';
  late String drop = '';
  bool isclicked = false;
  @override
  Widget build(BuildContext context) {
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
                      polylines: {_poly},
                      markers: markers,
                      zoomControlsEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
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
                                                      text:
                                                          '${calculateTravelTimeInMinutes(calculateDistance(pickUp.latitude, pickUp.longitude, dropOff.latitude, dropOff.longitude), 0.30).toStringAsFixed(2)}hrs',
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
                                                          '${calculateDistance(pickUp.latitude, pickUp.longitude, dropOff.latitude, dropOff.longitude).toStringAsFixed(2)}KM',
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
                                                  dropOff.latitude,
                                                  dropOff.latitude,
                                                  drop,
                                                  '${calculateDistance(pickUp.latitude, pickUp.longitude, dropOff.latitude, dropOff.longitude).toStringAsFixed(2)}KM',
                                                  '${calculateTravelTimeInMinutes(calculateDistance(pickUp.latitude, pickUp.longitude, dropOff.latitude, dropOff.longitude), 0.30).toStringAsFixed(2)}hrs');
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
                                          Column(
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
                                                    color: pickup == '' &&
                                                            drop == ''
                                                        ? Colors.grey
                                                        : Colors.red,
                                                    fontSize: 12,
                                                    width: 50,
                                                    radius: 100,
                                                    height: 35,
                                                    label: 'Save route',
                                                    onPressed: () {
                                                      if (pickup != '' &&
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
                                                  searchPickup();
                                                },
                                                child: Container(
                                                  height: 35,
                                                  width: 300,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
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
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  searchDropoff();
                                                },
                                                child: Container(
                                                  height: 35,
                                                  width: 300,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
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
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              ButtonWidget(
                                                color: Colors.red,
                                                fontSize: 18,
                                                width: 300,
                                                radius: 15,
                                                height: 50,
                                                label: 'Start',
                                                onPressed: () {
                                                  if (pickup != '' &&
                                                      drop != '') {
                                                    setState(() {
                                                      isclicked = true;
                                                    });
                                                  }
                                                },
                                              ),
                                            ],
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
                                                            drop =
                                                                data.docs[index]
                                                                    ['end'];
                                                            pickup =
                                                                data.docs[index]
                                                                    ['start'];

                                                            dropOff = LatLng(
                                                                data.docs[index]
                                                                    ['endLat'],
                                                                data.docs[index]
                                                                    [
                                                                    'endLong']);

                                                            pickUp = LatLng(
                                                                data.docs[index]
                                                                    [
                                                                    'startLat'],
                                                                data.docs[index]
                                                                    [
                                                                    'startLong']);
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
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 5),
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
                                                                          'end'],
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
                  addFav(pickUp.latitude, pickUp.longitude, pickup,
                      dropOff.latitude, dropOff.latitude, drop);
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

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  searchPickup() async {
    location.Prediction? p = await PlacesAutocomplete.show(
        mode: Mode.overlay,
        context: context,
        apiKey: kGoogleApiKey,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search Pick-up Location',
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

  searchDropoff() async {
    location.Prediction? p = await PlacesAutocomplete.show(
        mode: Mode.overlay,
        context: context,
        apiKey: kGoogleApiKey,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search Drop-off Location',
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
      drop = detail.result.name;

      dropOff = LatLng(detail.result.geometry!.location.lat,
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

    double miny = (pickUp.latitude <= dropOff.latitude)
        ? pickUp.latitude
        : dropOff.latitude;
    double minx = (pickUp.longitude <= dropOff.longitude)
        ? pickUp.longitude
        : dropOff.longitude;
    double maxy = (pickUp.latitude <= dropOff.latitude)
        ? dropOff.latitude
        : pickUp.latitude;
    double maxx = (pickUp.longitude <= dropOff.longitude)
        ? dropOff.longitude
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
}
