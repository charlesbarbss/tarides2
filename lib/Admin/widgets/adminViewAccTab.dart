import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tarides/Admin/widgets/adminViewAccount.dart';
import 'package:tarides/Admin/widgets/adminViewAccountAchievement.dart';

class AdminViewAccTab extends StatefulWidget {
  const AdminViewAccTab(
      {super.key, required this.index, required this.username, required this.email});
  final int index;
  final String username;
  final String email;

  @override
  State<AdminViewAccTab> createState() => _AdminViewAccTabState();
}

class _AdminViewAccTabState extends State<AdminViewAccTab> {
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
                  AdminViewAccount(
                    index: widget.index,
                    username: widget.username,
                  ),
                  AdminViewAccountAchievement(
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
