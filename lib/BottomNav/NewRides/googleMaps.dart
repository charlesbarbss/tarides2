import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:tarides/BottomNav/Goal30Tabs/directionsRepository.dart';
import 'package:tarides/BottomNav/NewRides/racePage.dart';
import 'package:tarides/Controller/communityController.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/Model/directionsModel.dart';
import 'package:tarides/Model/ridesModel.dart';
import 'package:tarides/Model/userModel.dart';
import 'package:tarides/utils/distance_calculations.dart';
import 'package:tarides/widgets/text_widget.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Goal30Tabs/mapScreen.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen(
      {super.key,
      required this.locationUser,
      required this.isHost,
      required this.ride,
      required this.totalDistance,
      required this.totalDuration});
  final LocationData locationUser;

  final bool isHost;
  final Rides ride;
  final String totalDistance;
  final String totalDuration;

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  UserController userController = UserController();
  CommunityController communityController = CommunityController();
  UserController getUsersWithCommunity = UserController();
  List<Users> usersWithCommunity = [];

  final firstPinPoint = TextEditingController();
  final secondPinPoint = TextEditingController();
  final thirdPinPoint = TextEditingController();
  Marker? _host;
  Marker? _enemy;
  Marker? _origin;
  Marker? _destination;
  Marker? _finalDestination;
  Directions? _info;
  Directions? _info2;
  Directions? _info3;
  Directions? _enemyDirections;

  int _tapCounter = 0;
  LatLng? _startPoint;
  LatLng? _midPoint;
  LatLng? _endPoint;
  var distance2 = '';

  double? startLat;
  double? startLng;
  double? midLat;
  double? midLng;
  double? endLat;
  double? endLng;

  bool polyline = false;
  bool isContinue = false;

  var select = 1;
  loc.Location location = loc.Location();
  @override
  void initState() {
    super.initState();
    if (widget.isHost == true) {
      location.onLocationChanged.listen((LocationData currentLocation) {
        print(
            'Current location: ${currentLocation.latitude}, ${currentLocation.longitude}');
        FirebaseFirestore.instance
            .collection('rides')
            .where('idRides', isEqualTo: widget.ride.idRides)
            .get()
            .then((value) {
          value.docs.forEach(
            (element) {
              element.reference.update({
                'hostLat': currentLocation.latitude,
                'hostLng': currentLocation.longitude,
              });
            },
          );
        });

        _host = Marker(
          markerId: const MarkerId('currentLocation'),
          position:
              LatLng(currentLocation.latitude!, currentLocation.longitude!),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );
      });
    } else {
      location.onLocationChanged.listen((LocationData enemyLocation) {
        print(
            'Enemy location: ${enemyLocation.latitude}, ${enemyLocation.longitude}');
        FirebaseFirestore.instance
            .collection('rides')
            .where('idRides', isEqualTo: widget.ride.idRides)
            .get()
            .then((value) {
          value.docs.forEach(
            (element) {
              element.reference.update({
                'enemyLat': enemyLocation.latitude,
                'enemyLng': enemyLocation.longitude,
              });
            },
          );
        });

        _enemy = Marker(
          markerId: const MarkerId('enemyLocation'),
          position: LatLng(enemyLocation.latitude!, enemyLocation.longitude!),
        );
      });
    }
  }

  final LocationService locationService = LocationService();
  // double totalDistanceTraveled = 0.0;
  // void locationServiceRides() {
  //   loc.Location location = loc.Location();

  //   double? averageSpeed;
  //   loc.LocationData? lastLocation = widget.locationUser;
  //   DateTime? startTime;
  //   StreamSubscription<loc.LocationData>? locationSubscription;

  //   LocationService() {
  //     locationSubscription =
  //         location.onLocationChanged.listen((loc.LocationData currentLocation) {
  //       if (lastLocation != null) {
  //         totalDistanceTraveled += calculateDistance(
  //           lastLocation!.latitude!,
  //           lastLocation!.longitude!,
  //           currentLocation.latitude!,
  //           currentLocation.longitude!,
  //         );
  //       }
  //       lastLocation = currentLocation;

  //       if (startTime == null) {
  //         startTime = DateTime.now();
  //       } else {
  //         final durationInSeconds =
  //             DateTime.now().difference(startTime!).inSeconds;
  //         if (durationInSeconds > 0) {
  //           averageSpeed = totalDistanceTraveled /
  //               durationInSeconds *
  //               3600; // Speed in km/h
  //         }
  //       }
  //     });
  //   }
  //   //    void stopTime() {
  //   //   locationSubscription?.cancel();
  //   //   locationSubscription = null;
  //   // }

  //   // double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  //   //   var p = 0.017453292519943295;
  //   //   var c = cos;
  //   //   var a = 0.5 -
  //   //       c((lat2 - lat1) * p) / 2 +
  //   //       c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  //   //   return 12742 * asin(sqrt(a));
  //   // }
  // }
  // void getDirectionsAndSetInfo() async {
  //   final directions = await DirectionsRepository().getDirections(
  //     origin: LatLng(startLat!, startLng!),
  //     destination: LatLng(midLat!, midLng!),
  //   );

  //   Provider.of<InfoController>(context, listen: false).setInfo(directions);
  // }

  @override
  Widget build(BuildContext context) {
    // locationServiceRides();
    print('KININININININIINNININI+${locationService.totalDistanceTraveled}');
    print(locationService.totalDistanceTraveled);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Pick a Route',
          fontSize: 24,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      // GoogleMap(
      //     initialCameraPosition: CameraPosition(
      //   target: LatLng(
      //     widget.locationUser.latitude ?? 0.0,
      //     widget.locationUser.longitude ?? 0.0,
      //   ),
      //   zoom: 14.4746,
      // ));
      body: Stack(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('rides')
                .doc(widget.ride.id)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;

              // Check if data contains polylinePoints for enemy's ride
              if (data['enemyPolylinePoints'] != null) {
                _enemyDirections = Directions(
                  polylinePoints: (data['enemyPolylinePoints'] as List)
                      .map((e) => PointLatLng(e['latitude'], e['longitude']))
                      .toList(),
                  bounds: LatLngBounds(
                      northeast: const LatLng(0, 0),
                      southwest: const LatLng(0, 0)),
                  totalDistance: '',
                  totalDuration: '',
                );
              }

              if (data['hostLat'] != null && data['hostLng'] != null) {
                _host = Marker(
                  markerId: const MarkerId('host'),
                  position: LatLng(data['hostLat'], data['hostLng']),
                  infoWindow: const InfoWindow(title: 'You'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue,
                  ),
                );
              }
              if (data['enemyLat'] != null && data['enemyLng'] != null) {
                _enemy = Marker(
                  markerId: const MarkerId('enemy'),
                  position: LatLng(data['enemyLat'], data['enemyLng']),
                  infoWindow: const InfoWindow(title: 'Enemy'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                );
              }
              if (data['startPointLat'] != null &&
                  data['startPointLng'] != null) {
                _origin = Marker(
                  markerId: const MarkerId('startPoint'),
                  position:
                      LatLng(data['startPointLat'], data['startPointLng']),
                  infoWindow: const InfoWindow(title: 'Start Point'),
                );
              }
              if (data['midPointLat'] != null && data['midPointLng'] != null) {
                _destination = Marker(
                  markerId: const MarkerId('midPoint'),
                  position: LatLng(data['midPointLat'], data['midPointLng']),
                  infoWindow: const InfoWindow(title: 'Mid Point'),
                );
                startLat = data['startPointLat'];
                startLng = data['startPointLng'];
                midLat = data['midPointLat'];
                midLng = data['midPointLng'];
              }
              if (data['endPointLat'] != null && data['endPointLng'] != null) {
                _finalDestination = Marker(
                  markerId: const MarkerId('endPoint'),
                  position: LatLng(data['endPointLat'], data['endPointLng']),
                  infoWindow: const InfoWindow(title: 'End Point'),
                );
              }

              void addMarker(LatLng pos) async {
                if (widget.isHost == true) {
                  final placemarks = await placemarkFromCoordinates(
                      pos.latitude, pos.longitude);
                  final place = placemarks.first;
                  final String fullAddress =
                      '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}';

                  if (data['startPointLat'] == 0 &&
                      data['startPointLng'] == 0) {
                    _origin = Marker(
                      markerId: const MarkerId('origin'),
                      infoWindow: InfoWindow(title: place.name),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen),
                      position: pos,
                    );
                    firstPinPoint.text = fullAddress;
                    _destination = null;
                    _info = null;

                    FirebaseFirestore.instance
                        .collection('rides')
                        .doc(widget.ride.id)
                        .update(
                      {
                        'startPointLat': _origin!.position.latitude,
                        'startPointLng': _origin!.position.longitude,
                        'startText': firstPinPoint.text,
                      },
                    );

                    select = 2;
                  } else if (data['midPointLat'] == 0 &&
                      data['midPointLng'] == 0) {
                    _destination = Marker(
                      markerId: const MarkerId('destination'),
                      infoWindow: InfoWindow(title: place.name),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed),
                      position: pos,
                    );
                    secondPinPoint.text = fullAddress;
                    _finalDestination = null;
                    _info2 = null;

                    FirebaseFirestore.instance
                        .collection('rides')
                        .doc(widget.ride.id)
                        .update(
                      {
                        'midPointLat': _destination!.position.latitude,
                        'midPointLng': _destination!.position.longitude,
                        'midText': secondPinPoint.text,
                      },
                    ).then((value) async {
                      // print('111111111111111111111111111111111');
                      // print(data['startPointLat']);
                      // print(data['startPointLng']);
                      // print('midddd ${data['midPointLat']}');
                      // print(data['midPointLng']);
                      // final directions1 =
                      //     await DirectionsRepository().getDirections(
                      //   origin:
                      //       LatLng(data['startPointLat'], data['startPointLng']),
                      //   destination:
                      //       LatLng(data['midPointLat'], data['midPointLng']),
                      // );

                      // setState(() {
                      //   _info = directions1;
                      // });
                    });

                    // // Fetch origin and destination from Firebase
                    // final startPointLat = data['startPointLat'];
                    // final startPointLng = data['startPointLng'];

                    // final midPointLat = data['midPointLat'];
                    // final midPointLng = data['midPointLng'];

                    // print('startPointLat: $startPointLat');
                    // print('startPointLng: $startPointLng');
                    // LatLng origin = LatLng(startPointLat, startPointLng);
                    // LatLng destination = LatLng(midPointLat, midPointLng);

                    // final directions1 =
                    //     await DirectionsRepository().getDirections(
                    //   origin: LatLng(origin.latitude, origin.longitude),
                    //   destination:
                    //       LatLng(destination.latitude, destination.longitude),
                    // );
                    // print(directions1);
                    // setState(() {
                    //   _info = directions1;
                    // });
                    // Update polylines from start point to midpoint
                    // if (_origin != null && _destination != null) {
                    //   final directions1 =
                    //       await DirectionsRepository().getDirections(
                    //     origin: _origin!.position,
                    //     destination: _destination!.position,
                    //   );
                    //   setState(() {
                    //     _info = directions1;
                    //   });
                    // }

                    select = 3;
                  } else if (data['endPointLat'] == 0 &&
                      data['endPointLng'] == 0) {
                    print('nisud ba ka diri nga function?');
                    _finalDestination = Marker(
                      markerId: const MarkerId('finalDestination'),
                      infoWindow: InfoWindow(title: place.name),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueYellow),
                      position: pos,
                    );
                    thirdPinPoint.text = fullAddress;
                    print('midLat: $midLat');
                    final directions2 =
                        await DirectionsRepository().getDirections(
                      origin: LatLng(midLat!, midLng!),
                      destination: LatLng(midLat!, midLng!),
                    );
                    // setState(() {
                    _info2 = directions2;
                    // });

                    if (_finalDestination != null) {
                      FirebaseFirestore.instance
                          .collection('rides')
                          .doc(widget.ride.id)
                          .update(
                        {
                          'endPointLat': _finalDestination!.position.latitude,
                          'endPointLng': _finalDestination!.position.longitude,
                          'endText': thirdPinPoint.text,
                        },
                      );
                    }
                    // if (_destination != null && _finalDestination != null) {
                    //   final directions3 =
                    //       await DirectionsRepository().getDirections(
                    //     origin: _destination!.position,
                    //     destination: _finalDestination!.position,
                    //   );
                    //   setState(() {
                    //     _info2 = directions3;
                    //   });
                    // }
                  } else {
                    FirebaseFirestore.instance
                        .collection('rides')
                        .doc(widget.ride.id)
                        .update(
                      {
                        'startPointLat': 0.0,
                        'startPointLng': 0.0,
                        'midPointLat': 0.0,
                        'midPointLng': 0.0,
                        'endPointLat': 0.0,
                        'endPointLng': 0.0,
                        'startText': '',
                        'midText': '',
                        'endText': '',
                      },
                    ).then((value) {
                      setState(() {
                        _origin = null;
                        _midPoint = null;
                        _finalDestination = null;
                        _info = null;
                        _info2 = null;
                        polyline = false;
                        firstPinPoint.clear();
                        secondPinPoint.clear();
                        thirdPinPoint.clear();
                      });
                    });
                  }
                }
              }

              print(
                  'KININININININIINNININI+${locationService.totalDistanceTraveled}');
              print(locationService.totalDistanceTraveled);
              Future<void> allPolylineUpdate1() async {
                print('111111111111111111111111111111111');
                print(data['startPointLat']);
                print(data['startPointLng']);
                print('midddd ${data['midPointLat']}');
                print(data['midPointLng']);
                final directions1 = await DirectionsRepository().getDirections(
                  origin: LatLng(data['startPointLat'], data['startPointLng']),
                  destination: LatLng(data['midPointLat'], data['midPointLng']),
                );
                setState(() {
                  _info = directions1;
                });
              }

              Future<void> allPolylineUpdate2() async {
                print('1111111111');
                final directions2 = await DirectionsRepository().getDirections(
                  origin: LatLng(data['midPointLat'], data['midPointLng']),
                  destination: LatLng(data['endPointLat'], data['endPointLng']),
                );
                setState(() {
                  _info2 = directions2;
                  polyline = true;
                });
              }

              print('startPointLat: ${data['startPointLat']}');
              print('startPointLng: ${data['startPointLng']}');
              print('midPointLat: ${data['midPointLat']}');
              print('midPointLng: ${data['midPointLng']}');
              print('endPointLat: ${data['endPointLat']}');
              print('endPointLng: ${data['endPointLng']}');
              print(polyline);

              // }
              if (data['startPointLat'].toString() != '0.0' &&
                  data['midPointLat'].toString() != '0.0' &&
                  data['endPointLat'].toString() != '0.0' &&
                  polyline == false) {
                print('222222222222222222222222222222');
                allPolylineUpdate1();
                allPolylineUpdate2();
              }

              double calculateDistance(lat1, lon1, lat2, lon2) {
                var p = 0.017453292519943295;
                var c = cos;
                var a = 0.5 -
                    c((lat2 - lat1) * p) / 2 +
                    c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
                return 12742 * asin(sqrt(a));
              }

              Future<void> getDistance() async {
                String origin = widget.isHost == true
                    ? '${data['hostLat']},${data['hostLng']}'
                    : '${data['enemyLat']},${data['enemyLng']}'; // replace with the origin address
                ; // replace with the origin address
                String destination =
                    '${data['endPointLat']},${data['endPointLng']}'; // replace with the destination address

                // data['hostLat'] != data['startPointLat']
                //     ? '${data['startPointLat']},${data['startPointLng']}'
                //     : data['hostLat'] != data['midPointLat']
                //         ? '${data['midPointLat']},${data['midPointLng']}'
                //         : data['hostLat'] != data['endPointLat']
                //             ? '${data['endPointLat']},${data['endPointLng']}'
                //             : '';
                // replace with the destination address
                String apiKey =
                    'AIzaSyDdXaMN5htLGHo8BkCfefPpuTauwHGXItU'; // replace with your Google Maps API key

                String url =
                    'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey';

                final response = await http.get(Uri.parse(url));

                if (response.statusCode == 200) {
                  var decodedResponse = json.decode(response.body);

                  if (decodedResponse['routes'].isEmpty) {
                    throw Exception(
                        'No routes returned from the Directions API');
                  }

                  var routes = decodedResponse['routes'];

                  if (routes[0]['legs'].isEmpty) {
                    throw Exception('No legs returned for the first route');
                  }

                  var legs = routes[0]['legs'];
                  distance2 = legs[0]['distance']['text'];

                  print('Distance: $distance2');
                } else {
                  throw Exception('Failed to load distance');
                }
              }

              getDistance();

              return Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        widget.isHost == true
                            ? (data['hostLat'] ?? 0.0)
                            : (data['enemyLat'] ?? 0.0),
                        widget.isHost == true
                            ? (data['hostLng'] ?? 0.0)
                            : (data['enemyLng'] ?? 0.0),
                      ),
                      zoom: 14.4746,
                    ),
                    markers: {
                      if (_host != null) _host!,
                      if (_enemy != null) _enemy!,
                      if (_origin != null) _origin!,
                      if (_destination != null) _destination!,
                      if (_finalDestination != null) _finalDestination!,
                    },
                    onTap: addMarker,
                    polylines: {
                      if (_info != null)
                        Polyline(
                          polylineId: const PolylineId('overview_polyline_1'),
                          color: Colors.red,
                          width: 5,
                          points: _info!.polylinePoints
                              .map((e) => LatLng(e.latitude, e.longitude))
                              .toList(),
                        ),
                      if (_info2 != null)
                        Polyline(
                          polylineId: const PolylineId('overview_polyline_2'),
                          color: Colors.green,
                          width: 5,
                          points: _info2!.polylinePoints
                              .map((e) => LatLng(e.latitude, e.longitude))
                              .toList(),
                        ),
                      // if (_enemyDirections != null)
                      //   Polyline(
                      //     polylineId: const PolylineId('overview_polyline_enemy'),
                      //     color: Colors.blue, // Choose a color for enemy's route
                      //     width: 5,
                      //     points: _enemyDirections!.polylinePoints
                      //         .map((e) => LatLng(e.latitude, e.longitude))
                      //         .toList(),
                      //   ),
                    },
                  ),
                  if (isContinue == false)
                    Positioned(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 350,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // const Color.fromARGB(255, 40, 40, 40),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: double.infinity,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Expanded(
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_rounded,
                                              color: Color.fromARGB(
                                                  255, 232, 170, 5),
                                              size: 24,
                                            ), // Add your icon here
                                            const SizedBox(width: 10.0),
                                            // Add some space between the icon and the text
                                            Flexible(
                                              child: TextWidget(
                                                text: data['startText'] == ''
                                                    ? 'Start'
                                                    : data['startText'],
                                                fontSize: 12,
                                                fontFamily: 'Bold',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: double.infinity,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Expanded(
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_rounded,
                                              color: Color.fromARGB(
                                                  255, 232, 170, 5),
                                              size: 24,
                                            ), // Add your icon here
                                            const SizedBox(
                                                width:
                                                    10.0), // Add some space between the icon and the text
                                            Flexible(
                                              child: TextWidget(
                                                text: data['midText'] == ''
                                                    ? 'Mid'
                                                    : data['midText'],
                                                fontSize: 12,
                                                fontFamily: 'Bold',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: double.infinity,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Expanded(
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_rounded,
                                              color: Color.fromARGB(
                                                  255, 232, 170, 5),
                                              size: 24,
                                            ), // Add your icon here
                                            const SizedBox(
                                                width:
                                                    10.0), // Add some space between the icon and the text
                                            Flexible(
                                              child: TextWidget(
                                                text: data['endText'] == ''
                                                    ? 'End'
                                                    : data['endText'],
                                                fontSize: 12,
                                                fontFamily: 'Bold',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('rides')
                                            .where('idRides',
                                                isEqualTo: widget.ride.idRides)
                                            .get()
                                            .then((value) {
                                          value.docs.forEach(
                                            (element) {
                                              element.reference.update({
                                                'isPickingRoute': true,
                                              });
                                            },
                                          );
                                        }).then((value) => setState(() {
                                                  isContinue = true;
                                                }));
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 232, 155, 5),
                                      ),
                                      child: TextWidget(
                                        text: 'Continue',
                                        fontSize: 18,
                                        fontFamily: 'Bold',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // if(isContinue == true)
                  // Positioned(child: child)
                  // add UI RACE
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}