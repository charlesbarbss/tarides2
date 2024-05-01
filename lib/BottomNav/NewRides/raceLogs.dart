import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarides/Controller/ridesHistoryController.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/widgets/text_widget.dart';

class RaceLogs extends StatefulWidget {
  const RaceLogs({super.key, required this.email, required this.username});
  final String email;
  final String username;

  @override
  State<RaceLogs> createState() => _RaceLogsState();
}

class _RaceLogsState extends State<RaceLogs> {
  RidesHistoryController ridesHistoryController = RidesHistoryController();
  @override
  void initState() {
    ridesHistoryController.getRidesHistory(widget.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //   statusBarColor: Colors.white,
        //   statusBarIconBrightness: Brightness.light,
        // ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Race Log',
          fontSize: 24,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: AnimatedBuilder(
            animation: ridesHistoryController,
            builder: (context, snapshot) {
              if (ridesHistoryController.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (ridesHistoryController.historys.isEmpty) {
                return Center(
                  child: Text(
                    'You dont have a History yet',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return Column(
                children: [
                  for (var i = 0;
                      i < ridesHistoryController.historys.length;
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
                                  'Date Completed: ${DateFormat('yyyy-MM-dd').format(ridesHistoryController.historys[i]!.dateDone.toDate())}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              'WINNER',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              ridesHistoryController.historys[i]!.winner,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              'LOSER',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              ridesHistoryController.historys[i]!.loser,
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
