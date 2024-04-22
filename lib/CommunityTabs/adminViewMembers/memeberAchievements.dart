import 'package:flutter/material.dart';
import 'package:tarides/Controller/userController.dart';

class MembersAchievementsScreen extends StatefulWidget {
  const MembersAchievementsScreen({super.key, required this.email});
  final String email;

  @override
  State<MembersAchievementsScreen> createState() =>
      _MembersAchievementsScreenState();
}

class _MembersAchievementsScreenState extends State<MembersAchievementsScreen> {
  UserController userController = UserController();
  @override
  void initState() {
    userController.getAchievement(widget.email);
    super.initState();
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Personal Achievements ',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outline),
                        color: Colors.white,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Personal Achievements'),
                                content: Text(
                                    'NEWBIE: is gained by creating an account.\n\nLEGENDARY: is gained by completing all Flawless Achivements'),
                                actions: [],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  // PERSONAL ACHIEVEMENTS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity:
                            userController.achievement.newbie == true ? 1 : 0.1,
                        child: Image.asset(
                          'assets/images/achievements/newbie.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Opacity(
                        opacity: userController.achievement.legendary == true
                            ? 1
                            : 0.1,
                        child: Image.asset(
                          'assets/images/achievements/legendary.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity:
                            userController.achievement.newbie == true ? 1 : 0.1,
                        child: Text(
                          'Newbie',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Opacity(
                        opacity: userController.achievement.legendary == true
                            ? 1
                            : 0.1,
                        child: Text(
                          'Legendary',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Flawless Achievements',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outline),
                        color: Colors.white,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Flawless Achievements'),
                                content: Text(
                                    'FLAWLESS 30: is gained by completing Goal 30 without missing a day.\n\nFLAWLESS 60: is gained by completing Goal 60 without missing a day.\n\nFLAWLESS 90: is gained by completing Goal 90 without missing a day.'),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  // second ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity:
                            userController.achievement.flawlessGoal30 == true
                                ? 1
                                : 0.1,
                        child: Image.asset(
                          'assets/images/achievements/flawless30.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Opacity(
                        opacity:
                            userController.achievement.flawlessGoal60 == true
                                ? 1
                                : 0.1,
                        child: Image.asset(
                          'assets/images/achievements/flawless60.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Opacity(
                        opacity:
                            userController.achievement.flawlessGoal90 == true
                                ? 1
                                : 0.1,
                        child: Image.asset(
                          'assets/images/achievements/flawless90.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity:
                            userController.achievement.flawlessGoal30 == true
                                ? 1
                                : 0.1,
                        child: Text(
                          'Flawless 30',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Opacity(
                        opacity:
                            userController.achievement.flawlessGoal60 == true
                                ? 1
                                : 0.1,
                        child: Text(
                          'Flawless 60',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Opacity(
                        opacity:
                            userController.achievement.flawlessGoal90 == true
                                ? 1
                                : 0.1,
                        child: Text(
                          'Flawless 90',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Resilient Achievements',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outline),
                        color: Colors.white,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Resilient Achievements'),
                                content: Text(
                                    'RESILIENT 30:is gained by completing Goal 30  missing some days.\n\nRESILIENT 60: is gained by completing Goal 60  missing some days.\n\nRESILIENT 90: is gained by completing Goal 90  missing some days.'),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  // third ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity:
                            userController.achievement.resilientgoal30 == true
                                ? 1
                                : 0.1,
                        child: Image.asset(
                          'assets/images/achievements/resilient30.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Opacity(
                        opacity:
                            userController.achievement.resilientgoal60 == true
                                ? 1
                                : 0.1,
                        child: Image.asset(
                          'assets/images/achievements/resilient60.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Opacity(
                        opacity:
                            userController.achievement.resilientgoal90 == true
                                ? 1
                                : 0.1,
                        child: Image.asset(
                          'assets/images/achievements/resilient90.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity:
                            userController.achievement.resilientgoal30 == true
                                ? 1
                                : 0.1,
                        child: Text(
                          'Resilient 30',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Opacity(
                        opacity:
                            userController.achievement.resilientgoal60 == true
                                ? 1
                                : 0.1,
                        child: Text(
                          'Resilient 60',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Opacity(
                        opacity:
                            userController.achievement.resilientgoal90 == true
                                ? 1
                                : 0.1,
                        child: Text(
                          'Resilient 90',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
