import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tarides/Admin/adminHomePage.dart';

import 'package:tarides/Admin/widgets/adminViewMemberOfCommunity.dart';
import 'package:tarides/Controller/communityController.dart';

class AdminCommunityTab extends StatefulWidget {
  const AdminCommunityTab({super.key, required this.email});
  final String email;

  @override
  State<AdminCommunityTab> createState() => _AdminCommunityTabState();
}

class _AdminCommunityTabState extends State<AdminCommunityTab> {
  CommunityController communityController = CommunityController();

  @override
  void initState() {
    communityController.getAllCommunity();
    super.initState();
  }

  void _communityClicked(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an action'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Text("View Community Members"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminViewMemberOfCommunity(
                                email: widget.email,
                                index: index,
                                communityId: communityController
                                    .communities[index].communityId,
                              )), // Replace with your screen
                    );
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Delete Community"),
                  onTap: () async {
                    final deleteComm = await FirebaseFirestore.instance
                        .collection('community')
                        .where('communityId',
                            isEqualTo: communityController
                                .communities[index].communityId)
                        .get();

                    await deleteComm.docs.first.reference.delete();

                    for (var i = 0;
                        i <
                            communityController
                                .communities[index].communityMember.length;
                        i++) {
                      final resetMembers = await FirebaseFirestore.instance
                          .collection('user')
                          .where('username',
                              isEqualTo: communityController
                                  .communities[index].communityMember[i])
                          .get();

                      await resetMembers.docs.first.reference.update({
                        'communityId': '',
                        'isCommunity': false,
                      });
                    }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminHomePage(
                            email: widget.email,
                          ), // Replace NewScreen with the name of your screen
                        ));
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
          animation: communityController,
          builder: (context, snapshot) {
            if (communityController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return GridView.count(
              crossAxisCount: 2, // Number of columns
              children: List.generate(communityController.communities.length,
                  (index) {
                // Replace 6 with the number of users you have
                return InkWell(
                  onTap: () {
                    _communityClicked(index);
                  },
                  child: Container(
                    color: Colors.grey[900],
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: Text(
                            communityController
                                .communities[index].communityName,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ), // Replace with your email
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Text(
                              communityController
                                  .communities[index].communityDescription,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Icon(
                                communityController.communities[index].isPrivate
                                    ? Icons.lock
                                    : Icons.lock_open,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                              child: Text(
                                communityController
                                            .communities[index].isPrivate ==
                                        true
                                    ? 'Private'
                                    : 'Public',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Text(
                                'Members: ' +
                                    communityController.communities[index]
                                        .communityMember.length
                                        .toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
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
