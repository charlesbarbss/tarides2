import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tarides/Controller/communityController.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/homePage.dart';

class InviteMembers extends StatefulWidget {
  const InviteMembers(
      {super.key,
      required this.user,
      required this.communityId,
      required this.communityName,
      required this.email});
  final String user;
  final String communityId;
  final String communityName;
  final String email;
  @override
  State<InviteMembers> createState() => _InviteMembersState();
}

class _InviteMembersState extends State<InviteMembers> {
  UserController userController = UserController();
  CommunityController communityController = CommunityController();
  @override
  void initState() {
    userController.getAllUsersWithNoCommunity();
    communityController.getAllCommunity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:
            const Text('Invite Members', style: TextStyle(color: Colors.white)),
      ),
      body: AnimatedBuilder(
          animation: userController,
          builder: (context, snapshot) {
            if (userController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return GridView.count(
              crossAxisCount: 2, // number of columns
              children: List.generate(
                  userController.usersWithNoCommunity.length, (index) {
                return InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Invite User'),
                          content: Text(
                              'Are you sure you want to invite this user?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Invite'),
                              onPressed: () async {
                                final inviteId = FirebaseFirestore.instance
                                    .collection('invite')
                                    .doc()
                                    .id;

                                await FirebaseFirestore.instance
                                    .collection('invite')
                                    .add({
                                  'inviteId': inviteId, // Add this line
                                  'requestedCommunityId': widget.communityId,
                                  'inviter': widget.user,
                                  'invitee': userController
                                      .usersWithNoCommunity[index].username,
                                  'communityName': widget.communityName,
                                }).then((value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage(
                                              email: widget.email,
                                              homePageIndex: 0,
                                            )), // replace NewPage with your page
                                  );
                                });
                              },
                            ),
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 180,
                    width: 200,
                    color: Colors.grey[900],
                    margin: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3.5,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                userController
                                    .usersWithNoCommunity[index].imageUrl
                                    .toString(),
                                height: 130,
                                width: 130,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text(
                            userController.usersWithNoCommunity[index].email,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ), // Replace with your email
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text(
                            userController.usersWithNoCommunity[index].username,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ), // Replace with your username
                      ],
                    ),
                  ),
                );
              }),
            );
          }),
    );
  }
}
