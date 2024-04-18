import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tarides/Auth/logInPage.dart';
import 'package:tarides/Model/pedalHistoryModel.dart';
import 'package:tarides/Model/userModel.dart';
import 'package:tarides/ProfileTabs/achievementsTab.dart';
import 'package:tarides/ProfileTabs/profileTab.dart';
import 'package:tarides/ProfileTabs/progressTab.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {super.key, required this.email, required this.user});
  final String email;
  final Users user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then(
                        (value) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LogInPage(),
                          ),
                        ),
                      );
                }),
          ],
          backgroundColor: Colors.black,
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
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
                Tab(
                  text: 'Progress',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ProfileTab(email: widget.email),
                  AchievmentsTab(
                    email: widget.email,
                  ),
                  ProgressTab(
                    email: widget.email,
                    user: widget.user,
                  
                  
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
