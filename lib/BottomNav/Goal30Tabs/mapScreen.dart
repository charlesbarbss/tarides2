import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:location/location.dart' as cur;

import 'package:tarides/BottomNav/Goal30Tabs/directionsRepository.dart';
import 'package:tarides/BottomNav/Goal30Tabs/goal30Data.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/Model/directionsModel.dart';
import 'dart:async';

import 'package:tarides/Model/goal30Model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tarides/homePage.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key,
      required this.height,
      required this.weight,
      required this.result,
      required this.bmiCategory,
      required this.goal30,
      required this.day,
      required this.email,
      required this.location});
  final String height;
  final String weight;
  final String result;
  final String bmiCategory;
  final Goal30 goal30;
  final int day;

  final String email;
  final LocationData? location;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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

  late double met;
  late double hours;
  late double tee;
  late double caloriesBurned;
  void calculateCalories() {
    setState(() {
      // Get MET
      if (locationService.averageSpeed! >= 16 &&
          locationService.averageSpeed! <= 19) {
        met = 6.0;
      } else if (locationService.averageSpeed! > 19) {
        met = 8.0;
      } else {
        met = 1.0;
      }

      // Calculate hours, tee, and caloriesBurned
      hours = (_start / 3600).toDouble();
      tee = met * double.parse(widget.weight) * hours;
      caloriesBurned = tee;
    });
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
      print(totalKm.toStringAsFixed(1));
      print(widget.goal30.goalLength == 30
          ? goal30[widget.day - 1].kmGoal
          : widget.goal30.goalLength == 60
              ? goal60[widget.day - 1].kmGoal
              : goal90[widget.day - 1].kmGoal);
    }
    if (_info != null && _info2 != null) {
      finishedPin1toPin2();
      finishedPin2toPin3();
    }
    int dayMinusOne = widget.day - 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'MapScreen',
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
                        target: _origin!.position, zoom: 20, tilt: 50),
                  ),
                );
              },
              icon: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: _isOriginButtonTapped ? 14 : 15,
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
            top: 440,
            left: 350,
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
              top: 380,
              left: 350,
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
              top: 510.0,
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
                          onPressed: () {
                            if (widget.goal30.goalLength == 30 &&
                                totalKm >= goal30[widget.day - 1].kmGoal) {
                              setState(() {
                                isStart = true;
                                startTimer();
                                proceed = true;
                                finishedRide = true;
                                getCurrentLocation();
                              });
                            } else if (widget.goal30.goalLength == 60 &&
                                totalKm >= goal60[widget.day - 1].kmGoal) {
                              setState(() {
                                isStart = true;
                                startTimer();
                                proceed = true;
                                finishedRide = true;
                                getCurrentLocation();
                              });
                            } else if (widget.goal30.goalLength == 90 &&
                                totalKm >= goal90[widget.day - 1].kmGoal) {
                              setState(() {
                                isStart = true;
                                startTimer();
                                proceed = true;
                                finishedRide = true;
                                getCurrentLocation();
                              });
                            } else
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'You have not reached the goal yet',
                                  ),
                                ),
                              );
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
              top: 500.0,
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
                              totalKm.toStringAsFixed(2) + ' km',
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
                                  calculateCalories();
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

// F O M U L A  S A  P A G K U H A  N A K O  S A  C A L O R I E S  B U R N

                                    // late double met;
                                    // void getMet() {
                                    //   if (locationService.averageSpeed! >= 16 &&
                                    //       locationService.averageSpeed! <= 19) {
                                    //     met = 6.0;
                                    //   } else if (locationService.averageSpeed! >
                                    //       19) {
                                    //     met = 8.0;
                                    //   } else {
                                    //     met = 1.0;
                                    //   }
                                    // }

                                    // late double hours =
                                    //     (_start / 3600).toDouble();
                                    // late double tee = met *
                                    //     double.parse(widget.weight) *
                                    //     hours;

                                    // late double caloriesBurned = tee * 1;

// K U T O B  R A  A R I

                                    final goal30HistoryId = FirebaseFirestore
                                        .instance
                                        .collection('goal30')
                                        .doc()
                                        .id;
                                    final storageRef = FirebaseStorage.instance
                                        .ref()
                                        .child('user_goal30_history')
                                        .child('$goal30HistoryId.jpg');
                                    await storageRef.putFile(file);
                                    final imageUrl =
                                        await storageRef.getDownloadURL();

                                    await FirebaseFirestore.instance
                                        .collection('goal30History')
                                        .add({
                                      'height': widget.height,
                                      'weight': widget.weight,
                                      'result': widget.result,
                                      'bmiCategory': widget.bmiCategory,
                                      'time': formatTimer(_start),
                                      'averageSpeed': locationService
                                          .averageSpeed!
                                          .toStringAsFixed(2),
                                      'totalDistance':
                                          totalKm.toStringAsFixed(2) + ' km',
                                      'day': widget.day.toString(),
                                      'id': FirebaseFirestore.instance
                                          .collection('goal30History')
                                          .doc()
                                          .id,
                                      'imageGoal': imageUrl,
                                      'user': userController.user.username,
                                      'dateDone': Timestamp.now(),
                                      'caloriesBurn':
                                          caloriesBurned.toStringAsFixed(2) +
                                              ' kcal',
                                    });
                                  }
                                });
                                final goal30Doc = await FirebaseFirestore
                                    .instance
                                    .collection('goal30')
                                    .where('username',
                                        isEqualTo: widget.goal30.username)
                                    .get();

                                await goal30Doc.docs.first.reference.update({
                                  'day${widget.day}': true,
                                }).then((value) {
                                  Future.delayed(Duration(seconds: 3), () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(
                                          email: widget.email,
                                          homePageIndex: 3,
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
          if (_info != null)
            Positioned(
              top: 50.0,
              left: 0.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'pin1 to pin2: ${_info!.totalDistance}',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          if (_info2 != null)
            Positioned(
              top: 100.0,
              left: 0.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[500],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'pin2 to pin3: ${_info2!.totalDistance}',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                'Todays Goal ${widget.goal30.goalLength == 30 ? goal30[widget.day - 1].kmGoal.toString() : widget.goal30.goalLength == 60 ? goal60[widget.day - 1].kmGoal.toString() : goal90[widget.day - 1].kmGoal.toString()} km',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationService {
 
 

  loc.Location location = loc.Location();

  double totalDistanceTraveled = 0.0;
  double? averageSpeed;
  loc.LocationData? lastLocation;
  DateTime? startTime;
  StreamSubscription<loc.LocationData>? locationSubscription;
  LocationService() {
    locationSubscription =
        location.onLocationChanged.listen((loc.LocationData currentLocation) {
      if (lastLocation != null) {
        totalDistanceTraveled += calculateDistance(
          lastLocation!.latitude!,
          lastLocation!.longitude!,
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
      }
      lastLocation = currentLocation;

      if (startTime == null) {
        startTime = DateTime.now();
      } else {
        final durationInSeconds =
            DateTime.now().difference(startTime!).inSeconds;
        if (durationInSeconds > 0) {
          averageSpeed =
              totalDistanceTraveled / durationInSeconds * 3600; // Speed in km/h
        }
      
       
      }
    });
  }
  void stopTime() {
    locationSubscription?.cancel();
    locationSubscription = null;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
