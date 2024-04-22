import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as cur;
import 'package:tarides/BottomNav/Goal30Tabs/directionsRepository.dart';
import 'package:tarides/BottomNav/Goal30Tabs/mapScreen.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/Model/directionsModel.dart';
import 'package:tarides/homePage.dart';
import 'package:path_provider/path_provider.dart';

class PedalScreen extends StatefulWidget {
  const PedalScreen({super.key, required this.email, this.location});

  final String email;
  final LocationData? location;

  @override
  State<PedalScreen> createState() => _PedalScreenState();
}

class _PedalScreenState extends State<PedalScreen> {
  UserController userController = UserController();
  final firstPinPoint = TextEditingController();
  final secondPinPoint = TextEditingController();
  final thirdPinPoint = TextEditingController();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  GoogleMapController? googleMapController;

  Marker? _origin;
  Marker? _destination;
  Marker? _finalDestination;
  Directions? _info;
  Directions? _info2;
  Directions? _info3;
  bool isStart = false;

  bool _isOriginButtonTapped = false;
  bool _isDestinationButtonTapped = false;
  bool _isFinalDestinationButtonTapped = false;

  LocationData? currentLocation;

  bool pin1topin2 = false;
  bool pin2topin3 = false;

  bool finishedRide = false;

  late Timer _timer;
  int _start = 0;

  final List<LatLng> polylinePoints = [];
  Position? currentPosition;

  final GlobalKey _globalKey = GlobalKey();

  bool proceed = false;

  final Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];

  void getCurrentLocation() async {
    cur.Location location = cur.Location();

    GoogleMapController googleMapController = await _controller.future;

    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );

    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        if (finishedRide == true) {
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 17.0,
              ),
            ),
          );

          // Add the new location to the polyline coordinates
          polylineCoordinates.add(
            LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          );

          // Create a new polyline with the updated coordinates and add it to the set
          Polyline polyline = Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blueAccent,
            width: 4,
            points: polylineCoordinates,
          );

          setState(() {
            _polylines.add(polyline);
          });
        }
      },
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 0) {
            timer.cancel();
          } else {
            _start = _start + 1;
          }
        },
      ),
    );
  }

  String formatTimer(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    userController.getUser(widget.email);
    getCurrentLocation();
    // getCurrentLocation();
    googleMapController?.dispose();

    super.initState();
  }

  void _addMarker(LatLng pos) async {
    final placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    final place = placemarks.first;
    final String fullAddress =
        '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}';

    if (_origin == null) {
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: InfoWindow(title: place.name),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        firstPinPoint.text = fullAddress;
        _destination = null;
        _info = null;
      });
    } else if (_destination == null) {
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: InfoWindow(title: place.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: pos,
        );
        secondPinPoint.text = fullAddress;
        _finalDestination = null;
        _info2 = null;
      });
      final directions = await DirectionsRepository().getDirections(
        origin: _origin!.position,
        destination: pos,
      );
      setState(() {
        _info = directions;
      });
    } else if (_finalDestination == null) {
      setState(() {
        _finalDestination = Marker(
          markerId: const MarkerId('finalDestination'),
          infoWindow: InfoWindow(title: place.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
        thirdPinPoint.text = fullAddress;
      });

      final directions2 = await DirectionsRepository().getDirections(
        origin: _destination!.position,
        destination: _finalDestination!.position,
      );

      setState(() {
        _info2 = directions2;
      });

      final directions3 = await DirectionsRepository().getDirections(
        origin: _origin!.position,
        destination: _finalDestination!.position,
      );
      _info3 = directions3;
      setState(() {
        _info3 = directions3;
      });
    }
  }

  bool hasShownSnackBar = false;
  bool reachPin2 = false;
  void finishedPin1toPin2() {
    double totalDistance =
        double.parse(_info!.totalDistance.replaceFirst(' km', ''));

    if (totalDistance <= locationService.totalDistanceTraveled &&
        reachPin2 == false) {
      setState(() {
        pin1topin2 = true;

        hasShownSnackBar = true;
        reachPin2 = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You are haflway there!'),
          ),
        );
      });
    }
  }

  bool hasShownSnackBar2 = false;

  void finishedPin2toPin3() {
    double totalDistance3 =
        double.parse(_info!.totalDistance.replaceFirst(' km', '')) +
            double.parse(_info2!.totalDistance.replaceFirst(' km', ''));

    if (totalDistance3 <= locationService.totalDistanceTraveled &&
        reachPin2 == true) {
      setState(() {
        pin2topin3 = true;
      });

      if (!hasShownSnackBar2) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Goal Completed!'),
            ),
          );
        });
        setState(() {
          hasShownSnackBar2 = true;
          finishedRide = false;
        });
      }
    }
  }

  final LocationService locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    late double totalKm;
    if (_info != null) {
      double totalDistance =
          double.parse(_info!.totalDistance.replaceAll('km', '').trim());
      print(totalDistance);
    }
    if (_info2 != null) {
      double totalDistance2 =
          double.parse(_info2!.totalDistance.replaceAll('km', '').trim());
      print(totalDistance2);
    }
    if (_info != null && _info2 != null) {
      totalKm = double.parse(_info!.totalDistance.replaceAll('km', '').trim()) +
          double.parse(_info2!.totalDistance.replaceAll('km', '').trim());
      print(totalKm);
    }
    if (_info != null && _info2 != null) {
      finishedPin1toPin2();
      finishedPin2toPin3();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text(
          'PedalScreen',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (_origin != null)
            IconButton(
              onPressed: () {
                setState(() {
                  _isOriginButtonTapped = true;
                  _isDestinationButtonTapped = false;
                  _isFinalDestinationButtonTapped = false;
                });
                googleMapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: _origin!.position, zoom: 14, tilt: 50),
                  ),
                );
              },
              icon: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: _isOriginButtonTapped ? 20 : 15,
                    backgroundColor: Colors.green[900],
                  ),
                  Text(
                    '1st',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          if (_destination != null)
            IconButton(
              onPressed: () {
                setState(() {
                  _isOriginButtonTapped = false;
                  _isDestinationButtonTapped = true;
                  _isFinalDestinationButtonTapped = false;
                });
                googleMapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: _destination!.position, zoom: 14, tilt: 50),
                  ),
                );
              },
              icon: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: _isDestinationButtonTapped ? 20 : 15,
                    backgroundColor: Colors.red[900],
                  ),
                  Text(
                    '2nd',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          if (_finalDestination != null)
            IconButton(
              onPressed: () {
                setState(() {
                  _isOriginButtonTapped = false;
                  _isDestinationButtonTapped = false;
                  _isFinalDestinationButtonTapped = true;
                });
                googleMapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: _finalDestination!.position,
                        zoom: 14,
                        tilt: 50),
                  ),
                );
              },
              icon: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: _isFinalDestinationButtonTapped ? 20 : 15,
                    backgroundColor: Colors.blue[900],
                  ),
                  Text(
                    '3rd',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          RepaintBoundary(
            key: _globalKey,
            child: GoogleMap(
              zoomControlsEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    widget.location!.latitude!, widget.location!.longitude!),
                zoom: 13.5,
              ),
              onMapCreated: (mapController) {
                googleMapController = mapController;
                _controller.complete(mapController);
              },
              markers: {
                if (_origin != null) _origin!,
                if (_destination != null) _destination!,
                if (_finalDestination != null) _finalDestination!,
              },
              polylines: {
                if (_info != null)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.red,
                    width: 6,
                    points: _info!.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
                if (_info2 != null)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline_2'),
                    color: Colors.red,
                    width: 6,
                    points: _info2!.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
                ..._polylines,
              },
              onTap: _addMarker,
            ),
          ),
          Positioned(
            top: 300,
            left: 300,
            child: FloatingActionButton(
              onPressed: () {
                googleMapController!.animateCamera(
                  _info3 != null
                      ? CameraUpdate.newLatLngBounds(_info3!.bounds, 150.0)
                      : CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(currentLocation!.latitude!,
                                currentLocation!.longitude!),
                            zoom: 17.0,
                          ),
                        ),
                );
              },
              child: Icon(Icons
                  .center_focus_strong), // Change this to your preferred icon
              backgroundColor:
                  Colors.yellow[800], // Change this to your preferred color
            ),
          ),
          if (_origin != null &&
              _destination != null &&
              _finalDestination != null &&
              proceed == false)
            Positioned(
              top: 240,
              left: 300,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _origin = null;
                    _destination = null;
                    _finalDestination = null;
                    _info = null;
                    _info2 = null;

                    firstPinPoint.clear();
                    secondPinPoint.clear();
                    thirdPinPoint.clear();
                  });
                },
                child:
                    Icon(Icons.reset_tv), // Change this to your preferred icon
                backgroundColor:
                    Colors.red[900], // Change this to your preferred color
              ),
            ),
          if (isStart == false)
            Positioned(
              top: 360.0,
              left: 10.0,
              right: 10.0,
              child: Container(
                height: 260,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'FIRST PIN POINT: ${firstPinPoint.text}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'SECOND PIN POINT:  ${secondPinPoint.text}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'THIRD PIN POINT: ${thirdPinPoint.text}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size.fromHeight(60),
                            maximumSize: const Size.fromWidth(350),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide.none,
                            ),
                            backgroundColor: Colors.red[900],
                          ),
                          onPressed: _info3 != null
                              ? () {
                                  setState(() {
                                    isStart = true;
                                    startTimer();
                                    proceed = true;
                                    finishedRide = true;
                                    getCurrentLocation();
                                  });
                                }
                              : () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Please select all the pin points'),
                                      ),
                                    );
                                  });
                                },
                          child: Text(
                            'Proceed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (isStart == true)
            Positioned(
              top: 360.0,
              left: 10.0,
              right: 10.0,
              child: Container(
                height: 265,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'TIME: ',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            formatTimer(_start),
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'AVGSPEED: ',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            '${locationService.averageSpeed!.toStringAsFixed(2)}  km/h',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    if (pin1topin2 == false)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              'TOTAL DISTANCE: Pin 1 to Pin 2',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              '${_info!.totalDistance}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    if (pin1topin2 == true)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              'DISTANCE: Pin 2 to Pin 3',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              totalKm.toString() + ' km',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'DISTANCE TRAVELED: ',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            locationService.totalDistanceTraveled
                                    .toStringAsFixed(2) +
                                ' km',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(50),
                          maximumSize: const Size.fromWidth(350),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide.none,
                          ),
                          backgroundColor: hasShownSnackBar2 == true
                              ? Colors.red[900]
                              : Colors.grey[900],
                        ),
                        onPressed: hasShownSnackBar2 == true
                            ? () async {
                                setState(() {
                                  _timer.cancel();
                                  finishedRide = false;
                                  locationService.stopTime();
                                });

                                googleMapController!.animateCamera(
                                    CameraUpdate.newLatLngBounds(
                                        _info3!.bounds, 80.0));
                                Future.delayed(Duration(seconds: 2), () async {
                                  RenderRepaintBoundary boundary = _globalKey
                                          .currentContext!
                                          .findRenderObject()
                                      as RenderRepaintBoundary;
                                  var image = await boundary.toImage();
                                  ByteData? byteData = await image.toByteData(
                                      format: ImageByteFormat.png);
                                  if (byteData != null) {
                                    Uint8List pngBytes =
                                        byteData.buffer.asUint8List();

                                    String dir =
                                        (await getApplicationDocumentsDirectory())
                                            .path;
                                    String timestamp = DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();
                                    File file =
                                        File('$dir/screenshot_$timestamp.png');

                                    // Write the bytes to the file
                                    await file.writeAsBytes(pngBytes);
                                    // Now you can use pngBytes to save the image as a file, share it, etc.

                                    final pedalHistoryId = FirebaseFirestore
                                        .instance
                                        .collection('pedalHistory')
                                        .doc()
                                        .id;
                                    final storageRef = FirebaseStorage.instance
                                        .ref()
                                        .child('user_pedal_history')
                                        .child('$pedalHistoryId.jpg');
                                    await storageRef.putFile(file);
                                    final imageUrl =
                                        await storageRef.getDownloadURL();

                                    await FirebaseFirestore.instance
                                        .collection('pedalHistory')
                                        .add({
                                      'time': formatTimer(_start),
                                      'averageSpeed': locationService
                                          .averageSpeed!
                                          .toStringAsFixed(2),
                                      'totalDistance':
                                          totalKm.toStringAsFixed(2) + ' km',
                                      'id': FirebaseFirestore.instance
                                          .collection('pedalHistory')
                                          .doc()
                                          .id,
                                      'imageGoal': imageUrl,
                                      'username': userController.user.username,
                                      'dateDone': Timestamp.now(),
                                    });
                                  }
                                }).then((value) {
                                  Future.delayed(Duration(seconds: 3), () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(
                                          email: widget.email,
                                          homePageIndex: 2,
                                        ),
                                      ),
                                    );
                                  });
                                });
                              }
                            : () {},
                        child: Text(
                          'Finished',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    //       if (isStart == true)
    //         Positioned(
    //           top: 1,
    //           child: FloatingActionButton(
    //             onPressed: () {
    //                 Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomePage(
    //     email: widget.email,
    //     homePageIndex: 2,
    //   )),
    // );
    //             },
    //             child: Text(
    //               'Reset',
    //               style: TextStyle(color: Colors.white),
    //             ), // Change this to your preferred icon
    //             backgroundColor:
    //                 Colors.red[800], // Change this to your preferred color
    //           ),
    //         )
        ],
      ),
    );
  }
}
