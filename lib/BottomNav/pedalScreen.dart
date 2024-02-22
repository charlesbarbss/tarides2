import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tarides/widgets/button_widget.dart';
import 'package:tarides/widgets/text_widget.dart';

class PedalScreeen extends StatefulWidget {
  const PedalScreeen({super.key});

  @override
  State<PedalScreeen> createState() => _PedalScreeenState();
}

class _PedalScreeenState extends State<PedalScreeen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: TextWidget(
                    text: 'Pedal',
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'Bold',
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      zoomControlsEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TabBar(
                                  indicatorColor: Colors.red,
                                  labelColor: Colors.red,
                                  unselectedLabelColor: Colors.grey,
                                  tabs: [
                                    Tab(
                                      text: 'Routes',
                                    ),
                                    Tab(
                                      text: 'Saved Routes',
                                    ),
                                  ]),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 220,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: TabBarView(children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextWidget(
                                              text: 'Pin point your location!',
                                              fontSize: 12,
                                              fontFamily: 'Bold',
                                            ),
                                            ButtonWidget(
                                              color: Colors.red,
                                              fontSize: 12,
                                              width: 50,
                                              radius: 100,
                                              height: 35,
                                              label: 'Save route',
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {},
                                          child: Container(
                                            height: 35,
                                            width: 300,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                prefixIcon: const Icon(
                                                  Icons.location_on_rounded,
                                                  color: Colors.amber,
                                                ),
                                                fillColor: Colors.white,
                                                filled: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 1,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 1,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10100),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 1,
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                label: TextWidget(
                                                  text: 'Start point',
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {},
                                          child: Container(
                                            height: 35,
                                            width: 300,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                prefixIcon: const Icon(
                                                  Icons.location_on_rounded,
                                                  color: Colors.red,
                                                ),
                                                fillColor: Colors.white,
                                                filled: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 1,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 1,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10100),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 1,
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                label: TextWidget(
                                                  text: 'End point',
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        ButtonWidget(
                                          color: Colors.red,
                                          fontSize: 18,
                                          width: 300,
                                          radius: 15,
                                          height: 50,
                                          label: 'Start',
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                    // Saved routes tab
                                    const SizedBox(),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
}
