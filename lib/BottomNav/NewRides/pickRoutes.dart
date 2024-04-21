import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tarides/BottomNav/NewRides/racePage.dart';
import 'package:tarides/widgets/text_widget.dart';

class PickRouteScreen extends StatefulWidget {
  const PickRouteScreen({super.key});

  @override
  State<PickRouteScreen> createState() => _PickRouteScreenState();
}

class _PickRouteScreenState extends State<PickRouteScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {}

  void _onAddMarkerButtonPressed() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(position.toString()),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: placemarks.first.name,
          snippet: placemarks.first.locality,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16.0,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Pick your Race Routes',
          fontSize: 20,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
            ),
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: FloatingActionButton(
                      onPressed: _onAddMarkerButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Color.fromARGB(255, 232, 155, 5),
                      child: const Icon(
                        Icons.my_location_rounded,
                        size: 24.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 40, 40, 40),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 55, // Set the height of the TextFormField
                        child: TextFormField(
                          style: const TextStyle(
                            color:
                                Colors.white, // Set the color of the input text
                          ),
                          decoration: InputDecoration(
                            hintText: 'Starting Point',
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 69, 69,
                                  69), // Set the color of the hintText
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Set the border radius
                              borderSide: const BorderSide(
                                color:
                                    Colors.white, // Set the color of the border
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.location_history,
                              size: 30, // Set the icon
                              color: Color.fromARGB(
                                  255, 255, 0, 0), // Set the color of the icon
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 55, // Set the height of the TextFormField
                        child: TextFormField(
                          style: const TextStyle(
                            color:
                                Colors.white, // Set the color of the input text
                          ),
                          decoration: InputDecoration(
                            hintText: '1st Destination',
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 69, 69,
                                  69), // Set the color of the hintText
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Set the border radius
                              borderSide: const BorderSide(
                                color:
                                    Colors.white, // Set the color of the border
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.location_on_rounded,
                              size: 30, // Set the icon
                              color: Color.fromARGB(255, 232, 170,
                                  10), // Set the color of the icon
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 55, // Set the height of the TextFormField
                        child: TextFormField(
                          style: const TextStyle(
                            color:
                                Colors.white, // Set the color of the input text
                          ),
                          decoration: InputDecoration(
                            hintText: '2nd Destination',
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 69, 69,
                                  69), // Set the color of the hintText
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Set the border radius
                              borderSide: const BorderSide(
                                color:
                                    Colors.white, // Set the color of the border
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.location_on_rounded,
                              size: 30, // Set the icon
                              color: Color.fromARGB(255, 232, 170,
                                  10), // Set the color of the icon
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 55, // Set the height of the TextFormField
                        child: TextFormField(
                          style: const TextStyle(
                            color:
                                Colors.white, // Set the color of the input text
                          ),
                          decoration: InputDecoration(
                            hintText: '3rd Destination',
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 69, 69,
                                  69), // Set the color of the hintText
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Set the border radius
                              borderSide: const BorderSide(
                                color:
                                    Colors.white, // Set the color of the border
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.location_on_rounded,
                              size: 30, // Set the icon
                              color: Color.fromARGB(255, 232, 170,
                                  10), // Set the color of the icon
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
                            // Navigate to a new screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RacePageScreen()), // Replace NewScreen with the actual class name of the new screen
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 232, 155, 5),
                          ),
                          child: TextWidget(
                            text: 'Continue',
                            fontSize: 20,
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
        ],
      ),
    );
  }
}
