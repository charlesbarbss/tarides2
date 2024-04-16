import 'package:flutter/material.dart';
import 'package:tarides/CommunityTabs/EventsTab.dart';
import 'package:tarides/CommunityTabs/PostTab.dart';
import 'package:tarides/CommunityTabs/SearchTab.dart';
import 'package:tarides/CommunityTabs/memberRequest.dart';
import 'package:tarides/CommunityTabs/viewMembers.dart';
import 'package:tarides/Controller/communityController.dart';
import 'package:tarides/Controller/userController.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key, required this.email});
  final String email;
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  UserController userController = UserController();
  CommunityController communityController = CommunityController();
  @override
  void initState() {
    userController.getUser(widget.email);
    communityController.getCommunityAndUser(widget.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: AnimatedBuilder(
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
                automaticallyImplyLeading: false,
                backgroundColor: Colors.black,
                title: const Text(
                  'Community',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  AnimatedBuilder(
                      animation: communityController,
                      builder: (context, snapshot) {
                        if (communityController.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Column(
                          children: [
                            if (communityController.community == null)
                              Container()
                            else
                              Row(
                                children: [
                              
                                  if (communityController
                                              .community!.communityAdmin ==
                                          userController.user.username &&
                                      communityController
                                              .community!.isPrivate ==
                                          true)
                                    IconButton(
                                      icon: const Icon(Icons.notifications),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MemberRequest(
                                                    email: widget.email,
                                                    community:
                                                        communityController
                                                            .community!,
                                                  )),
                                        );
                                      },
                                    ),
                                ],
                              ),
                          ],
                        );
                      }),
                ],
              ),
              body: Column(
                children: [
                  const TabBar(
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
                        SearchTab(
                          email: widget.email,
                        ),
                        PostTab(
                          email: widget.email,
                          communityId: userController.user.communityId,
                        ),
                        const EventsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
