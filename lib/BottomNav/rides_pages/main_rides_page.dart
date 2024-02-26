import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tarides/BottomNav/rides_pages/race_logs_page.dart';
import 'package:tarides/widgets/button_widget.dart';
import 'package:tarides/widgets/dialog_widget.dart';
import 'package:tarides/widgets/text_widget.dart';

class MainRidesScreen extends StatefulWidget {
  const MainRidesScreen({super.key});

  @override
  State<MainRidesScreen> createState() => _MainRidesScreenState();
}

class _MainRidesScreenState extends State<MainRidesScreen> {
  final searchController = TextEditingController();
  String nameSearched = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.brown[100]!.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      text: 'TIME',
                                      fontSize: 12,
                                      color: Colors.amber,
                                    ),
                                    TextWidget(
                                      text: '0:00:00',
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
                                      text: '0.0',
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                        height: 25,
                      ),
                      ButtonWidget(
                        width: 350,
                        color: Colors.red,
                        radius: 15,
                        label: 'Finish',
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return DialogWidget(
                                image: 'assets/images/star 1.png',
                                title: 'WINNER!',
                                caption: 'CONGRATUALATIONS!',
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
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
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
}
