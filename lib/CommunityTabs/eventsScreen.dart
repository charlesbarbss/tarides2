import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarides/BottomNav/NewRides/raceLobby.dart';
import 'package:tarides/Controller/ridesController.dart';
import 'package:tarides/Model/ridesModel.dart';
import 'package:tarides/Model/userModel.dart';
import 'package:tarides/widgets/text_widget.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({
    super.key,
    required this.user,
    required this.ride,
  });
  final Users user;
  final Rides ride;

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  RidesController ridesController = RidesController();

  @override
  void initState() {
    ridesController.getEnemyRides(widget.user.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime dateTime) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final aDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      final difference = today.difference(aDate).inDays;

      if (difference == 0) {
        return 'Today ${DateFormat('h:mm a | d MMMM yyyy').format(dateTime)}';
      } else if (difference == 1) {
        return 'Yesterday ${DateFormat('h:mm a | d MMMM yyyy').format(dateTime)}';
      } else {
        return '$difference DAYS AGO ${DateFormat('h:mm a | d MMMM yyyy').format(dateTime)}';
      }
    }

    return AnimatedBuilder(
      animation: ridesController,
      builder: (context, snapshot) {
        if (ridesController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            title: TextWidget(
              text: 'Events',
              fontSize: 24,
              fontFamily: 'Bold',
              color: Colors.white,
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                width: double.infinity, // Set the width to double.infinity
                height: 410,

                child: Column(
                  children: [
                    Container(
                      width:
                          double.infinity, // Set the width to double.infinity

                      decoration: BoxDecoration(
                        color: Colors.black, // Set the color
                        borderRadius:
                            BorderRadius.circular(20), // Set the border radius
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                            child: TextWidget(
                              text: widget.ride.hostCommunityName,
                              // Challenge Message
                              fontSize: 20,
                              fontFamily: 'Bold',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                            child: Center(
                              child: Divider(
                                indent: 15,
                                endIndent: 15,
                                thickness: 2,
                                color: Color.fromARGB(255, 69, 69, 69),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: RichText(
                              text: TextSpan(
                                text:
                                    '${widget.ride.hostCommunityName} ', // Team Name
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 232, 170, 10),
                                  fontFamily: 'Bold',
                                ),
                                children: const <TextSpan>[
                                  TextSpan(
                                    text: 'wants to challenge you to a race.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Regular',
                                      color: Color.fromARGB(255, 152, 152, 152),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: RichText(
                              text: TextSpan(
                                text: 'Race Date: ', // Team Name
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 232, 170, 10),
                                  fontFamily: 'Bold',
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: DateFormat('MMMM dd, yyyy')
                                        .format(DateTime.parse(
                                      widget.ride.raceDate,
                                    )), // Display Race Date
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Regular',
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: RichText(
                              text: TextSpan(
                                text: 'Race Time: ', // Race Time
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 232, 170, 10),
                                  fontFamily: 'Bold',
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: DateFormat('h:mm a').format(
                                      DateTime.parse(
                                        widget.ride.raceTime
                                            .toDate()
                                            .toString(),
                                      ),
                                    ), // Display Race Time
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Regular',
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: RichText(
                              text: TextSpan(
                                text: 'Meetup Location: ', // Meetup Location
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 232, 170, 10),
                                  fontFamily: 'Bold',
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: widget.ride
                                        .hostCommunityName, // Display Meetup Location
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Regular',
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                            child: Center(
                              child: Divider(
                                indent: 15,
                                endIndent: 15,
                                thickness: 2,
                                color: Color.fromARGB(255, 69, 69, 69),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: TextWidget(
                              text: formatDate(DateTime
                                  .now()), // Display Date and Time today
                              fontSize: 14,
                              fontFamily: 'Regular',
                              color: const Color.fromARGB(255, 152, 152, 152),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: TextButton(
                                onPressed: () async {
                                  final communityDoc = await FirebaseFirestore
                                      .instance
                                      .collection('rides')
                                      .where(
                                        'enemyUsername',
                                        isEqualTo: widget.ride.enemyUsername,
                                      )
                                      // .where(
                                      //   'id',
                                      //   isEqualTo: widget.ride.id,
                                      // )
                                      .get();
                                  if (communityDoc.docs.isEmpty) {
                                    print('way sud');
                                  }
                                  await communityDoc.docs.first.reference
                                      .update({
                                    'isAllReady': true,
                                  }).then((value) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RaceLobbyScreen(
                                          ride: widget.ride,
                                        ),
                                      ),
                                    );
                                  });
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 0, 0),
                                ),
                                child: TextWidget(
                                  text: 'Join',
                                  fontSize: 20,
                                  fontFamily: 'Bold',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
