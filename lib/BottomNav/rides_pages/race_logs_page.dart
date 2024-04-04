import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tarides/widgets/text_widget.dart';

class RaceLogsPage extends StatefulWidget {
  const RaceLogsPage({super.key});

  @override
  State<RaceLogsPage> createState() => _RaceLogsPageState();
}

class _RaceLogsPageState extends State<RaceLogsPage> {
  final searchController = TextEditingController();
  String nameSearched = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
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
                    text: 'Race Logs',
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'Bold',
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextWidget(
                text: 'Race History',
                fontSize: 14,
                color: Colors.white,
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Rides')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .where('status', isEqualTo: 'Finished')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Center(child: Text('Error'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.black,
                        )),
                      );
                    }

                    final data = snapshot.requireData;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: data.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Container(
                              width: double.infinity,
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.brown[100]!.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 300,
                                          width: 125,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextWidget(
                                                text: DateFormat.yMMMd()
                                                    .add_jm()
                                                    .format(data.docs[index]
                                                            ['dateTime']
                                                        .toDate()),
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontFamily: 'Bold',
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Image.asset(
                                                'assets/images/Rectangle 2764.png',
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          height: 300,
                                          width: 180,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextWidget(
                                                text: data.docs[index]
                                                            ['winner'] ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                    ? 'WINNER'
                                                    : 'DEFEAT',
                                                fontSize: 18,
                                                color: Colors.amber,
                                                fontFamily: 'Bold',
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextWidget(
                                                        text: 'TIME',
                                                        fontSize: 10,
                                                        color: Colors.amber,
                                                      ),
                                                      TextWidget(
                                                        text: data.docs[index]
                                                            ['time'],
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontFamily: 'Bold',
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextWidget(
                                                        text: 'AVG SPEED',
                                                        fontSize: 10,
                                                        color: Colors.amber,
                                                      ),
                                                      TextWidget(
                                                        text: '00.00km',
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontFamily: 'Bold',
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextWidget(
                                                        text: 'START TIME',
                                                        fontSize: 10,
                                                        color: Colors.amber,
                                                      ),
                                                      TextWidget(
                                                        text: DateFormat()
                                                            .add_jm()
                                                            .format(data
                                                                .docs[index]
                                                                    ['dateTime']
                                                                .toDate()),
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontFamily: 'Bold',
                                                      ),
                                                      const SizedBox(
                                                        height: 100,
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextWidget(
                                                        text: 'TOTAL DISTANCE',
                                                        fontSize: 10,
                                                        color: Colors.amber,
                                                      ),
                                                      TextWidget(
                                                        text: data.docs[index]
                                                            ['distance'],
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontFamily: 'Bold',
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextWidget(
                                                        text: 'DISTANCE TRAVEL',
                                                        fontSize: 10,
                                                        color: Colors.amber,
                                                      ),
                                                      TextWidget(
                                                        text: '0.0km',
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontFamily: 'Bold',
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextWidget(
                                                        text: 'END TIME',
                                                        fontSize: 10,
                                                        color: Colors.amber,
                                                      ),
                                                      TextWidget(
                                                        text: DateFormat()
                                                            .add_jm()
                                                            .format(data
                                                                .docs[index][
                                                                    'endDateTime']
                                                                .toDate()),
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontFamily: 'Bold',
                                                      ),
                                                      const SizedBox(
                                                        height: 100,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  })
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
