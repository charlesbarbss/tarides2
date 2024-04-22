import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tarides/CommunityTabs/memberViewMembers/otherMember.dart';
import 'package:tarides/Controller/communityController.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/homePage.dart';

class ViewOtherMembers extends StatefulWidget {
  const ViewOtherMembers(
      {super.key,
      required this.email,
      required this.communityId,
      required this.admin});
  final String email;
  final String communityId;
  final String admin;

  @override
  State<ViewOtherMembers> createState() => _ViewOtherMembersState();
}

class _ViewOtherMembersState extends State<ViewOtherMembers> {
  UserController userController = UserController();
  CommunityController communityController = CommunityController();

  @override
  void initState() {
    userController.getAllMembers(widget.communityId, widget.admin);
    communityController.getCommunityAndUser(widget.email);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: userController,
        builder: (context, snapshot) {
          if (userController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.black),
            backgroundColor: Colors.black,
            body: AnimatedBuilder(
                animation: communityController,
                builder: (context, snapshot) {
                  if (communityController.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (communityController.community == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var i = 0; i < userController.members.length; i++)
                          InkWell(
                            onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Member Options'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('View Member Profile'),
                                            onPressed: () {
                                              Navigator.of(ctx).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OtherMembers(
                                                          email: userController
                                                              .members[i].email,
                                                          username: userController
                                                              .members[i].username,
                                                        )),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                              
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 150,
                                width: 400,
                                color: Color.fromARGB(31, 153, 150, 150),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (communityController
                                            .community!.communityAdmin ==
                                        userController.members[i].username)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
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
                                                userController
                                                    .members[i].imageUrl,
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
                                                  userController
                                                      .members[i].username,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              userController.members[i].email,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
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
                  );
                }),
          );
        });
  }
}
