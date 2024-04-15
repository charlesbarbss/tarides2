import 'package:flutter/material.dart';
import 'package:tarides/CommunityTabs/CreateCommunity/createCommunity.dart';
import 'package:tarides/CommunityTabs/JoinCommunity/joinCommunity.dart';
import 'package:tarides/Controller/communityController.dart';
import 'package:tarides/Controller/userController.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key, required this.email});
  final String email;
  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  UserController userController = UserController();

  @override
  void initState() {
    userController.getUser(widget.email);
    super.initState();
  }

  void _createCommunity() {
    if (userController.user.isCommunity == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('You already have a community'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateCommunity(
            email: widget.email,
          ),
        ),
      );
    }
  }

  void _joinCommunity() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JoinCommunity(email: widget.email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
          animation: userController,
          builder: (context, snapshot) {
            if (userController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _joinCommunity,
                        child: Text(
                          userController.user.isCommunity == true
                              ? 'Search community'
                              : 'Join Community',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _createCommunity,
                    child: const Text(
                      'Create a Community',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Text(
                    userController.user.isCommunity == true
                        ? 'You have a community'
                        : 'NOTE: You don\'t have a community yet',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
