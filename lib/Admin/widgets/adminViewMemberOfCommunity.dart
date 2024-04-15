import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tarides/Admin/adminHomePage.dart';
import 'package:tarides/Controller/communityController.dart';
import 'package:tarides/Controller/userController.dart';

class AdminViewMemberOfCommunity extends StatefulWidget {
  const AdminViewMemberOfCommunity(
      {super.key,
      required this.index,
      required this.email,
      required this.communityId});
  final int index;
  final String email;
  final String communityId;

  @override
  State<AdminViewMemberOfCommunity> createState() =>
      _AdminViewMemberOfCommunityState();
}

class _AdminViewMemberOfCommunityState
    extends State<AdminViewMemberOfCommunity> {
  CommunityController communityController = CommunityController();
  UserController userController = UserController();
  @override
  void initState() {
    communityController.adminGetCommunityMembers(widget.communityId);
    communityController.getAllCommunity();

    super.initState();
  }

  void _memberClicked(int i) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an action'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Text("Remove Member"),
                  onTap: () async {
                    final userDoc = await FirebaseFirestore.instance
                        .collection('user')
                        .where('username',
                            isEqualTo: communityController
                                .allCommunityMembers[i].username
                                .toString())
                        .get();

                    await userDoc.docs.first.reference.update({
                      'communityId': '',
                      'isCommunity': false,
                    });

                    final communityDoc = await FirebaseFirestore.instance
                        .collection('community')
                        .where('communityId',
                            isEqualTo: widget.communityId)
                        .where('communityMember',
                            arrayContains: communityController
                                .allCommunityMembers[i].username
                                .toString())
                        .get();

                    await communityDoc.docs.first.reference.update({
                      'communityMember': FieldValue.arrayRemove([
                        communityController.allCommunityMembers[i].username
                            .toString()
                      ]),
                    }).then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminHomePage(
                            email: widget.email,
                          ), // Replace NewScreen with the name of your screen
                        ),
                      );
                    });
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                if (communityController.allCommunityMembers[i].username
                        .toString() !=
                    communityController
                        .communities[widget.index].communityAdmin)
                  GestureDetector(
                    child: Text("Promote Admin"),
                    onTap: () async {
                      final userDoc = await FirebaseFirestore.instance
                          .collection('community')
                           .where('communityId',
                            isEqualTo: widget.communityId)
                      
                          .get();

                      await userDoc.docs.first.reference.update({
                        'communityAdmin': communityController
                            .allCommunityMembers[i].username
                            .toString(),
                      }).then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminHomePage(
                              email: widget.email,
                            ), // Replace NewScreen with the name of your screen
                          ),
                        );
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
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
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(
                'Members',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.black,
            ),
            body: SingleChildScrollView(
              child: AnimatedBuilder(
                  animation: communityController,
                  builder: (context, snapshot) {
                    if (communityController.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Center(
                      child: Column(
                        children: [
                          for (int i = 0;
                              i <
                                  communityController
                                      .allCommunityMembers.length;
                              i++)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () => _memberClicked(i),
                                    child: Container(
                                      height: 190,
                                      width: 300,
                                      color: Colors.grey[900],
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              if (communityController
                                                      .allCommunityMembers[i]
                                                      .username
                                                      .toString() ==
                                                  communityController
                                                      .communities[widget.index]
                                                      .communityAdmin)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 8, 8, 0),
                                                  child: Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                    size: 25,
                                                  ),
                                                ),
                                            ],
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 8, 8),
                                            child: Center(
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
                                                    communityController
                                                        .allCommunityMembers[i]
                                                        .imageUrl
                                                        .toString(),
                                                    height: 130,
                                                    width: 130,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          Text(
                                            communityController
                                                .allCommunityMembers[i].email
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ), // Replace with your email
                                          Text(
                                            communityController
                                                .allCommunityMembers[i].username
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  }),
            ),
          );
        });
  }
}
