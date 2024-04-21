import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
  late Set<Marker> _markers;
  @override
  void initState() {
    super.initState();
    _markers = {};
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
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        _markers.clear();
        if (data['hostLat'] != null && data['hostLng'] != null) {
          _markers.add(Marker(
            markerId: MarkerId('host'),
            position: LatLng(data['hostLat'], data['hostLng']),
            infoWindow: InfoWindow(title: 'Host'),
          ));
        }
        if (data['enemyLat'] != null && data['enemyLng'] != null) {
          _markers.add(Marker(
            markerId: MarkerId('enemy'),
            position: LatLng(data['enemyLat'], data['enemyLng']),
            infoWindow: InfoWindow(title: 'Enemy'),
          ));
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              data['enemyLat'] ?? 0.0,
              data['enemyLng'] ?? 0.0,
            ),
            zoom: 14.4746,
          ),
          markers: _markers,
        );
      },
    );
  }
}
