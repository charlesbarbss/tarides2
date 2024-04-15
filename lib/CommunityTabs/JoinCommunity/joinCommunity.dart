import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tarides/Controller/communityController.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/homePage.dart';

class JoinCommunity extends StatefulWidget {
  const JoinCommunity({super.key, required this.email});
  final String email;
  @override
  State<JoinCommunity> createState() => _JoinCommunityState();
}

class _JoinCommunityState extends State<JoinCommunity> {
  TextEditingController searchCommunity = TextEditingController();
  UserController userController = UserController();
  CommunityController communityController = CommunityController();
  String searchQuery = '';

  void initState() {
    userController.getUser(widget.email);
    communityController.getAllCommunity();
    super.initState();
  }

  void searchesCommunity(String query) async {
    // Make the function asynchronous
    if (query.isEmpty) {
      setState(() {
        searchQuery = '';
      });
      communityController
          .getCommunityAndUser(widget.email); // Await the function
      return;
    }
    final suggestions = communityController.communities.where((commu) {
      final communityTitle = commu.communityName.toLowerCase();
      final input = query.toLowerCase();
      return communityTitle.contains(input);
    }).toList();
    setState(() {
      searchQuery = query;
      communityController.communities = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: searchesCommunity,
                controller: searchCommunity,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x3fffFFFFF0),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x3fffFFFFF0),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelText: 'Search Community',
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    )),
              ),
            ),
            AnimatedBuilder(
              animation: communityController,
              builder: (context, snapshot) {
                if (communityController.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    for (var i = 0;
                        i < communityController.communities.length;
                        i++)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: GestureDetector(
                              onTap: () {
                                if (userController.user.isCommunity == true) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            'You are already a member of a community. You can only join one community at a time.'),
                                      );
                                    },
                                  );
                                }
                                if (userController.user.isCommunity == false &&
                                    communityController
                                            .communities[i].isPrivate ==
                                        true) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(communityController
                                            .communities[i].communityName),
                                        content: Text(
                                            'Do you wish to join this private community?'),
                                        actions: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 50, vertical: 10),
                                              textStyle: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () async {
                                              final requestId =
                                                  FirebaseFirestore.instance
                                                      .collection('request')
                                                      .doc()
                                                      .id;
                                              await FirebaseFirestore.instance
                                                  .collection('request')
                                                  .add({
                                                'requestId':
                                                    requestId, // Add this line
                                                'requestCommunityId':
                                                    communityController
                                                        .communities[i]
                                                        .communityId,
                                                'usersName': userController
                                                    .user.username,
                                              }).then((value) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'You have sent a request to join the community'),
                                                    );
                                                  },
                                                );
                                                Future.delayed(
                                                    Duration(seconds: 1), () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage(
                                                        email: widget.email,
                                                        homePageIndex: 0,
                                                      ),
                                                    ),
                                                  );
                                                });
                                              });
                                            },
                                            child: Text(
                                              'Join',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                                if (userController.user.isCommunity == false &&
                                    communityController
                                            .communities[i].isPrivate ==
                                        false) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(communityController
                                            .communities[i].communityName),
                                        content: Text(
                                            'Do you wish to join this public community?'),
                                        actions: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 50, vertical: 10),
                                              textStyle: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () async {
                                              final userDoc =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('user')
                                                      .where('username',
                                                          isEqualTo:
                                                              userController
                                                                  .user
                                                                  .username)
                                                      .get();

                                              await userDoc.docs.first.reference
                                                  .update({
                                                'communityId':
                                                    communityController
                                                        .communities[i]
                                                        .communityId,
                                                'isCommunity': true,
                                              });
                                              final communityDoc =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('community')
                                                      .where('communityId',
                                                          isEqualTo:
                                                              communityController
                                                                  .communities[
                                                                      i]
                                                                  .communityId)
                                                      .get();
                                              await communityDoc
                                                  .docs.first.reference
                                                  .update({
                                                'communityMember':
                                                    FieldValue.arrayUnion([
                                                  userController.user.username
                                                ]),
                                              }).then((value) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Welcome to the community!'),
                                                    );
                                                  },
                                                );
                                                Future.delayed(
                                                    Duration(seconds: 2), () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage(
                                                        email: widget.email,
                                                        homePageIndex: 0,
                                                      ),
                                                    ),
                                                  );
                                                });
                                              });
                                            },
                                            child: Text(
                                              'Join',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Container(
                                height: 170,
                                width: 400,
                                color: Color.fromARGB(31, 153, 150, 150),
                                child: Column(
                                  children: [
                                    Text(
                                      communityController
                                          .communities[i].communityName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 5, 8, 5),
                                        child: Text(
                                          communityController.communities[i]
                                              .communityDescription,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              communityController
                                                      .communities[i].isPrivate
                                                  ? Icons.lock
                                                  : Icons.lock_open,
                                              color: Colors.white,
                                              size: 24.0,
                                            ),
                                            Text(
                                              communityController.communities[i]
                                                          .isPrivate ==
                                                      true
                                                  ? 'Private'
                                                  : 'Public',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Memebers: ' +
                                              communityController.communities[i]
                                                  .communityMember.length
                                                  .toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
