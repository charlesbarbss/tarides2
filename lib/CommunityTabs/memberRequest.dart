import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tarides/Controller/communityController.dart';
import 'package:tarides/Controller/requestController.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/Model/createCommunityModel.dart';
import 'package:tarides/homePage.dart';

class MemberRequest extends StatefulWidget {
  const MemberRequest(
      {super.key, required this.email, required this.community});
  final String email;
  final Community community;

  @override
  State<MemberRequest> createState() => _MemberRequestState();
}

class _MemberRequestState extends State<MemberRequest> {
  UserController userController = UserController();
  CommunityController communityController = CommunityController();
  RequestContoller requestContoller = RequestContoller();
  @override
  void initState() {
    userController.getUser(widget.email);
    userController.getAllUsers();
    communityController.getCommunityAndUser(widget.email);
    requestContoller.getAllReqeust();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Community Memeber Request'),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: AnimatedBuilder(
            animation: requestContoller,
            builder: (context, snapshot) {
              if (requestContoller.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  for (var i = 0; i < requestContoller.request.length; i++)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 200,
                            width: 400,
                            color: Color.fromARGB(31, 153, 150, 150),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3.5,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: Image.network(
                                            requestContoller.users[i].imageUrl,
                                            height: 130,
                                            width: 130,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              requestContoller
                                                  .request[i].usersName,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          requestContoller.users[i].email,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    requestContoller.request[i].usersName +
                                        ' has requested to join ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.green,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.check),
                                        color: Colors.green,
                                        iconSize:
                                            30.0, // Increase the icon size
                                        onPressed: () async {
                                          final userDoc =
                                              await FirebaseFirestore.instance
                                                  .collection('user')
                                                  .where('username',
                                                      isEqualTo:
                                                          requestContoller
                                                              .request[i]
                                                              .usersName)
                                                  .get();

                                          await userDoc.docs.first.reference
                                              .update({
                                            'communityId':
                                                widget.community.communityId,
                                            'isCommunity': true,
                                          });
                                          final communityDoc =
                                              await FirebaseFirestore.instance
                                                  .collection('community')
                                                  .where('communityId',
                                                      isEqualTo: widget
                                                          .community
                                                          .communityId)
                                                  .get();
                                          await communityDoc
                                              .docs.first.reference
                                              .update({
                                            'communityMember':
                                                FieldValue.arrayUnion([
                                              requestContoller
                                                  .request[i].usersName
                                            ]),
                                          });
                                          final requestDoc =
                                              await FirebaseFirestore
                                                  .instance
                                                  .collection('request')
                                                  .where(
                                                      'usersName',
                                                      isEqualTo:
                                                          requestContoller
                                                              .request[i]
                                                              .usersName)
                                                  .get();
                                          await requestDoc.docs.first.reference
                                              .delete()
                                              .then((value) {
                                            setState(() {
                                              requestContoller.request
                                                  .removeAt(i);
                                            });
                                          }).then((value) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(
                                                        email: widget.email,
                                                        homePageIndex: 0,
                                                      )),
                                            );
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.close),
                                        color: Colors.red,
                                        iconSize:
                                            30.0, // Increase the icon size
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('request')
                                              .where('usersName',
                                                  isEqualTo: requestContoller
                                                      .request[i].usersName)
                                              .get()
                                              .then((snapshot) {
                                            for (DocumentSnapshot ds
                                                in snapshot.docs) {
                                              ds.reference.delete();
                                            }
                                          });
                                          setState(() {
                                            requestContoller.request
                                                .removeAt(i);

                                           
                                          });
                                           Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(
                                                        email: widget.email,
                                                        homePageIndex: 0,
                                                      )),
                                            );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            }),
      ),
    );
  }
}
