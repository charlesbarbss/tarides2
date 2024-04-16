import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tarides/Controller/communityController.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/Model/createCommunityModel.dart';
import 'package:tarides/homePage.dart';

class ViewMembers extends StatefulWidget {
  const ViewMembers(
      {super.key,
      required this.communityId,
      required this.admin,
      required this.email});
  final String communityId;
  final String admin;
  final String email;
  @override
  State<ViewMembers> createState() => _ViewMembersState();
}

class _ViewMembersState extends State<ViewMembers> {
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
                            onTap: communityController
                                        .community!.communityAdmin !=
                                    userController.members[i].username
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Member Options'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Promote Admin'),
                                            onPressed: () async {
                                              final userDoc =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('community')
                                                      .where('communityAdmin',
                                                          isEqualTo:
                                                              widget.admin)
                                                      .get();

                                              await userDoc.docs.first.reference
                                                  .update({
                                                'communityAdmin': userController
                                                    .members[i].username,
                                              }).then((value) {
                                                Navigator.of(ctx).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage(
                                                      email: widget.email,
                                                      homePageIndex: 0,
                                                    ),
                                                  ),
                                                );
                                              });
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Remove Member'),
                                            onPressed: () async {
                                              final userDoc =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('user')
                                                      .where('username',
                                                          isEqualTo:
                                                              userController
                                                                  .members[i]
                                                                  .username)
                                                      .get();

                                              await userDoc.docs.first.reference
                                                  .update({
                                                'communityId': '',
                                                'isCommunity': false,
                                              });
                                            

                                              final communityDoc =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('community')
                                                      .where('communityId',
                                                          isEqualTo:
                                                              communityController
                                                                  .community!
                                                                  .communityId)
                                                      .where('communityMember',
                                                          arrayContains:
                                                              userController
                                                                  .members[i]
                                                                  .username)
                                                      .get();

                                              await communityDoc
                                                  .docs.first.reference
                                                  .update({
                                                'communityMember':
                                                    FieldValue.arrayRemove([
                                                  userController
                                                      .members[i].username
                                                ]),
                                              }).then((value) {
                                                Navigator.of(ctx).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage(
                                                      email: widget.email,
                                                      homePageIndex: 0,
                                                    ),
                                                  ),
                                                );
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                : () {},
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
