import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:tarides/BottomNav/NewRides/googleMaps.dart';
import 'package:tarides/BottomNav/NewRides/raceLogs.dart';
import 'package:tarides/BottomNav/NewRides/selectUser.dart';
import 'package:tarides/Controller/communityController.dart';
import 'package:tarides/Controller/ridesController.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/Model/userModel.dart';
import 'package:tarides/widgets/text_widget.dart';

class HomePageRides extends StatefulWidget {
  const HomePageRides(
      {super.key,
      required this.email,
      required this.user,
      required this.locationUser});
  final String email;
  final Users user;
  final LocationData locationUser;
  @override
  State<HomePageRides> createState() => _HomePageRidesState();
}

class _HomePageRidesState extends State<HomePageRides> {
  bool isSelectUser = false;
  bool selected = false;
  String id = '';

  UserController userController = UserController();
  CommunityController communityController = CommunityController();
  RidesController ridesController = RidesController();

  LocationData? _locationData;
  late bool _serviceEnabled;
  Location location = Location();
  late PermissionStatus _permissionGranted;

  var x;
  initState() {
    userController.getUser(widget.email);
    userController.getAllUsers();
    communityController.getCommunityAndUser(widget.email);
    ridesController.getRides(widget.user.username);
    super.initState();
  }

// Customize the Picture
  Future<Uint8List> _loadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Uint8List originalBytes = response.bodyBytes;
      final List<int> resizedBytes =
          await FlutterImageCompress.compressWithList(
        originalBytes,
        minHeight: 100,
        minWidth: 100,
        quality: 100,
      );
      return Uint8List.fromList(resizedBytes);
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: userController,
        builder: (context, snapshot) {
          if (userController.isLoading) {
            return Container(
              color: Colors.black, // Customize the background color
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.red), // Customize the loading color
                ),
              ),
            );
          }
          return AnimatedBuilder(
            animation: ridesController,
            builder: (context, snapshot) {
              if (ridesController.isLoading) {
                return Container(
                  color: Colors.black, // Customize the background color
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.red), // Customize the loading color
                    ),
                  ),
                );
              }
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Rides',
                        fontSize: 24,
                        fontFamily: 'Bold',
                        color: Colors.white,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RaceLogs(
                                email: widget.email,
                                username: userController.user.username,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromARGB(255, 232, 155,
                              5), // Set the color of the button's content
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Set the radius of the button
                          ),
                        ),
                        child: TextWidget(
                          text: 'Race Log',
                          fontSize: 14,
                          fontFamily: 'Bold',
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.black,
                body: SingleChildScrollView(
                  child: AnimatedBuilder(
                      animation: communityController,
                      builder: (context, snapshot) {
                        if (communityController.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: TextWidget(
                                    text: 'You',
                                    fontSize: 16,
                                    fontFamily: 'Regular',
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 15),
                                  child: Container(
                                    height: 180.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 40, 40, 40),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        TextWidget(
                                          text: communityController.community ==
                                                  null
                                              ? 'No Team'
                                              : communityController
                                                  .community!.communityName,
                                          fontSize: 24,
                                          fontFamily: 'Bold',
                                          color: const Color.fromARGB(
                                              255, 232, 155, 5),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 100.0, // Adjust as needed
                                              height: 100.0, // Adjust as needed
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors
                                                      .white, // Your specified color
                                                  width:
                                                      3.0, // Adjust border width as needed
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius: 50.0,
                                                backgroundImage: NetworkImage(
                                                  userController.user
                                                      .imageUrl, // Replace with your image URL
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextWidget(
                                                    text:
                                                        '${userController.user.firstName} ${userController.user.lastName}',
                                                    fontSize: 20,
                                                    fontFamily: 'bold',
                                                    color: Colors.white,
                                                  ),
                                                  TextWidget(
                                                    text:
                                                        '@${userController.user.username}',
                                                    fontSize: 14,
                                                    fontFamily: 'Regular',
                                                    color: const Color.fromARGB(
                                                        255, 152, 152, 152),
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: TextWidget(
                                    text: 'Enemy',
                                    fontSize: 16,
                                    fontFamily: 'Regular',
                                    color: Colors.white,
                                  ),
                                ),
                                if (ridesController.rides.isEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SelectUser(
                                              email: widget.email,
                                              user: widget.user,
                                            ),
                                          ),
                                        );
                                      });
                                      // Handle the container click event here
                                    },
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 10, 15, 15),
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 190.0,
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 45, 45, 45),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                child: Column(
                                                  children: [
                                                    TextWidget(
                                                      text:
                                                          'Select a Challenger',
                                                      fontSize: 24,
                                                      fontFamily: 'Bold',
                                                      color:
                                                          const Color.fromARGB(
                                                        255,
                                                        61,
                                                        61,
                                                        61,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    const Icon(
                                                      Icons.question_mark,
                                                      color: Colors.white,
                                                      size: 80,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      15,
                                      10,
                                      15,
                                      15,
                                    ),
                                    child: Column(
                                      children: [
                                        if (ridesController.rides.isEmpty)
                                          Center(
                                            child: TextWidget(
                                              text: 'No rides available',
                                              fontSize: 20,
                                              fontFamily: 'Bold',
                                              color: Colors.white,
                                            ),
                                          )
                                        else
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                255,
                                                40,
                                                40,
                                                40,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: Column(
                                              children: [
                                                for (x = 0;
                                                    x <
                                                        ridesController
                                                            .rides.length;
                                                    x++)
                                                  Column(
                                                    children: [
                                                      // if (ridesController
                                                      //         .rides[x]
                                                      //         .selected ==
                                                      //     false)
                                                      //   TextWidget(
                                                      //     text:
                                                      //         ' ${ridesController.rides[x].enemyFirstName} is NOT Ready',
                                                      //     fontSize: 14,
                                                      //     fontFamily: 'Bold',
                                                      //     color: const Color
                                                      //         .fromARGB(
                                                      //       255,
                                                      //       61,
                                                      //       61,
                                                      //       61,
                                                      //     ),
                                                      //   )
                                                      // else
                                                      //   TextWidget(
                                                      //     text:
                                                      //         ' ${ridesController.rides[x].enemyFirstName} is NOW Ready',
                                                      //     fontSize: 14,
                                                      //     fontFamily: 'Bold',
                                                      //     color: const Color
                                                      //         .fromARGB(
                                                      //       255,
                                                      //       232,
                                                      //       155,
                                                      //       5,
                                                      //     ),
                                                      //   ),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(0, 10, 0,
                                                            0), // Increase the padding to add more space
                                                        child: TextWidget(
                                                          text: ridesController
                                                              .rides[x]
                                                              .enemyCommunityName,
                                                          fontSize: 24,
                                                          fontFamily: 'Bold',
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 232, 155, 5),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                15, 0, 0, 15),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width:
                                                                  100.0, // Adjust as needed
                                                              height:
                                                                  100.0, // Adjust as needed
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .white, // Your specified color
                                                                  width:
                                                                      3.0, // Adjust border width as needed
                                                                ),
                                                              ),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 50.0,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                  ridesController
                                                                      .rides[x]
                                                                      .enemyImage,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 15,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  TextWidget(
                                                                    text:
                                                                        '${ridesController.rides[x].enemyFirstName} ${ridesController.rides[x].enemyLastName}',
                                                                    fontSize:
                                                                        20,
                                                                    fontFamily:
                                                                        'bold',
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  TextWidget(
                                                                    text:
                                                                        '@${ridesController.rides[x].enemyUsername}',
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Regular',
                                                                    color: const Color
                                                                        .fromARGB(
                                                                      255,
                                                                      152,
                                                                      152,
                                                                      152,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.fromLTRB(
                                        //       5, 0, 5, 0),
                                        //   child: Align(
                                        //     alignment: Alignment.centerRight,
                                        //     child: TextButton(
                                        //       onPressed: () {
                                        //         // Handle the button press here
                                        //       },
                                        //       style: TextButton.styleFrom(
                                        //         backgroundColor:
                                        //             const Color.fromARGB(
                                        //                 255, 232, 0, 0),
                                        //         shape: RoundedRectangleBorder(
                                        //           borderRadius:
                                        //               BorderRadius.circular(
                                        //                   10), // Set the border radius
                                        //         ),
                                        //       ),
                                        //       child: TextWidget(
                                        //         text: 'Refresh',
                                        //         fontSize: 16,
                                        //         fontFamily: 'Bold',
                                        //         color: Colors.white,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 55,
                                          child: TextButton(
                                            onPressed: () async {
                                              for (var i = 0;
                                                  i <
                                                      ridesController
                                                          .rides.length;
                                                  i++) {
                                                _serviceEnabled = await location
                                                    .serviceEnabled();
                                                if (!_serviceEnabled) {
                                                  _serviceEnabled =
                                                      await location
                                                          .requestService();
                                                  if (!_serviceEnabled) {
                                                    return;
                                                  }
                                                }

                                                _permissionGranted =
                                                    await location
                                                        .hasPermission();
                                                if (_permissionGranted ==
                                                    PermissionStatus.denied) {
                                                  _permissionGranted =
                                                      await location
                                                          .requestPermission();
                                                  if (_permissionGranted !=
                                                      PermissionStatus
                                                          .granted) {
                                                    return;
                                                  }
                                                }

                                                _locationData = await location
                                                    .getLocation();

                                                if (mounted) {
                                                  setState(() {
                                                    _locationData =
                                                        _locationData;
                                                  });
                                                }

                                                double? latitude =
                                                    _locationData?.latitude;
                                                double? longitude =
                                                    _locationData?.longitude;

                                                FirebaseFirestore.instance
                                                    .collection('rides')
                                                    .where('id',
                                                        isEqualTo:
                                                            ridesController
                                                                .rides[i]
                                                                .idRides)
                                                    .get()
                                                    .then(
                                                  (value) {
                                                    value.docs.forEach(
                                                      (element) {
                                                        element.reference
                                                            .update({
                                                          'hostLat': latitude,
                                                          'hostLng': longitude,
                                                        });
                                                      },
                                                    );
                                                  },
                                                );
                                                final Uint8List hostIcon =
                                                    await _loadImage(
                                                        ridesController.rides[i]
                                                            .hostImage);
                                                final Uint8List enemyIcon =
                                                    await _loadImage(
                                                        ridesController.rides[i]
                                                            .enemyImage);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        GoogleMapsScreen(
                                                      email: widget.email,
                                                      locationUser:
                                                          widget.locationUser,
                                                      isHost: true,
                                                      ride: ridesController
                                                          .rides[i],
                                                      totalDistance: '',
                                                      totalDuration: '',
                                                      hostImage: hostIcon,
                                                      enemyImage: enemyIcon,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 232, 155, 5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10), // Set the border radius
                                              ),
                                            ),
                                            child: TextWidget(
                                              text: 'Pick a Route',
                                              fontSize: 18,
                                              fontFamily: 'Bold',
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            )
                          ],
                        );
                      }),
                ),
              );
            },
          );
        });
  }
}