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
  bool isclicked = false;
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
                    isclicked
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                height: 250,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 150,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.brown[100]!
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        color: Colors.white),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        45, 11, 45, 11),
                                                    child: TextWidget(
                                                      text: 'STOP',
                                                      fontSize: 18,
                                                      fontFamily: 'Bold',
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          ButtonWidget(
                                            width: 150,
                                            color: Colors.red,
                                            radius: 15,
                                            label: 'FINISH',
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  TextWidget(
                                                    text:
                                                        'Pin point your location!',
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
                                                    onPressed: () {
                                                      showsaverouteDialog();
                                                    },
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
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      prefixIcon: const Icon(
                                                        Icons
                                                            .location_on_rounded,
                                                        color: Colors.amber,
                                                      ),
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      disabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10100),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
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
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: TextFormField(
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      prefixIcon: const Icon(
                                                        Icons
                                                            .location_on_rounded,
                                                        color: Colors.red,
                                                      ),
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      disabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10100),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
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
                                                onPressed: () {
                                                  setState(() {
                                                    isclicked = true;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          // Saved routes tab
                                          SizedBox(
                                            height: 220,
                                            width: double.infinity,
                                            child: ListView.builder(
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .location_on_rounded,
                                                              color: Colors.red,
                                                            ),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            TextWidget(
                                                              text:
                                                                  'Basak Pardo, Cebu City',
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Bold',
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5),
                                                          child: TextWidget(
                                                            text: 'to',
                                                            fontSize: 12,
                                                            fontFamily: 'Bold',
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .location_on_rounded,
                                                              color: Colors.red,
                                                            ),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            TextWidget(
                                                              text:
                                                                  'Metro Colon, Cebu City',
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Bold',
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    TextWidget(
                                                      text: '80KM',
                                                      fontSize: 18,
                                                      fontFamily: 'Bold',
                                                      color: Colors.grey,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
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

  showsaverouteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextWidget(
            text: 'You Want to Save your Route?',
            fontSize: 18,
            fontFamily: 'Bold',
          ),
          content: TextWidget(
            text:
                'Save this epic bike route to your favorites for quick access.',
            fontSize: 12,
            fontFamily: 'Medium',
            color: Colors.grey,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: TextWidget(
                        text: 'Cancel',
                        fontSize: 14,
                        fontFamily: 'Bold',
                        color: Colors.red,
                      ),
                    ),
                  )),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.red),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                    child: TextWidget(
                      text: 'Save',
                      fontSize: 14,
                      fontFamily: 'Bold',
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
        );
      },
    );
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
}
