import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:tarides/BottomNav/NewRides/googleMaps.dart';
import 'package:tarides/Controller/ridesController.dart';
import 'package:tarides/Model/ridesModel.dart';
import 'package:tarides/widgets/text_widget.dart';

class RaceLobbyScreen extends StatefulWidget {
  const RaceLobbyScreen({
    super.key,
    required this.ride,
  });
  final Rides ride;

  @override
  State<RaceLobbyScreen> createState() => _RaceLobbyScreenState();
}

class _RaceLobbyScreenState extends State<RaceLobbyScreen> {
  RidesController ridesController = RidesController();
  LocationData? _locationData;
  late bool _serviceEnabled;
  Location location = Location();
  late PermissionStatus _permissionGranted;

  @override
  void initState() {
    ridesController.getRideId(widget.ride.idRides);
    initializeLocation();
    super.initState();
  }

  void initializeLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    if (mounted) {
      setState(() {
        _locationData = _locationData;
      });
    }

    double? latitude = _locationData?.latitude;
    double? longitude = _locationData?.longitude;

    print('widget.ride.idRides: ${widget.ride.idRides}');

    final communityDoc = await FirebaseFirestore.instance
        .collection('rides')
        .where('id', isEqualTo: widget.ride.idRides)
        .get();

    await communityDoc.docs.first.reference.update({
      'enemyLat': latitude,
      'enemyLng': longitude,
    });

    // FirebaseFirestore.instance
    //     .collection('rides')
    //     .where('idRides', isEqualTo: widget.ride.idRides)
    //     .get()
    //     .then(
    //   (value) {
    //     if (value.docs.isEmpty) {
    //       print('No rides found');
    //     } else {
    //       for (var doc in value.docs) {
    //         doc.reference.update({
    //           'hostLat': latitude,
    //           'hostLng': longitude,
    //         });
    //       }
    //     }
    //   },
    // ).catchError((error) {
    //   print('Error getting rides: $error');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Rides',
          fontSize: 24,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      body: AnimatedBuilder(
        animation: ridesController,
        builder: (context, snapshot) {
          if (ridesController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextWidget(
                  text: 'Enemy',
                  fontSize: 14,
                  fontFamily: 'Regular',
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: Container(
                  height: 200.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 40, 40, 40),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextWidget(
                        text: ' ${widget.ride.hostCommunityName}',
                        fontSize: 24,
                        fontFamily: 'Bold',
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(widget
                                .ride.hostImage), // Replace with your image URL
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text:
                                      '${widget.ride.hostFirstName} ${widget.ride.hostLastName}',
                                  fontSize: 20,
                                  fontFamily: 'bold',
                                  color: Colors.white,
                                ),
                                TextWidget(
                                  text: '@${widget.ride.hostUsername}',
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  color:
                                      const Color.fromARGB(255, 152, 152, 152),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextWidget(
                  text: 'You',
                  fontSize: 14,
                  fontFamily: 'Regular',
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: Container(
                  height: 200.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 40, 40, 40),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextWidget(
                        text: ' ${widget.ride.enemyCommunityName}',
                        fontSize: 24,
                        fontFamily: 'Bold',
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(widget.ride
                                .enemyImage), // Replace with your image URL
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text:
                                      '${widget.ride.enemyFirstName} ${widget.ride.enemyLastName}',
                                  fontSize: 20,
                                  fontFamily: 'bold',
                                  color: Colors.white,
                                ),
                                TextWidget(
                                  text: '@${widget.ride.enemyUsername}',
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  color:
                                      const Color.fromARGB(255, 152, 152, 152),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoogleMapsScreen(
                            locationUser: _locationData!,
                            isHost: false,
                            ride: widget.ride,
                            totalDistance: '',
                            totalDuration: '',
                          ),
                        ), // Replace 'YourNewScreen' with the name of your new screen
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 232, 155, 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: TextWidget(
                      text: 'Join',
                      fontSize: 20,
                      fontFamily: 'Bold',
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}