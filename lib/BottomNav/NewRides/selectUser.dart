import 'package:flutter/material.dart';
import 'package:tarides/BottomNav/NewRides/requestChallenge.dart';
import 'package:tarides/Controller/communityController.dart';
import 'package:tarides/Controller/userController.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({super.key, required this.email});
  final String email;

  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  UserController userController = UserController();
  CommunityController communityController = CommunityController();

  initState() {
    userController.getUser(widget.email);
    userController.getAllUsers();
    communityController.getCommunityAndUser(widget.email);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Rides',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: userController,
        builder: (context, snapshot) {
          if (userController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                for (var i = 0; i < userController.users.length; i++)
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequestChallenge(
                                email: widget.email,
                                user: userController.user,
                                userPicked: userController.users[i],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 180,
                          width: 200,
                          color: Colors.grey[900],
                          margin: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Center(
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
                                      userController.users[i].imageUrl
                                          .toString(),
                                      height: 130,
                                      width: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Text(
                                  userController.users[i].email,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ), // Replace with your email
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Text(
                                  userController.users[i].username,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ), // Replace with your username
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
