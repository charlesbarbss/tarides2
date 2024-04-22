import 'package:flutter/material.dart';
import 'package:tarides/CommunityTabs/memberViewMembers/otherMemberAchievements.dart';
import 'package:tarides/CommunityTabs/memberViewMembers/otherMemberProfile.dart';

class OtherMembers extends StatefulWidget {
  const OtherMembers({super.key, required this.email, required this.username});
  final String email;
  final String username;

  @override
  State<OtherMembers> createState() => _OtherMembersState();
}

class _OtherMembersState extends State<OtherMembers> {
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
                  OtherMemberProfile(
                    email: widget.email,
                    username: widget.username,
                  ),
                  OtherMemberAchievements(
                    email: widget.email,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
