import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarides/Controller/goal30HistoryController.dart';
import 'package:tarides/Model/goal30Model.dart';
import 'package:tarides/Model/userModel.dart';

class Goal30History extends StatefulWidget {
  const Goal30History({super.key, required this.email, required this.goal30});
  final String email;
  final Goal30 goal30;

  @override
  State<Goal30History> createState() => _Goal30HistoryState();
}

class _Goal30HistoryState extends State<Goal30History> {
  Goal30HistoryController goal30HistoryController = Goal30HistoryController();
  late Users user;
  @override
  void initState() {
    goal30HistoryController.getGoal30History(user.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Challenge Log',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: AnimatedBuilder(
            animation: goal30HistoryController,
            builder: (context, snapshot) {
              if (goal30HistoryController.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (goal30HistoryController.historys.isEmpty) {
                return Center(
                  child: Text(
                    'You dont have a History yet',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              // print(goal30HistoryController.goal30History);
              return Column(
                children: [
                  for (var i = 0;
                      i < goal30HistoryController.historys.length;
                      i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(15)),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Day: ${goal30HistoryController.historys[i]!.day}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  'Date Completed: ${DateFormat('yyyy-MM-dd').format(goal30HistoryController.historys[i]!.dateDone.toDate())}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Image.network(
                                          goal30HistoryController
                                              .historys[i]!.imageGoal
                                              .toString()),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Close'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Center(
                                child: Container(
                                  height: 150,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3.5,
                                    ),
                                  ),
                                  child: Image.network(
                                    goal30HistoryController
                                        .historys[i]!.imageGoal
                                        .toString(),
                                    height: 130,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'BMI: ${goal30HistoryController.historys[i]!.result}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              'Category: ${goal30HistoryController.historys[i]!.bmiCategory}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              'Time: ${goal30HistoryController.historys[i]!.time}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              'Average Speed: ${goal30HistoryController.historys[i]!.averageSpeed}km/h',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              'Distance Traveled: ${goal30HistoryController.historys[i]!.totalDistance}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              'Duration: ${goal30HistoryController.historys[i]!.time}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }),
      ),
    );
  }
}
