import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tarides/services/add_ride.dart';
import 'package:tarides/utils/distance_calculations.dart';
import 'package:tarides/widgets/button_widget.dart';
import 'package:tarides/widgets/text_widget.dart';
import 'package:tarides/widgets/toast_widget.dart';

import '../../widgets/dialog_widget.dart';
import '../rides_pages/race_logs_page.dart';

class MapPage extends StatefulWidget {
  final LatLng loc1;
  final LatLng loc2;
  final LatLng loc3;
  final LatLng loc4;
  final String location1;
  final String location2;
  final String location3;
  final String location4;
  final Polyline poly1;
  final Polyline poly2;
  final Polyline poly3;
  String distance;
  String time;

  MapPage({
    super.key,
    required this.loc1,
    required this.location1,
    required this.location2,
    required this.location3,
    required this.location4,
    required this.distance,
    required this.time,
    required this.loc2,
    required this.loc3,
    required this.loc4,
    required this.poly1,
    required this.poly2,
    required this.poly3,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool hasloaded = false;

  @override
  void initState() {
    super.initState();
    addMyMarker1();
    addMyMarker12();
    addMyMarker123();
    addMyMarker124();

    determinePosition();
    setState(() {
      hasloaded = true;
    });
  }

  Set<Marker> markers = {};
  final searchController = TextEditingController();
  String nameSearched = '';

  bool isfinish = false;

  addMyMarker1() async {
    markers.add(Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("pickup"),
        position: LatLng(widget.loc1.latitude, widget.loc1.longitude),
        infoWindow: const InfoWindow(title: 'Pick-up Location')));
  }

  addMyMarker12() async {
    markers.add(Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("dropOff"),
        position: LatLng(widget.loc2.latitude, widget.loc2.longitude),
        infoWindow: const InfoWindow(title: 'Drop-off Location')));
  }

  addMyMarker123() async {
    markers.add(Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: const MarkerId("dropOff1"),
      position: LatLng(widget.loc3.latitude, widget.loc3.longitude),
    ));
  }

  addMyMarker124() async {
    markers.add(Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: const MarkerId("dropOff2"),
      position: LatLng(widget.loc4.latitude, widget.loc4.longitude),
    ));
  }

  double speed = 0;

  getSpeed() {
    Geolocator.getPositionStream().listen((position) {
      setState(() {
        speed = position.speed;
      });
    });
  }

  double lat = 0;
  double long = 0;
  getLocation() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      Geolocator.getCurrentPosition().then((position) {
        setState(() {
          lat = position.latitude;
          long = position.longitude;
        });
      }).catchError((error) {
        print('Error getting location: $error');
      });
    });
  }

  String id = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: hasloaded
          ? SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: GoogleMap(
                      polylines: {
                        widget.poly1,
                        widget.poly2,
                        widget.poly3,
                      },
                      markers: markers,
                      zoomControlsEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 235,
                      width: double.infinity,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            isfinish
                                ? Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color:
                                            Colors.brown[100]!.withOpacity(0.2),
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
                                                  text: widget.time,
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
                                                  text: widget.distance,
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
                                                  text: '$speed',
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
                                  )
                                : Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color:
                                            Colors.brown[100]!.withOpacity(0.2),
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
                                                  text: widget.time,
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
                                                  text: widget.distance,
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
                                                  text: '$speed',
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
                              height: 25,
                            ),
                            id == ''
                                ? ButtonWidget(
                                    width: 350,
                                    color: Colors.red,
                                    radius: 15,
                                    label: 'Start',
                                    onPressed: () async {
                                      getLocation();
                                      getSpeed();
                                      final docId = await addRide(
                                          widget.loc1.latitude,
                                          widget.loc1.longitude,
                                          widget.location1,
                                          widget.loc2.latitude,
                                          widget.loc2.longitude,
                                          widget.location2,
                                          widget.loc3.latitude,
                                          widget.loc3.longitude,
                                          widget.location3,
                                          widget.loc4.latitude,
                                          widget.loc4.longitude,
                                          widget.location4,
                                          widget.distance,
                                          widget.time,
                                          'Team 1',
                                          'Team 2');
                                      setState(() {
                                        isfinish = true;

                                        id = docId;
                                      });
                                    },
                                  )
                                : StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Rides')
                                        .doc(id)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (!snapshot.hasData) {
                                        return const SizedBox();
                                      } else if (snapshot.hasError) {
                                        return const Center(
                                            child:
                                                Text('Something went wrong'));
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox();
                                      }
                                      dynamic data = snapshot.data;
                                      return ButtonWidget(
                                        width: 350,
                                        color: Colors.red,
                                        radius: 15,
                                        label: 'Finish',
                                        onPressed: () async {
                                          if (calculateDistance(
                                                  lat,
                                                  long,
                                                  widget.loc4.latitude,
                                                  widget.loc4.longitude) <
                                              0.1) {
                                            if (data['winner'] == '') {
                                              await FirebaseFirestore.instance
                                                  .collection('Rides')
                                                  .doc(id)
                                                  .update({
                                                'winner': FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                'status': 'Finished',
                                                'endDateTime': DateTime.now(),
                                              });
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return DialogWidget(
                                                    image:
                                                        'assets/images/star 1.png',
                                                    title: 'WINNER!',
                                                    caption: 'CONGRATULATIONS!',
                                                    onpressed: () {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const RaceLogsPage()),
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return DialogWidget(
                                                    image:
                                                        'assets/images/urtle_svgrepo.com.png.png',
                                                    title: 'DEFEAT!',
                                                    caption:
                                                        'Better luck next time!',
                                                    onpressed: () {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const RaceLogsPage()),
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            }
                                          } else {
                                            showToast(
                                                'You are not in the finish line yet!');
                                          }
                                        },
                                      );
                                    })
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.3157, 123.8854),
    zoom: 14.4746,
  );

  showhangtightDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: 300,
            height: 225,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Group.png',
                    height: 100,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text:
                        'Hang tight! The host is mapping out the perfect course for your cycling showdown.',
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Bold',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
