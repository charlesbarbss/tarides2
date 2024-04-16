import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tarides/Admin/tabs/adminCommunityTab.dart';
import 'package:tarides/Admin/tabs/adminUsersTab.dart';
import 'package:tarides/Auth/logInPage.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key, required this.email});
  final String email;

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int initialIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
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
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Users',
              ),
              Tab(
                text: 'Community',
              ),
            ],
          ),
          title: Text(
            'Admin',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: TabBarView(
          children: [
            AdminUserTab(),
            AdminCommunityTab(
              email: widget.email,
            ),
          ],
        ),
      ),
    );
  }
}
