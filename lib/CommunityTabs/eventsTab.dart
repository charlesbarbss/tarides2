import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarides/CommunityTabs/eventsScreen.dart';
import 'package:tarides/Controller/ridesController.dart';
import 'package:tarides/Model/userModel.dart';
import 'package:tarides/widgets/text_widget.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({
    super.key,
    required this.user,
    required this.email,
  });
  final Users user;
  final String email;

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
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
          body: Column(
            children: [
              for (var i = 0; i < ridesController.enemyRides.length; i++)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventsScreen(
                          email: widget.email,
                          user: widget.user,
                          ride: ridesController.enemyRides[i],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 30),
                    child: Container(
                      width:
                          double.infinity, // Set the width to double.infinity
                      // height: 340,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            255, 40, 40, 40), // Set the color
                        borderRadius:
                            BorderRadius.circular(20), // Set the border radius
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                            child: TextWidget(
                              text: ridesController.enemyRides[i]
                                  .challengeMessage, // Challenge Message
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
                                    '${ridesController.enemyRides[i].hostCommunityName} ', // Team Name
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
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 232, 170, 10),
                                  fontFamily: 'Bold',
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: DateFormat('MMMM dd, yyyy').format(
                                        DateTime.parse(ridesController
                                            .enemyRides[i].raceDate)),
                                    style: const TextStyle(
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
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 232, 170, 10),
                                  fontFamily: 'Bold',
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: DateFormat('h:mm a').format(
                                        DateTime.parse(ridesController
                                            .enemyRides[i].raceTime
                                            .toDate()
                                            .toString())),
                                    style: const TextStyle(
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
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 232, 170, 10),
                                  fontFamily: 'Bold',
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ridesController
                                        .enemyRides[i].meetupLocation,
                                    style: const TextStyle(
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
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                            child: TextWidget(
                              text: formatDate(DateTime.now()),
                              fontSize: 14,
                              fontFamily: 'Regular',
                              color: const Color.fromARGB(255, 152, 152, 152),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
