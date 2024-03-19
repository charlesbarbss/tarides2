import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tarides/BottomNav/preRides/pick_route_page.dart';
import 'package:tarides/widgets/button_widget.dart';
import 'package:tarides/widgets/text_widget.dart';

class PreRidesScreen extends StatefulWidget {
  const PreRidesScreen({super.key});

  @override
  State<PreRidesScreen> createState() => _PreRidesScreenState();
}

class _PreRidesScreenState extends State<PreRidesScreen> {
  final searchController = TextEditingController();
  String nameSearched = '';

  bool selected = false;

  bool selectedteams = false;
  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
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
                        Container(
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
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(100)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
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
                                  fontFamily: 'QRegular', color: Colors.white),
                              suffixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              )),
                          controller: searchController,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    selectedteams
                        ? searchScreen()
                        : StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('community')
                                // .where('status', isEqualTo: 'Completed')
                                .where('communityId',
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

                              final comData = snapshot.requireData;
                              return SizedBox(
                                height: 400,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        color:
                                            Colors.brown[100]!.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextWidget(
                                            text: comData
                                                .docs.first['communityName'],
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  minRadius: 50,
                                                  maxRadius: 50,
                                                  backgroundImage: NetworkImage(
                                                      data['imageUrl']),
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
                                                      text: comData.docs.first[
                                                          'communityDescription'],
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontFamily: 'Bold',
                                                    ),
                                                    TextWidget(
                                                      text:
                                                          '@${comData.docs.first['communityAdmin']}',
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
                                        color:
                                            Colors.brown[100]!.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: selected
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                  text: name,
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontFamily: 'Bold',
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/Ellipse 1849 (1).png',
                                                        height: 75,
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
                                                            text: desc,
                                                            fontSize: 20,
                                                            color: Colors.white,
                                                            fontFamily: 'Bold',
                                                          ),
                                                          TextWidget(
                                                            text: '@$admin',
                                                            fontSize: 12,
                                                            color: Colors.grey,
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
                                                  selectedteams = true;
                                                });
                                              },
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    TextWidget(
                                                      text: 'No Team',
                                                      fontSize: 18,
                                                      color: Colors.grey,
                                                      fontFamily: 'Bold',
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      width: 300,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.question_mark,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    selected
                                        ? Align(
                                            alignment: Alignment.bottomCenter,
                                            child: ButtonWidget(
                                              radius: 15,
                                              width: double.infinity,
                                              color: Colors.amber,
                                              label: 'Pick a Route',
                                              textColor: Colors.black,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PickRouteScreeen(
                                                            team1: data[
                                                                'communityId'],
                                                            team2: id,
                                                            team1name: comData
                                                                    .docs.first[
                                                                'communityName'],
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

  Widget searchScreen() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('community')
            // .where('status', isEqualTo: 'Completed')

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
                return Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedteams = false;
                        selected = true;
                        name = data.docs[index]['communityName'];
                        desc = data.docs[index]['communityDescription'];
                        admin = data.docs[index]['communityAdmin'];
                        id = data.docs[index]['communityId'];
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
                            text: data.docs[index]['communityName'],
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Bold',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/Ellipse 1849.png',
                                  height: 75,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: data.docs[index]
                                          ['communityDescription'],
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontFamily: 'Bold',
                                    ),
                                    TextWidget(
                                      text:
                                          '@${data.docs[index]['communityAdmin']}',
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
              },
            ),
          );
        });
  }
}
