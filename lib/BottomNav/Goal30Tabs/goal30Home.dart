import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:tarides/BottomNav/Goal30Tabs/goal30Data.dart';
import 'package:tarides/BottomNav/Goal30Tabs/goal30HistoryScreen.dart';
import 'package:tarides/BottomNav/Goal30Tabs/mapScreen.dart';
import 'package:tarides/Controller/goal30Controller.dart';
import 'package:tarides/Controller/goal30HistoryController.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/Model/goal30HistoryModel.dart';
import 'package:tarides/Model/goal30Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tarides/homePage.dart';

class Goal30Home extends StatefulWidget {
  const Goal30Home(
      {super.key,
      required this.goal30,
      required this.email,
      required this.location});

  final Goal30 goal30;
  final String email;
  final LocationData? location;

  @override
  State<Goal30Home> createState() => _Goal30HomeState();
}

class _Goal30HomeState extends State<Goal30Home> {
  Goal30HistoryController goal30HistoryController = Goal30HistoryController();
  // UserController userController = UserController();

  Goal30Controller goal30Controller = Goal30Controller();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  ScrollController scrollController = ScrollController();
  final ItemScrollController itemScrollController = ItemScrollController();

  String? result;
  String? bmicategory;
  double? bmi;

  int counter = 0;

  int goalDay = 0;
  List<int> currentDay = [];
  late DateTime startDate;
  late Goal30 goals30;
  int day = 0;
  bool click = false;
  int dateDay = DateTime.now().day;
  final keys = List<GlobalKey>.generate(90, (index) => GlobalKey());

  void daySet() async {
    for (var i = 1; i < 90; i++) {
      final days = await FirebaseFirestore.instance
          .collection('goal30')
          .where('username', isEqualTo: widget.goal30.username)
          .where('day$i', isEqualTo: false)
          .get();

      if (days.docs.isEmpty) {
        print('no day found');
        currentDay.add(i);
      }
    }
  }

  void loadGoalDay() async {
    final goal30QuerySnapshot = await FirebaseFirestore.instance
        .collection('goal30')
        .where('username', isEqualTo: widget.goal30.username)
        .get();

    if (goal30QuerySnapshot.docs.isEmpty) {
      throw Exception('No goal30 found');
    }

    final goal30DocumentSnapshot = goal30QuerySnapshot.docs.first;
    goals30 = Goal30.fromDocument(goal30DocumentSnapshot);

    SharedPreferences.getInstance().then((prefs) {
      startDate = DateTime.parse(
          prefs.getString('startDate') ?? DateTime.now().toIso8601String());

      DateTime goalDate = widget.goal30.timestamp.toDate();

      // Set the time of both dates to midnight
      startDate = DateTime(startDate.year, startDate.month, startDate.day);
      goalDate = DateTime(goalDate.year, goalDate.month, goalDate.day);

      setState(() {
        goalDay = goalDate.difference(startDate).inDays.abs() + 1;
        print(['hey', goalDate]);
        print(goalDate.difference(startDate).inDays);
        print(['daysssss', goalDay]);

        if (goalDay != 1 && goalDay != 2 && goalDay != 3) {
          Future.delayed(Duration(milliseconds: 500), () {
            itemScrollController.scrollTo(
              index: goalDay,
              alignment: 0.5,
              duration: Duration(seconds: 3), // to center the item
            );
          });
        }

        // if(goalDay )
      });
    });
    for (var i = 0; i < goals30.goalLength; i++) {
      if (goals30.goalLength == goal30.length) {
        if (goalDay - 1 > i && goal30[i].kmGoal.toString() == '0.0') {
          await goal30QuerySnapshot.docs.first.reference.update({
            'day${i + 1}': true,
          });
        }
      }
    }
    for (var i = 0; i < goals30.goalLength; i++) {
      if (goals30.goalLength == goal60.length) {
        if (goalDay - 1 > i && goal60[i].kmGoal.toString() == '0.0') {
          await goal30QuerySnapshot.docs.first.reference.update({
            'day${i + 1}': true,
          });
        }
      }
    }
    for (var i = 0; i < goals30.goalLength; i++) {
      if (goals30.goalLength == goal90.length) {
        if (goalDay - 1 > i && goal90[i].kmGoal.toString() == '0.0') {
          await goal30QuerySnapshot.docs.first.reference.update({
            'day${i + 1}': true,
          });
        }
      }
    }
    // for (var i = 0; i < goal30.length; i++) {
    //   if (goalDay > i && goal60[i].kmGoal.toString() == '0.0') {
    //     await goal30QuerySnapshot.docs.first.reference.update({
    //       'day${i + 1}': true,
    //     });
    //   }
    // }
    // for (var i = 0; i < goal30.length; i++) {
    //   if (goalDay > i && goal90[i].kmGoal.toString() == '0.0') {
    //     await goal30QuerySnapshot.docs.first.reference.update({
    //       'day${i + 1}': true,
    //     });
    //   }
    // }
  }

  void refreshData() {
    setState(() {
      currentDay = currentDay;
      goalDay = goalDay;
    });
  }

  @override
  void initState() {
    goal30HistoryController.getGoal30History(widget.goal30.username);
    super.initState();
    daySet();
    // checkDays();
    initializeGoalDay();

    // initializeLocation();
    goal30Controller.getGoal30(widget.email);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadGoalDay();
  }

  void initializeGoalDay() async {
    // await goal30Controller.getGoal30(widget.email);
    loadGoalDay();
  }

  void _proceed() async {
    if (goalDay == day) {
      print('1');
    }
    if (goal30[day - 1].kmGoal.toString() == '0.0' &&
        widget.goal30.goalLength == 30 &&
        goalDay == day) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No need to ride.'),
        ),
      );
    }

    if (goal60[day - 1].kmGoal.toString() == '0.0' &&
        widget.goal30.goalLength == 60 &&
        goalDay == day) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No need to ride.'),
        ),
      );
    }
    if (goal90[day - 1].kmGoal.toString() == '0.0' &&
        widget.goal30.goalLength == 90 &&
        goalDay == day) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No need to ride.'),
        ),
      );
    }

    if (!currentDay.contains(day)) {
      if (bmicategory != null &&
          result != null &&
          widget.goal30.goalLength == 30 &&
          goal30[day - 1].kmGoal.toString() != '0.0') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MapScreen(
                    day: day,
                    goal30: widget.goal30,
                    height: _heightController.text,
                    weight: _weightController.text,
                    result: result.toString(),
                    bmiCategory: bmicategory.toString(),
                    email: widget.email,
                    location: widget.location,
                  )),
        );
      }

      if (bmicategory != null &&
          result != null &&
          widget.goal30.goalLength == 60 &&
          goal60[day - 1].kmGoal.toString() != '0.0') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MapScreen(
                    day: day,
                    goal30: widget.goal30,
                    height: _heightController.text,
                    weight: _weightController.text,
                    result: result.toString(),
                    bmiCategory: bmicategory.toString(),
                    email: widget.email,
                    location: widget.location,
                  )),
        );
      }

      if (bmicategory != null &&
          result != null &&
          widget.goal30.goalLength == 90 &&
          goal90[day - 1].kmGoal.toString() != '0.0') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MapScreen(
                    day: day,
                    goal30: widget.goal30,
                    height: _heightController.text,
                    weight: _weightController.text,
                    result: result.toString(),
                    bmiCategory: bmicategory.toString(),
                    email: widget.email,
                    location: widget.location,
                  )),
        );
      }

      if (bmicategory == null &&
          result == null &&
          widget.goal30.goalLength == 30 &&
          goal30[day - 1].kmGoal.toString() != '0.0') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please calculate BMI first.'),
          ),
        );
      }

      if (bmicategory == null &&
          result == null &&
          widget.goal30.goalLength == 60 &&
          goal60[day - 1].kmGoal.toString() != '0.0') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please calculate BMI first.'),
          ),
        );
      }

      if (bmicategory == null &&
          result == null &&
          widget.goal30.goalLength == 90 &&
          goal90[day - 1].kmGoal.toString() != '0.0') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please calculate BMI first.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Goal is already Complete'),
        ),
      );
    }
  }

  void _calculateBMI() {
    if (goal30[day - 1].kmGoal.toString() == '0.0' &&
        widget.goal30.goalLength == 30 &&
        goalDay == day) {
      print(goal30[day].kmGoal.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No need to calculate BMI for rest day.'),
        ),
      );
    }

    if (goal60[day - 1].kmGoal.toString() == '0.0' &&
        widget.goal30.goalLength == 60 &&
        goalDay == day) {
      print('2');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No need to calculate BMI for rest day.'),
        ),
      );
    }
    if (goal90[day - 1].kmGoal.toString() == '0.0' &&
        widget.goal30.goalLength == 90 &&
        goalDay == day) {
      print('3');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No need to calculate BMI for rest day.'),
        ),
      );
    }
    if (!currentDay.contains(day)) {
      if (_heightController.text.isEmpty &&
          _weightController.text.isEmpty &&
          widget.goal30.goalLength == 30 &&
          goal30[day - 1].kmGoal.toString() != '0.0') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter your height and weight.'),
          ),
        );
      } else {
        double height = double.tryParse(_heightController.text) ?? 0.0;
        double weight = double.tryParse(_weightController.text) ?? 0.0;

        if (height > 0 && weight > 0) {
          double bmi = (weight / (height * height) * 10000);

          setState(() {
            result = '${bmi.toStringAsFixed(1)}';
            if (bmi < 18.5) {
              bmicategory = 'UnderWeight';
            } else if (bmi >= 18.5 && bmi <= 24.9) {
              bmicategory = 'Normal';
            } else if (bmi >= 25 && bmi <= 29.9) {
              bmicategory = 'OverWeight';
            } else if (bmi >= 30) {
              bmicategory = 'Obesity';
            }
          });
        }
      }
      if (_heightController.text.isEmpty &&
          _weightController.text.isEmpty &&
          widget.goal30.goalLength == 60 &&
          goal60[day - 1].kmGoal.toString() != '0.0') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter your height and weight.'),
          ),
        );
      } else {
        double height = double.tryParse(_heightController.text) ?? 0.0;
        double weight = double.tryParse(_weightController.text) ?? 0.0;

        if (height > 0 && weight > 0) {
          double bmi = (weight / (height * height) * 10000);
          setState(() {
            result = '${bmi.toStringAsFixed(1)}';
            if (bmi < 18.5) {
              bmicategory = 'UnderWeight';
            } else if (bmi >= 18.5 && bmi <= 24.9) {
              bmicategory = 'Normal';
            } else if (bmi >= 25 && bmi <= 29.9) {
              bmicategory = 'OverWeight';
            } else if (bmi >= 30) {
              bmicategory = 'Obesity';
            }
          });
        }
      }

      if (_heightController.text.isEmpty &&
          _weightController.text.isEmpty &&
          widget.goal30.goalLength == 90 &&
          goal90[day - 1].kmGoal.toString() != '0.0') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter your height and weight.'),
          ),
        );
      } else {
        double height = double.tryParse(_heightController.text) ?? 0.0;
        double weight = double.tryParse(_weightController.text) ?? 0.0;

        if (height > 0 && weight > 0) {
          double bmi = (weight / (height * height) * 10000);
          setState(() {
            result = '${bmi.toStringAsFixed(1)}';
            if (bmi < 18.5) {
              bmicategory = 'UnderWeight';
            } else if (bmi >= 18.5 && bmi <= 24.9) {
              bmicategory = 'Normal';
            } else if (bmi >= 25 && bmi <= 29.9) {
              bmicategory = 'OverWeight';
            } else if (bmi >= 30) {
              bmicategory = 'Obesity';
            }
          });
        }
      }

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Goal is already Complete'),
      //   ),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Goal is already Complete'),
        ),
      );
    }
  }

  var checkDay = 0;
  @override
  Widget build(BuildContext context) {
    print('G O A L  D A Y${goalDay}');
    print('CHECK  D A Y${checkDay}');
    // checkDays();
    // dayIndetifier();
    Widget buildCard(BMI item, int dateDay, GlobalKey key) => InkWell(
          onTap: () {
            refreshData();
            setState(() {
              day = item.day;
              counter = item.day;
              click = true;
            });
          },
          child: AnimatedBuilder(
              animation: goal30Controller,
              builder: (context, snapshot) {
                if (goal30Controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: day == item.day
                              ? Colors.white
                              : Colors.transparent,
                          width: 1,
                        ),
                        color: const Color(0xFF181A20),
                      ),
                      width: 80,
                      height: 130,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Day',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              item.day.toString(),
                              style: TextStyle(
                                color: currentDay.contains(item.day) &&
                                        goalDay == item.day
                                    ? Colors.red
                                    : goalDay == item.day
                                        ? Colors.red
                                        : Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (currentDay.contains(item.day) && click == true)
                              Text('DONE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  )),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        );
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: 130,
          child: ScrollablePositionedList.builder(
            itemScrollController: itemScrollController,
            itemCount: widget.goal30.goalLength,
            itemBuilder: (context, index) {
              if (widget.goal30.goalLength == 30) {
                final itemKey = GlobalKey();
                final item = goal30[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: buildCard(item, dateDay, itemKey),
                );
              }
              if (widget.goal30.goalLength == 60) {
                final itemKey = GlobalKey();
                final item = goal60[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: buildCard(item, dateDay, itemKey),
                );
              }
              if (widget.goal30.goalLength == 90) {
                final itemKey = GlobalKey();
                final item = goal90[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: buildCard(item, dateDay, itemKey),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: buildCard(goal30[index], dateDay, keys[index]),
              );
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(height: 5),
        if (click == true)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedBuilder(
                animation: goal30HistoryController,
                builder: (context, snapshot) {
                  if (goal30HistoryController.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                    child: Container(
                      color: Colors.grey[900],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "DAY no: ${day}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              SizedBox(width: 10),
                              if (day == 30 && goalDay == 30)
                                TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('goal30')
                                        .where('username',
                                            isEqualTo: widget.goal30.username)
                                        .get()
                                        .then((QuerySnapshot querySnapshot) {
                                      print('sud for loop');
                                      for (var i = 1;
                                          i <= widget.goal30.goalLength;
                                          i++) {
                                        final achieve = querySnapshot.docs
                                            .where(
                                                (doc) => doc['day$i'] == true);
                                        if (achieve.isNotEmpty) {
                                          print('Day $i is achieved');
                                          setState(() {
                                            checkDay++;
                                          });
                                        } else {
                                          print('Day $i is not achieved');
                                        }
                                      }
                                    }).then((value) async {
                                      if (checkDay <= 29) {
                                        print('RESILIENT');
                                        final achiever = await FirebaseFirestore
                                            .instance
                                            .collection('achievements')
                                            .where('username',
                                                isEqualTo:
                                                    widget.goal30.username)
                                            .get();

                                        if (achiever.docs.isNotEmpty) {
                                          achiever.docs.first.reference.update({
                                            'resilientgoal30': true,
                                          }).then((value) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Congratulations!'),
                                                  content: const Text(
                                                      'You received the Resilient 30 Badge'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('OK'),
                                                      onPressed: () async {
                                                        Map<String, bool>
                                                            dayUpdates = {};
                                                        for (int i = 0;
                                                            i < 90;
                                                            i++) {
                                                          dayUpdates[
                                                                  'day${i + 1}'] =
                                                              false;
                                                        }

                                                        if (goal30HistoryController
                                                            .historys
                                                            .isNotEmpty) {
                                                          for (var x = 0;
                                                              x <
                                                                  goal30HistoryController
                                                                      .historys
                                                                      .length;
                                                              x++) {
                                                            final goal30History =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'goal30History')
                                                                    .where(
                                                                        'user',
                                                                        isEqualTo: widget
                                                                            .goal30
                                                                            .username)
                                                                    .get();
                                                            if (goal30History
                                                                .docs.isEmpty) {
                                                              print('emptYYYY');
                                                            }

                                                            await goal30History
                                                                .docs
                                                                .first
                                                                .reference
                                                                .delete();
                                                          }
                                                        }

                                                        final goal30Doc =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'goal30')
                                                                .where(
                                                                    'username',
                                                                    isEqualTo: widget
                                                                        .goal30
                                                                        .username)
                                                                .get();

                                                        await goal30Doc.docs
                                                            .first.reference
                                                            .update({
                                                          'isGoal30': false,
                                                          'goal30Category':
                                                              false,
                                                          'goal60Category':
                                                              false,
                                                          'goal90Category':
                                                              false,
                                                          'goalLength': 0,
                                                          'timestamp':
                                                              DateTime.now(),
                                                          ...dayUpdates,
                                                        }).then((value) {
                                                          setState(() {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      HomePage(
                                                                        email: widget
                                                                            .email,
                                                                        homePageIndex:
                                                                            3,
                                                                      )), // Replace NewScreen with the actual class name of the new screen
                                                            );
                                                          });
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          });
                                        }
                                      }
                                      if (checkDay == 30) {
                                        print('RESILIENT');
                                        final achiever = await FirebaseFirestore
                                            .instance
                                            .collection('achievements')
                                            .where('username',
                                                isEqualTo:
                                                    widget.goal30.username)
                                            .get();

                                        if (achiever.docs.isNotEmpty) {
                                          achiever.docs.first.reference.update({
                                            'flawlessGoal30': true,
                                            'legendary': true,
                                          }).then((value) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Congratulations!'),
                                                  content: const Text(
                                                      'You received the Flawless 30 Badge'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('OK'),
                                                      onPressed: () async {
                                                        Map<String, bool>
                                                            dayUpdates = {};
                                                        for (int i = 0;
                                                            i < 90;
                                                            i++) {
                                                          dayUpdates[
                                                                  'day${i + 1}'] =
                                                              false;
                                                        }

                                                        if (goal30HistoryController
                                                            .historys
                                                            .isNotEmpty) {
                                                          for (var x = 0;
                                                              x <
                                                                  goal30HistoryController
                                                                      .historys
                                                                      .length;
                                                              x++) {
                                                            final goal30History =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'goal30History')
                                                                    .where(
                                                                        'user',
                                                                        isEqualTo: widget
                                                                            .goal30
                                                                            .username)
                                                                    .get();
                                                            if (goal30History
                                                                .docs.isEmpty) {
                                                              print('emptYYYY');
                                                            }

                                                            await goal30History
                                                                .docs
                                                                .first
                                                                .reference
                                                                .delete();
                                                          }
                                                        }

                                                        final goal30Doc =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'goal30')
                                                                .where(
                                                                    'username',
                                                                    isEqualTo: widget
                                                                        .goal30
                                                                        .username)
                                                                .get();

                                                        await goal30Doc.docs
                                                            .first.reference
                                                            .update({
                                                          'isGoal30': false,
                                                          'goal30Category':
                                                              false,
                                                          'goal60Category':
                                                              false,
                                                          'goal90Category':
                                                              false,
                                                          'goalLength': 0,
                                                          'timestamp':
                                                              DateTime.now(),
                                                          ...dayUpdates,
                                                        }).then((value) {
                                                          setState(() {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      HomePage(
                                                                        email: widget
                                                                            .email,
                                                                        homePageIndex:
                                                                            3,
                                                                      )), // Replace NewScreen with the actual class name of the new screen
                                                            );
                                                          });
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          });
                                        }
                                      }
                                    });
                                  },
                                  child: Text(
                                    'Finish',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              if (day == 60 && goalDay == 60)
                                TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('goal30')
                                        .where('username',
                                            isEqualTo: widget.goal30.username)
                                        .get()
                                        .then((QuerySnapshot querySnapshot) {
                                      print('sud for loop');
                                      for (var i = 1;
                                          i <= widget.goal30.goalLength;
                                          i++) {
                                        final achieve = querySnapshot.docs
                                            .where(
                                                (doc) => doc['day$i'] == true);
                                        if (achieve.isNotEmpty) {
                                          print('Day $i is achieved');
                                          setState(() {
                                            checkDay++;
                                          });
                                        } else {
                                          print('Day $i is not achieved');
                                        }
                                      }
                                    }).then((value) async {
                                      if (checkDay <= 59) {
                                        print('RESILIENT');
                                        final achiever = await FirebaseFirestore
                                            .instance
                                            .collection('achievements')
                                            .where('username',
                                                isEqualTo:
                                                    widget.goal30.username)
                                            .get();

                                        if (achiever.docs.isNotEmpty) {
                                          achiever.docs.first.reference.update({
                                            'resilientgoal60': true,
                                          }).then((value) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Congratulations!'),
                                                  content: const Text(
                                                      'You received the Resilient 60 Badge'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('OK'),
                                                      onPressed: () async {
                                                        Map<String, bool>
                                                            dayUpdates = {};
                                                        for (int i = 0;
                                                            i < 90;
                                                            i++) {
                                                          dayUpdates[
                                                                  'day${i + 1}'] =
                                                              false;
                                                        }

                                                        if (goal30HistoryController
                                                            .historys
                                                            .isNotEmpty) {
                                                          for (var x = 0;
                                                              x <
                                                                  goal30HistoryController
                                                                      .historys
                                                                      .length;
                                                              x++) {
                                                            final goal30History =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'goal30History')
                                                                    .where(
                                                                        'user',
                                                                        isEqualTo: widget
                                                                            .goal30
                                                                            .username)
                                                                    .get();
                                                            if (goal30History
                                                                .docs.isEmpty) {
                                                              print('emptYYYY');
                                                            }

                                                            await goal30History
                                                                .docs
                                                                .first
                                                                .reference
                                                                .delete();
                                                          }
                                                        }

                                                        final goal30Doc =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'goal30')
                                                                .where(
                                                                    'username',
                                                                    isEqualTo: widget
                                                                        .goal30
                                                                        .username)
                                                                .get();

                                                        await goal30Doc.docs
                                                            .first.reference
                                                            .update({
                                                          'isGoal30': false,
                                                          'goal30Category':
                                                              false,
                                                          'goal60Category':
                                                              false,
                                                          'goal90Category':
                                                              false,
                                                          'goalLength': 0,
                                                          'timestamp':
                                                              DateTime.now(),
                                                          ...dayUpdates,
                                                        }).then((value) {
                                                          setState(() {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      HomePage(
                                                                        email: widget
                                                                            .email,
                                                                        homePageIndex:
                                                                            3,
                                                                      )), // Replace NewScreen with the actual class name of the new screen
                                                            );
                                                          });
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          });
                                        }
                                      }
                                      if (checkDay == 60) {
                                        print('RESILIENT');
                                        final achiever = await FirebaseFirestore
                                            .instance
                                            .collection('achievements')
                                            .where('username',
                                                isEqualTo:
                                                    widget.goal30.username)
                                            .get();

                                        if (achiever.docs.isNotEmpty) {
                                          achiever.docs.first.reference.update({
                                            'flawlessGoal60': true,
                                            'legendary': true,
                                          }).then((value) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Congratulations!'),
                                                  content: const Text(
                                                      'You received the Flawless 60 Badge'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('OK'),
                                                      onPressed: () async {
                                                        Map<String, bool>
                                                            dayUpdates = {};
                                                        for (int i = 0;
                                                            i < 90;
                                                            i++) {
                                                          dayUpdates[
                                                                  'day${i + 1}'] =
                                                              false;
                                                        }

                                                        if (goal30HistoryController
                                                            .historys
                                                            .isNotEmpty) {
                                                          for (var x = 0;
                                                              x <
                                                                  goal30HistoryController
                                                                      .historys
                                                                      .length;
                                                              x++) {
                                                            final goal30History =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'goal30History')
                                                                    .where(
                                                                        'user',
                                                                        isEqualTo: widget
                                                                            .goal30
                                                                            .username)
                                                                    .get();
                                                            if (goal30History
                                                                .docs.isEmpty) {
                                                              print('emptYYYY');
                                                            }

                                                            await goal30History
                                                                .docs
                                                                .first
                                                                .reference
                                                                .delete();
                                                          }
                                                        }

                                                        final goal30Doc =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'goal30')
                                                                .where(
                                                                    'username',
                                                                    isEqualTo: widget
                                                                        .goal30
                                                                        .username)
                                                                .get();

                                                        await goal30Doc.docs
                                                            .first.reference
                                                            .update({
                                                          'isGoal30': false,
                                                          'goal30Category':
                                                              false,
                                                          'goal60Category':
                                                              false,
                                                          'goal90Category':
                                                              false,
                                                          'goalLength': 0,
                                                          'timestamp':
                                                              DateTime.now(),
                                                          ...dayUpdates,
                                                        }).then((value) {
                                                          setState(() {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      HomePage(
                                                                        email: widget
                                                                            .email,
                                                                        homePageIndex:
                                                                            3,
                                                                      )), // Replace NewScreen with the actual class name of the new screen
                                                            );
                                                          });
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          });
                                        }
                                      }
                                    });
                                  },
                                  child: Text(
                                    'Finish',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              if (day == 90 && goalDay == 90)
                                TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('goal30')
                                        .where('username',
                                            isEqualTo: widget.goal30.username)
                                        .get()
                                        .then((QuerySnapshot querySnapshot) {
                                      print('sud for loop');
                                      for (var i = 1;
                                          i <= widget.goal30.goalLength;
                                          i++) {
                                        final achieve = querySnapshot.docs
                                            .where(
                                                (doc) => doc['day$i'] == true);
                                        if (achieve.isNotEmpty) {
                                          print('Day $i is achieved');
                                          setState(() {
                                            checkDay++;
                                          });
                                        } else {
                                          print('Day $i is not achieved');
                                        }
                                      }
                                    }).then((value) async {
                                      if (checkDay <= 89) {
                                        print('RESILIENT');
                                        final achiever = await FirebaseFirestore
                                            .instance
                                            .collection('achievements')
                                            .where('username',
                                                isEqualTo:
                                                    widget.goal30.username)
                                            .get();

                                        if (achiever.docs.isNotEmpty) {
                                          achiever.docs.first.reference.update({
                                            'resilientgoal90': true,
                                          }).then((value) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Congratulations!'),
                                                  content: const Text(
                                                      'You received the Resilient 90 Badge'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('OK'),
                                                      onPressed: () async {
                                                        Map<String, bool>
                                                            dayUpdates = {};
                                                        for (int i = 0;
                                                            i < 90;
                                                            i++) {
                                                          dayUpdates[
                                                                  'day${i + 1}'] =
                                                              false;
                                                        }

                                                        if (goal30HistoryController
                                                            .historys
                                                            .isNotEmpty) {
                                                          for (var x = 0;
                                                              x <
                                                                  goal30HistoryController
                                                                      .historys
                                                                      .length;
                                                              x++) {
                                                            final goal30History =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'goal30History')
                                                                    .where(
                                                                        'user',
                                                                        isEqualTo: widget
                                                                            .goal30
                                                                            .username)
                                                                    .get();
                                                            if (goal30History
                                                                .docs.isEmpty) {
                                                              print('emptYYYY');
                                                            }

                                                            await goal30History
                                                                .docs
                                                                .first
                                                                .reference
                                                                .delete();
                                                          }
                                                        }

                                                        final goal30Doc =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'goal30')
                                                                .where(
                                                                    'username',
                                                                    isEqualTo: widget
                                                                        .goal30
                                                                        .username)
                                                                .get();

                                                        await goal30Doc.docs
                                                            .first.reference
                                                            .update({
                                                          'isGoal30': false,
                                                          'goal30Category':
                                                              false,
                                                          'goal60Category':
                                                              false,
                                                          'goal90Category':
                                                              false,
                                                          'goalLength': 0,
                                                          'timestamp':
                                                              DateTime.now(),
                                                          ...dayUpdates,
                                                        }).then((value) {
                                                          setState(() {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      HomePage(
                                                                        email: widget
                                                                            .email,
                                                                        homePageIndex:
                                                                            3,
                                                                      )), // Replace NewScreen with the actual class name of the new screen
                                                            );
                                                          });
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          });
                                        }
                                      }
                                      if (checkDay == 90) {
                                        print('RESILIENT');
                                        final achiever = await FirebaseFirestore
                                            .instance
                                            .collection('achievements')
                                            .where('username',
                                                isEqualTo:
                                                    widget.goal30.username)
                                            .get();

                                        if (achiever.docs.isNotEmpty) {
                                          achiever.docs.first.reference.update({
                                            'flawlessGoal90': true,
                                            'legendary': true,
                                          }).then((value) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Congratulations!'),
                                                  content: const Text(
                                                      'You received the Flawless 90 Badge'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('OK'),
                                                      onPressed: () async {
                                                        Map<String, bool>
                                                            dayUpdates = {};
                                                        for (int i = 0;
                                                            i < 90;
                                                            i++) {
                                                          dayUpdates[
                                                                  'day${i + 1}'] =
                                                              false;
                                                        }

                                                        if (goal30HistoryController
                                                            .historys
                                                            .isNotEmpty) {
                                                          for (var x = 0;
                                                              x <
                                                                  goal30HistoryController
                                                                      .historys
                                                                      .length;
                                                              x++) {
                                                            final goal30History =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'goal30History')
                                                                    .where(
                                                                        'user',
                                                                        isEqualTo: widget
                                                                            .goal30
                                                                            .username)
                                                                    .get();
                                                            if (goal30History
                                                                .docs.isEmpty) {
                                                              print('emptYYYY');
                                                            }

                                                            await goal30History
                                                                .docs
                                                                .first
                                                                .reference
                                                                .delete();
                                                          }
                                                        }

                                                        final goal30Doc =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'goal30')
                                                                .where(
                                                                    'username',
                                                                    isEqualTo: widget
                                                                        .goal30
                                                                        .username)
                                                                .get();

                                                        await goal30Doc.docs
                                                            .first.reference
                                                            .update({
                                                          'isGoal30': false,
                                                          'goal30Category':
                                                              false,
                                                          'goal60Category':
                                                              false,
                                                          'goal90Category':
                                                              false,
                                                          'goalLength': 0,
                                                          'timestamp':
                                                              DateTime.now(),
                                                          ...dayUpdates,
                                                        }).then((value) {
                                                          setState(() {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      HomePage(
                                                                        email: widget
                                                                            .email,
                                                                        homePageIndex:
                                                                            3,
                                                                      )), // Replace NewScreen with the actual class name of the new screen
                                                            );
                                                          });
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          });
                                        }
                                      }
                                    });
                                  },
                                  child: Text(
                                    'Finish',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Today's Goal:",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          for (var i = 0; i < widget.goal30.goalLength; i++)
                            if (widget.goal30.goal30Category == true &&
                                widget.goal30.goalLength == 30)
                              if (goal30[i].day == day)
                                Text(
                                  goal30[i].kmGoal.toString() == '0.0'
                                      ? 'REST DAY'
                                      : goal30[i].kmGoal.toString() + ' km',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                          for (var i = 0; i < widget.goal30.goalLength; i++)
                            if (widget.goal30.goal60Category == true &&
                                widget.goal30.goalLength == 60)
                              if (goal60[i].day == day)
                                Text(
                                  goal60[i].kmGoal.toString() == '0.0'
                                      ? 'REST DAY'
                                      : goal60[i].kmGoal.toString() + ' km',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                          for (var i = 0; i < widget.goal30.goalLength; i++)
                            if (widget.goal30.goal90Category == true &&
                                widget.goal30.goalLength == 90)
                              if (goal90[i].day == day)
                                Text(
                                  goal90[i].kmGoal.toString() == '0.0'
                                      ? 'REST DAY'
                                      : goal90[i].kmGoal.toString() + ' km',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                          SizedBox(height: 10),
                          Text(
                            "Today's Bmi:",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          // if (goal30HistoryController.goal30History!.day ==
                          //     day.toString())
                          //   Text(
                          //     goal30HistoryController.goal30History!.result,
                          //     style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 40,
                          //         fontWeight: FontWeight.bold),
                          //   ),
                          // if (goal30HistoryController.goal30History!.day ==
                          //     day.toString())
                          //   Text(
                          //     goal30HistoryController.goal30History!.bmiCategory,
                          //     style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 20,
                          //         fontWeight: FontWeight.bold),
                          //   ),
                          Text(
                            result == null ? '' : '$result',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            bmicategory == null ? '' : '$bmicategory',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _heightController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 5,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x3fffFFFFF0),
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x3fffFFFFF0),
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.height,
                                      color: Colors.white,
                                    ),
                                    prefixIconColor: Colors.white,
                                    suffix: Text(
                                      'cm',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    labelText: 'Height',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _weightController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 5,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x3fffFFFFF0),
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x3fffFFFFF0),
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.scale_sharp,
                                      color: Colors.white,
                                    ),
                                    prefixIconColor: Colors.white,
                                    suffix: Text(
                                      'kg',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    labelText: 'Weight',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size.fromHeight(60),
                                maximumSize: const Size.fromWidth(350),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide.none,
                                ),
                                backgroundColor: currentDay.contains(counter) &&
                                        goalDay == counter
                                    ? Colors.grey[900]
                                    : goalDay == counter
                                        ? Colors.red[900]
                                        : Colors.grey[900],
                              ),
                              onPressed: goalDay == counter
                                  ? _calculateBMI
                                  : () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('It is not your day yet.'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                              child: Text(
                                'Calculate',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size.fromHeight(60),
                                maximumSize: const Size.fromWidth(350),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide.none,
                                ),
                                backgroundColor: currentDay.contains(counter) &&
                                        goalDay == counter
                                    ? Colors.grey[900]
                                    : goalDay == counter
                                        ? Colors.red[900]
                                        : Colors.grey[900],
                              ),
                              onPressed: goalDay == counter
                                  ? _proceed
                                  : () {
                                      SnackBar(
                                        content:
                                            Text('It is not your day yet.'),
                                        duration: Duration(seconds: 2),
                                      );
                                    },
                              child: Text(
                                'Proceed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
      ],
    );
  }
}
