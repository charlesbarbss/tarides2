import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tarides/BottomNav/preRides/pick_route_page.dart';
import 'package:tarides/BottomNav/rides_pages/race_logs_page.dart';
import 'package:tarides/widgets/button_widget.dart';
import 'package:tarides/widgets/text_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

class PreRidesScreen extends StatefulWidget {
  const PreRidesScreen({super.key});

  @override
  State<PreRidesScreen> createState() => _PreRidesScreenState();
}

class _PreRidesScreenState extends State<PreRidesScreen> {
  final searchController = TextEditingController();
  String nameSearched = '';

  bool selected = false;

  String selectedImage = '';

  bool selectedteams = false;
  final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<DocumentSnapshot>(
          stream: userData,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }
            dynamic data = snapshot.data;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: 'Rides',
                          fontSize: 24,
                          color: Colors.white,
                          fontFamily: 'Bold',
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RaceLogsPage()),
                            );
                          },
                          child: Container(
                            width: 75,
                            height: 25,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.amber,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: TextWidget(
                                text: 'Race Log',
                                fontSize: 12,
                                color: Colors.white,
                                fontFamily: 'Bold',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    selectedteams
                        ? Container(
                            height: 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(100)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Regular',
                                    fontSize: 14),
                                onChanged: (value) {
                                  setState(() {
                                    nameSearched = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    hintText: 'Search',
                                    hintStyle: TextStyle(
                                        fontFamily: 'QRegular',
                                        color: Colors.white),
                                    suffixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    )),
                                controller: searchController,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 10,
                    ),
                    data['communityId'] == ''
                        ? const Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Center(
                              child: Text(
                                'You dont have a community yet. Join a Community to participate on the Race',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          )
                        : selectedteams
                            ? searchScreen()
                            : StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Rides')
                                    .where('status', isEqualTo: 'Started')
                                    .where('team2',
                                        isEqualTo: data['communityId'])
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    print(snapshot.error);
                                    return const Center(child: Text('Error'));
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 50),
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.black,
                                      )),
                                    );
                                  }

                                  final newData = snapshot.requireData;

                                  return newData.docs.isNotEmpty
                                      ? StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('community')
                                              // .where('status', isEqualTo: 'Completed')
                                              .where('communityId',
                                                  isEqualTo: newData
                                                      .docs.first['team1'])
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              print(snapshot.error);
                                              return const Center(
                                                  child: Text('Error'));
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 50),
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: Colors.black,
                                                )),
                                              );
                                            }

                                            final comData =
                                                snapshot.requireData;
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (timeStamp) {
                                              if (!selected) {
                                                setState(() {
                                                  selected = true;
                                                });
                                              }
                                            });
                                            return SizedBox(
                                              height: 450,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextWidget(
                                                    text: 'Your Team',
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  StreamBuilder<QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'community')
                                                          // .where('status', isEqualTo: 'Completed')
                                                          .where('communityId',
                                                              isEqualTo: data[
                                                                  'communityId'])
                                                          .snapshots(),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                        if (snapshot.hasError) {
                                                          print(snapshot.error);
                                                          return const Center(
                                                              child: Text(
                                                                  'Error'));
                                                        }
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 50),
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                          );
                                                        }

                                                        final myData = snapshot
                                                            .requireData;
                                                        return Container(
                                                          width:
                                                              double.infinity,
                                                          height: 150,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .brown[100]!
                                                                .withOpacity(
                                                                    0.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              TextWidget(
                                                                text: myData
                                                                        .docs
                                                                        .first[
                                                                    'communityName'],
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Bold',
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    CircleAvatar(
                                                                      minRadius:
                                                                          50,
                                                                      maxRadius:
                                                                          50,
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                              data['imageUrl']),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            TextWidget(
                                                                              text: data['firstName'],
                                                                              fontSize: 20,
                                                                              color: Colors.white,
                                                                              fontFamily: 'Bold',
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Container(
                                                                              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5), borderRadius: BorderRadius.circular(100)),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 10, right: 10),
                                                                                child: TextWidget(
                                                                                  text: 'Host',
                                                                                  fontSize: 12,
                                                                                  color: Colors.white,
                                                                                  fontFamily: 'Bold',
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        TextWidget(
                                                                          text:
                                                                              '@${data['username']}',
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.grey,
                                                                          fontFamily:
                                                                              'Regular',
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextWidget(
                                                    text: 'Enemy Team',
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  StreamBuilder<
                                                          DocumentSnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(newData.docs
                                                              .first['userId'])
                                                          .snapshots(),
                                                      builder: (context,
                                                          AsyncSnapshot<
                                                                  DocumentSnapshot>
                                                              snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return const SizedBox();
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return const Center(
                                                              child: Text(
                                                                  'Something went wrong'));
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const SizedBox();
                                                        }
                                                        dynamic enemyData =
                                                            snapshot.data;

                                                        return Container(
                                                          width:
                                                              double.infinity,
                                                          height: 150,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .brown[100]!
                                                                .withOpacity(
                                                                    0.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              TextWidget(
                                                                text: name,
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Bold',
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    CircleAvatar(
                                                                      minRadius:
                                                                          50,
                                                                      maxRadius:
                                                                          50,
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                              enemyData['imageUrl']),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        TextWidget(
                                                                          text:
                                                                              enemyData['firstName'],
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.white,
                                                                          fontFamily:
                                                                              'Bold',
                                                                        ),
                                                                        TextWidget(
                                                                          text:
                                                                              '@${enemyData['username']}',
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.grey,
                                                                          fontFamily:
                                                                              'Regular',
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  selected
                                                      ? Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: ButtonWidget(
                                                            radius: 15,
                                                            width:
                                                                double.infinity,
                                                            color: Colors.amber,
                                                            label:
                                                                'Pick a Route',
                                                            textColor:
                                                                Colors.black,
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PickRouteScreeen(
                                                                              team1: data['communityId'],
                                                                              team2: id,
                                                                              team1name: comData.docs.first['communityName'],
                                                                              team2name: name,
                                                                            )),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            );
                                          })
                                      : StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('community')
                                              // .where('status', isEqualTo: 'Completed')
                                              .where('communityId',
                                                  isEqualTo:
                                                      data['communityId'])
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              print(snapshot.error);
                                              return const Center(
                                                  child: Text('Error'));
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 50),
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: Colors.black,
                                                )),
                                              );
                                            }

                                            final comData =
                                                snapshot.requireData;
                                            return SizedBox(
                                              height: 500,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextWidget(
                                                    text: 'Your Team',
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: 150,
                                                    decoration: BoxDecoration(
                                                      color: Colors.brown[100]!
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        TextWidget(
                                                          text: comData
                                                                  .docs.first[
                                                              'communityName'],
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontFamily: 'Bold',
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 20,
                                                                  right: 20),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CircleAvatar(
                                                                minRadius: 50,
                                                                maxRadius: 50,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        data[
                                                                            'imageUrl']),
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      TextWidget(
                                                                        text: data[
                                                                            'firstName'],
                                                                        fontSize:
                                                                            20,
                                                                        color: Colors
                                                                            .white,
                                                                        fontFamily:
                                                                            'Bold',
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.grey.withOpacity(0.5),
                                                                            borderRadius: BorderRadius.circular(100)),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 10,
                                                                              right: 10),
                                                                          child:
                                                                              TextWidget(
                                                                            text:
                                                                                'Host',
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.white,
                                                                            fontFamily:
                                                                                'Bold',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  TextWidget(
                                                                    text:
                                                                        '@${data['username']}',
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontFamily:
                                                                        'Regular',
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextWidget(
                                                    text: 'Enemy Team',
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: 150,
                                                    decoration: BoxDecoration(
                                                      color: Colors.brown[100]!
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: selected
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              TextWidget(
                                                                text: name,
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Bold',
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    CircleAvatar(
                                                                      minRadius:
                                                                          50,
                                                                      maxRadius:
                                                                          50,
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                              selectedImage),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        TextWidget(
                                                                          text:
                                                                              desc,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.white,
                                                                          fontFamily:
                                                                              'Bold',
                                                                        ),
                                                                        TextWidget(
                                                                          text:
                                                                              '@$admin',
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.grey,
                                                                          fontFamily:
                                                                              'Regular',
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                selectedteams =
                                                                    true;
                                                              });
                                                            },
                                                            child: Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  TextWidget(
                                                                    text:
                                                                        'No Team',
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontFamily:
                                                                        'Bold',
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Container(
                                                                    width: 300,
                                                                    height: 100,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .question_mark,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  selected
                                                      ? Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: ButtonWidget(
                                                            radius: 15,
                                                            width:
                                                                double.infinity,
                                                            color: Colors.amber,
                                                            label:
                                                                'Pick a Route',
                                                            textColor:
                                                                Colors.white,
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PickRouteScreeen(
                                                                              team1: data['communityId'],
                                                                              team2: id,
                                                                              team1name: comData.docs.first['communityName'],
                                                                              team2name: name,
                                                                            )),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            );
                                          });
                                }),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

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

  String name = '';
  String desc = '';
  String admin = '';
  String id = '';
  String userId = '';

  Widget searchScreen() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('firstName',
                isGreaterThanOrEqualTo: toBeginningOfSentenceCase(nameSearched))
            .where('firstName',
                isLessThan: '${toBeginningOfSentenceCase(nameSearched)}z')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          return SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('community')
                        .where('communityId',
                            isEqualTo: data.docs[index]['communityId'])
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

                      final comData = snapshot.requireData;
                      return Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedteams = false;
                              selected = true;
                              name = comData.docs.first['communityName'];
                              desc = data.docs[index]['firstName'];
                              selectedImage = data.docs[index]['imageUrl'];
                              admin = data.docs[index]['username'];
                              id = data.docs[index]['communityId'];
                              userId = data.docs[index].id;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.brown[100]!.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: comData.docs.first['communityName'],
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'Bold',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        minRadius: 50,
                                        maxRadius: 50,
                                        backgroundImage: NetworkImage(
                                            data.docs[index]['imageUrl']),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TextWidget(
                                            text: data.docs[index]['firstName'],
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily: 'Bold',
                                          ),
                                          TextWidget(
                                            text:
                                                '@${data.docs[index]['username']}',
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontFamily: 'Regular',
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
          );
        });
  }
}
