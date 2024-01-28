import 'package:flutter/material.dart';
import 'package:tarides/CommunityTabs/EventsTab.dart';
import 'package:tarides/CommunityTabs/PostTab.dart';
import 'package:tarides/CommunityTabs/SearchTab.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key, required this.email});
final String email;
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(initialIndex: 0,
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Text(
            'Community',
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
                  text: 'Search',
                ),
                Tab(
                  text: 'Post',
                ),
                Tab(
                  text: 'Events',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SearchTab(email: widget.email,),
                  PostTab(),
                  EventsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
