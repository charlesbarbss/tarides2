import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tarides/BottomNav/Goal30Tabs/directionsRepository.dart';
import 'package:tarides/Model/directionsModel.dart';
import 'package:tarides/Model/ridesModel.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen(
      {super.key,
      required this.locationUser,
      required this.isHost,
      required this.ride});
  final LocationData locationUser;

  final bool isHost;
  final Rides ride;

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
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

  int _tapCounter = 0;
  LatLng? _startPoint;
  LatLng? _midPoint;
  LatLng? _endPoint;
  var select = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        // GoogleMap(
        //     initialCameraPosition: CameraPosition(
        //   target: LatLng(
        //     widget.locationUser.latitude ?? 0.0,
        //     widget.locationUser.longitude ?? 0.0,
        //   ),
        //   zoom: 14.4746,
        // ));
        StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('rides')
          .doc(widget.ride.id)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        if (data['hostLat'] != null && data['hostLng'] != null) {
          _host = Marker(
            markerId: const MarkerId('host'),
            position: LatLng(data['hostLat'], data['hostLng']),
            infoWindow: const InfoWindow(title: 'You'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
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
        if (data['startPointLat'] != null && data['startPointLng'] != null) {
          _origin = Marker(
            markerId: const MarkerId('startPoint'),
            position: LatLng(data['startPointLat'], data['startPointLng']),
            infoWindow: const InfoWindow(title: 'Start Point'),
          );
        }
        if (data['midPointLat'] != null && data['midPointLng'] != null) {
          _destination = Marker(
            markerId: const MarkerId('midPoint'),
            position: LatLng(data['midPointLat'], data['midPointLng']),
            infoWindow: const InfoWindow(title: 'Mid Point'),
          );
        }
        if (data['endPointLat'] != null && data['endPointLng'] != null) {
          _finalDestination = Marker(
            markerId: const MarkerId('endPoint'),
            position: LatLng(data['endPointLat'], data['endPointLng']),
            infoWindow: const InfoWindow(title: 'End Point'),
          );
        }
        void addMarker(LatLng pos) async {
          // if (widget.isHost == true) {
          final placemarks =
              await placemarkFromCoordinates(pos.latitude, pos.longitude);
          final place = placemarks.first;
          final String fullAddress =
              '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}';

          if (data['startPointLat'] == 0 && data['startPointLng'] == 0) {
            print('2');
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
              },
            );
            // setState(() {
            select = 2;
            // });
          } else if (data['midPointLat'] == 0 && data['midPointLng'] == 0) {
            print('ni sud ba?');
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
            final directions = await DirectionsRepository().getDirections(
              origin: _origin!.position,
              destination: pos,
            );

            _info = directions;

            FirebaseFirestore.instance
                .collection('rides')
                .doc(widget.ride.id)
                .update(
              {
                'midPointLat': _destination!.position.latitude,
                'midPointLng': _destination!.position.longitude,
              },
            );
            select = 3;
          } else if (data['endPointLat'] == 0 && data['endPointLng'] == 0) {
            print('234');
            _finalDestination = Marker(
              markerId: const MarkerId('finalDestination'),
              infoWindow: InfoWindow(title: place.name),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position: pos,
            );
            thirdPinPoint.text = fullAddress;

            final directions2 = await DirectionsRepository().getDirections(
              origin: _destination!.position,
              destination: _finalDestination!.position,
            );

            _info2 = directions2;

            FirebaseFirestore.instance
                .collection('rides')
                .doc(widget.ride.id)
                .update(
              {
                'endPointLat': _finalDestination!.position.latitude,
                'endPointLng': _finalDestination!.position.longitude,
              },
            );
            final directions3 = await DirectionsRepository().getDirections(
              origin: _origin!.position,
              destination: _finalDestination!.position,
            );
            _info3 = directions3;

            _info3 = directions3;
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
              },
            ).then((value) {
              setState(() {
                _origin = null;
                _midPoint = null;
                _finalDestination = null;
                _info = null;
                _info2 = null;

                firstPinPoint.clear();
                secondPinPoint.clear();
                thirdPinPoint.clear();
              });
            });
          }
        }
        // }

        return GoogleMap(
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
          },
        );
      },
    );
  }
}