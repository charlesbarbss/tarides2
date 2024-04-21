import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tarides/widgets/text_widget.dart';

class RacePageScreen extends StatefulWidget {
  const RacePageScreen({super.key});

  @override
  State<RacePageScreen> createState() => _RacePageScreenState();
}

class _RacePageScreenState extends State<RacePageScreen> {
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
            color: Colors.white),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14.4746,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: SizedBox(
                width: 50.0, // Set the width here
                height: 50.0, // Set the height here
                child: FloatingActionButton(
                  onPressed: () {
                    // Add your button press logic here
                    // This should include getting the current location and updating the map's camera position
                  },
                  backgroundColor: const Color.fromARGB(255, 232, 155, 5),
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: 240,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 12, 13, 17),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 100.0,
                    child: Column(
                      children: [
                        Container(
                          height: 155.0,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 24, 26, 32),
                            borderRadius: BorderRadius.circular(
                                14.0), // Customize the border radius here
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          TextWidget(
                                            text: 'TIME',
                                            fontSize: 12,
                                            fontFamily: 'Medium',
                                            color: const Color.fromARGB(
                                                255, 232, 170, 10),
                                          ),
                                          TextWidget(
                                            text: '00:00:00',
                                            fontSize: 24,
                                            fontFamily: 'Bold',
                                            color: Colors.white,
                                          ), // Add the time value here
                                        ],
                                      ),
                                      const VerticalDivider(
                                        indent: 5,
                                        color:
                                            Color.fromARGB(255, 218, 218, 218),
                                        thickness: 0.5,
                                      ),
                                      Column(
                                        children: [
                                          TextWidget(
                                            text: 'AVG SPEED (km/h)',
                                            fontSize: 12,
                                            fontFamily: 'Medium',
                                            color: const Color.fromARGB(
                                                255, 232, 170, 10),
                                          ),
                                          TextWidget(
                                            text: '0.0',
                                            fontSize: 24,
                                            fontFamily: 'Bold',
                                            color: Colors.white,
                                          ), // Add the average speed value here
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  indent: 5,
                                  endIndent: 5,
                                  color: Color.fromARGB(255, 218, 218, 218),
                                  thickness: 0.7,
                                  height: 20,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          TextWidget(
                                            text: 'TOTAL DISTANCE (km)',
                                            fontSize: 12,
                                            fontFamily: 'Medium',
                                            color: const Color.fromARGB(
                                                255, 232, 170, 10),
                                          ),
                                          TextWidget(
                                            text: '0.0 ',
                                            fontSize: 24,
                                            fontFamily: 'Bold',
                                            color: Colors.white,
                                          ), // Add the time value here
                                        ],
                                      ),
                                      const VerticalDivider(
                                        indent: 5,
                                        width: 2,
                                        color:
                                            Color.fromARGB(255, 218, 218, 218),
                                        thickness: 0.5,
                                      ),
                                      Column(
                                        children: [
                                          TextWidget(
                                            text: 'DISTANCE TRAVEL (km)',
                                            fontSize: 12,
                                            fontFamily: 'Medium',
                                            color: const Color.fromARGB(
                                                255, 232, 170, 10),
                                          ),
                                          TextWidget(
                                            text: '0.0',
                                            fontSize: 24,
                                            fontFamily: 'Bold',
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 55.0,
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              // Add your button press logic here
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 255, 0,
                                  0), // Add this if you want to change the background color of the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Customize the border radius here
                              ),
                            ),
                            child: TextWidget(
                              text: 'START',
                              fontSize: 23,
                              fontFamily: 'Bold',
                              color: Colors.white,
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
        ],
      ),
    );
  }
}
