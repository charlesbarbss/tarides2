import 'package:flutter/material.dart';
import 'package:tarides/BottomNav/NewRides/requestChallenge.dart';
import 'package:tarides/Controller/communityController.dart';
import 'package:tarides/Controller/ridesController.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/Model/userModel.dart';
import 'package:tarides/widgets/text_widget.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({
    super.key,
    required this.email,
    required this.user,
  });
  final String email;
  final Users user;
  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  UserController userController = UserController();
  CommunityController communityController = CommunityController();
  RidesController ridesController = RidesController();
  UserController getUsersWithCommunity = UserController();
  List<Users> users = [];

  @override
  initState() {
    userController.getUser(widget.email);
    userController.getAllUsers();
    communityController.getCommunityAndUser(widget.email);
    userController.getUsersWithCommunity();
    communityController.getAllCommunity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Select a Challenger',
          fontSize: 24,
          fontFamily: 'Bold',
          color: Colors.white,
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
          print(userController.usersWithCommunity.length);

          List<Users> usersWithCommunity = userController.usersWithCommunity
              .where((user) => user.username != widget.user.username)
              .toList();
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: usersWithCommunity.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              {
                return Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestChallenge(
                              email: widget.email,
                              user: userController.user,
                              userPicked: usersWithCommunity[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 40, 40, 40),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                    for (var x = 0;
                                        x <
                                            communityController
                                                .communities.length;
                                        x++)
                                      if (usersWithCommunity[index]
                                              .communityId ==
                                          communityController
                                              .communities[x].communityId)
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 8, 0),
                                            child: TextWidget(
                                              text: communityController
                                                  .communities[x].communityName,
                                              fontSize: 16,
                                              fontFamily: 'Bold',
                                              color: const Color.fromARGB(
                                                  255, 232, 155, 5),
                                            ),
                                          ),
                                        ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3.5,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    usersWithCommunity[index]
                                        .imageUrl
                                        .toString(),
                                    height: 130,
                                    width: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: TextWidget(
                                text:
                                    '${usersWithCommunity[index].firstName} ${usersWithCommunity[index].lastName}',
                                fontSize: 14,
                                fontFamily: 'Bold',
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: TextWidget(
                                text: '@${usersWithCommunity[index].username}',
                                fontSize: 12,
                                fontFamily: 'Regular',
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );

                // return Container();
              }
            },
          );
        },
      ),
    );
  }
}
