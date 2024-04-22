import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tarides/Admin/adminHomePage.dart';
import 'package:tarides/CommunityTabs/adminViewMembers/memberProfile.dart';
import 'package:tarides/CommunityTabs/adminViewMembers/memeberAchievements.dart';
import 'package:tarides/Controller/userController.dart';

class MyMembers extends StatefulWidget {
  const MyMembers({super.key, required this.email, required this.username});
  final String email;
  final String username;

  @override
  State<MyMembers> createState() => _MyMembersState();
}

class _MyMembersState extends State<MyMembers> {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
            TabBar(
              dividerColor: Colors.white,
              indicatorColor: Colors.red,
              tabs: [
                Tab(
                  text: 'Profile',
                ),
                Tab(
                  text: 'Achievement',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  MemberProfileScreen(
                      username: widget.username,
                    email: widget.email,
                  ),
                  MembersAchievementsScreen(
                    email: widget.email,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
