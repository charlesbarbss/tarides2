import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:tarides/BottomNav/Goal30Tabs/goal30Home.dart';
import 'package:tarides/Controller/goal30Controller.dart';
import 'package:tarides/Controller/goal30HistoryController.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/Model/userModel.dart';
import 'package:tarides/homePage.dart';

import 'Goal30Tabs/goal30HistoryScreen.dart';

class Goal30Screen extends StatefulWidget {
  const Goal30Screen(
      {super.key, required this.email, this.locationData, required this.user});
  final String email;
  final LocationData? locationData;
  final Users user;

  @override
  State<Goal30Screen> createState() => _Goal30ScreenState();
}

class _Goal30ScreenState extends State<Goal30Screen> {
  UserController userController = UserController();
  Goal30Controller goal30Controller = Goal30Controller();
  Goal30HistoryController goal30HistoryController = Goal30HistoryController();
  @override
  void initState() {
    userController.getUser(widget.email);
    goal30Controller.getGoal30(widget.email);
    goal30HistoryController.getGoal30History(widget.user.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: goal30HistoryController,
        builder: (context, snapshot) {
          if (goal30HistoryController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return AnimatedBuilder(
              animation: goal30Controller,
              builder: (context, snapshot) {
                if (goal30Controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return AnimatedBuilder(
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
                          title: Text(
                            goal30Controller.goal30.goal30Category == true
                                ? 'Goal 30'
                                : goal30Controller.goal30.goal60Category == true
                                    ? 'Goal 60'
                                    : goal30Controller.goal30.goal90Category ==
                                            true
                                        ? 'Goal 90'
                                        : 'Goal 30 Page',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.black,
                          actions: [
                            if (goal30Controller.goal30.isGoal30 == true)
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: BorderSide(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Goal30History(
                                                  email: widget.email,
                                                  goal30:
                                                      goal30Controller.goal30,
                                                )),
                                      );
                                    },
                                    child: Text(
                                      'Goal log',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: BorderSide(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      Map<String, bool> dayUpdates = {};
                                      for (int i = 0; i < 90; i++) {
                                        dayUpdates['day${i + 1}'] = false;
                                      }

                                      if (goal30HistoryController
                                          .historys.isNotEmpty) {
                                        for (var x = 0;
                                            x <
                                                goal30HistoryController
                                                    .historys.length;
                                            x++) {
                                          final goal30History =
                                              await FirebaseFirestore.instance
                                                  .collection('goal30History')
                                                  .where('user',
                                                      isEqualTo: userController
                                                          .user.username)
                                                  .get();
                                          if (goal30History.docs.isEmpty) {
                                            print('emptYYYY');
                                          }

                                          await goal30History
                                              .docs.first.reference
                                              .delete();
                                        }
                                      }

                                      final goal30Doc = await FirebaseFirestore
                                          .instance
                                          .collection('goal30')
                                          .where('username',
                                              isEqualTo:
                                                  userController.user.username)
                                          .get();

                                      await goal30Doc.docs.first.reference
                                          .update({
                                        'isGoal30': false,
                                        'goal30Category': false,
                                        'goal60Category': false,
                                        'goal90Category': false,
                                        'goalLength': 0,
                                        'timestamp': DateTime.now(),
                                        ...dayUpdates,
                                      }).then((value) {
                                        setState(() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                      email: widget.email,
                                                      homePageIndex: 3,
                                                    )), // Replace NewScreen with the actual class name of the new screen
                                          );
                                        });
                                      });
                                    },
                                    child: Text(
                                      'Reset',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        body: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (goal30Controller.goal30.isGoal30 == false)
                                Column(
                                  children: [
                                    SizedBox(height: 20.0),
                                    Text(
                                      'Choose a goal to start',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                    SizedBox(height: 20.0),
                                    Center(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: const Size.fromHeight(60),
                                          maximumSize:
                                              const Size.fromWidth(350),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: BorderSide.none,
                                          ),
                                          backgroundColor: Colors.red[900],
                                        ),
                                        onPressed: () async {
                                          final goal30Doc =
                                              await FirebaseFirestore.instance
                                                  .collection('goal30')
                                                  .where('username',
                                                      isEqualTo: userController
                                                          .user.username)
                                                  .get();

                                          await goal30Doc.docs.first.reference
                                              .update({
                                            'goal30Category': true,
                                            'isGoal30': true,
                                            'goalLength': 30,
                                            'timestamp': DateTime.now(),
                                          }).then((value) {
                                            setState(() {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage(
                                                          email: widget.email,
                                                          homePageIndex: 3,
                                                        )), // Replace NewScreen with the actual class name of the new screen
                                              );
                                            });
                                          });
                                        },
                                        child: Text(
                                          'Goal 30',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20.0),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: const Size.fromHeight(60),
                                        maximumSize: const Size.fromWidth(350),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: BorderSide.none,
                                        ),
                                        backgroundColor: Colors.red[900],
                                      ),
                                      onPressed: () async {
                                        final goal30Doc =
                                            await FirebaseFirestore.instance
                                                .collection('goal30')
                                                .where('username',
                                                    isEqualTo: userController
                                                        .user.username)
                                                .get();

                                        await goal30Doc.docs.first.reference
                                            .update({
                                          'goal60Category': true,
                                          'isGoal30': true,
                                          'goalLength': 60,
                                          'timestamp': DateTime.now(),
                                        }).then((value) {
                                          setState(() {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(
                                                        email: widget.email,
                                                        homePageIndex: 3,
                                                      )), // Replace NewScreen with the actual class name of the new screen
                                            );
                                          });
                                        });
                                      },
                                      child: Text(
                                        'Goal 60',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20.0),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: const Size.fromHeight(60),
                                        maximumSize: const Size.fromWidth(350),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: BorderSide.none,
                                        ),
                                        backgroundColor: Colors.red[900],
                                      ),
                                      onPressed: () async {
                                        final goal30Doc =
                                            await FirebaseFirestore.instance
                                                .collection('goal30')
                                                .where('username',
                                                    isEqualTo: userController
                                                        .user.username)
                                                .get();

                                        await goal30Doc.docs.first.reference
                                            .update({
                                          'goal90Category': true,
                                          'isGoal30': true,
                                          'goalLength': 90,
                                          'timestamp': DateTime.now(),
                                        }).then((value) {
                                          setState(() {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(
                                                        email: widget.email,
                                                        homePageIndex: 3,
                                                      )), // Replace NewScreen with the actual class name of the new screen
                                            );
                                          });
                                        });
                                      },
                                      child: Text(
                                        'Goal 90',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else if (goal30Controller.goal30.isGoal30 == true)
                                Goal30Home(
                                  goal30: goal30Controller.goal30,
                                  email: widget.email,
                                  location: widget.locationData,
                                ),
                            ],
                          ),
                        ),
                      );
                    });
              });
        });
  }
}
