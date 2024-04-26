import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tarides/Controller/communityController.dart';
import 'package:tarides/Controller/inviteController.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/homePage.dart';

class Invitation extends StatefulWidget {
  const Invitation({super.key, required this.email});
  final String email;

  @override
  State<Invitation> createState() => _InvitationState();
}

class _InvitationState extends State<Invitation> {
  InviteController inviteController = InviteController();
  CommunityController communityController = CommunityController();
  UserController userController = UserController();
  @override
  void initState() {
    inviteController.getInvite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Invitation'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        email: widget.email,
                        homePageIndex: 4,
                      )),
            );
          },
        ),
      ),
      body: AnimatedBuilder(
          animation: inviteController,
          builder: (context, snapshot) {
            if (inviteController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (inviteController.invite.isEmpty) {
              return Center(
                  child: const Text('No Invitation',
                      style: TextStyle(color: Colors.white)));
            }

            return GridView.count(
              crossAxisCount: 1, // Number of columns
              children: List.generate(inviteController.invite.length, (index) {
                // Replace 6 with the number of users you have
                return Column(
                  children: [
                    Container(
                      height: 180,
                      width: 300,
                      color: Colors.grey[900],
                      margin: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                inviteController.invite[index].inviter +
                                    ' has invited you to join ' +
                                    inviteController
                                        .invite[index].communityName 
                                    ,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                child: Text(
                                  'Accept',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  final userDoc = await FirebaseFirestore
                                      .instance
                                      .collection('user')
                                      .where('username',
                                          isEqualTo: inviteController
                                              .invite[index].invitee)
                                      .get();
                                  if (userDoc.docs.isNotEmpty) {
                                    await userDoc.docs.first.reference.update({
                                      'communityId': inviteController
                                          .invite[index].requestedCommunityId,
                                      'isCommunity': true,
                                    });
                                  }
                                  final communityDoc = await FirebaseFirestore
                                      .instance
                                      .collection('community')
                                      .where('communityId',
                                          isEqualTo: inviteController
                                              .invite[index]
                                              .requestedCommunityId)
                                      .get();
                                  if (communityDoc.docs.isNotEmpty) {
                                    await communityDoc.docs.first.reference
                                        .update({
                                      'communityMember': FieldValue.arrayUnion([
                                        inviteController.invite[index].invitee
                                      ]),
                                    });
                                  }
                                  final invDoc = await FirebaseFirestore
                                      .instance
                                      .collection('invite')
                                      .where('invitee',
                                          isEqualTo: inviteController
                                              .invite[index].invitee)
                                      .get();
                                  await invDoc.docs.first.reference
                                      .delete()
                                      .then((value) {
                                    setState(() {
                                      inviteController.invite.removeAt(index);
                                    });
                                  }).then((value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage(
                                                email: widget.email,
                                                homePageIndex: 4,
                                              )),
                                    );
                                  });
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'Decline',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  final invDoc = FirebaseFirestore.instance
                                      .collection('invite')
                                      .where('inviteId',
                                          isEqualTo: inviteController
                                              .invite[index].inviteId)
                                      .get();
                                  invDoc.then((value) {
                                    value.docs.first.reference.delete();
                                    setState(() {
                                      inviteController.invite.removeAt(index);
                                    });
                                  }).then((value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage(
                                                email: widget.email,
                                                homePageIndex: 4,
                                              )),
                                    );
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }),
            );
          }),
    );
  }
}
