import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tarides/Model/createCommunityModel.dart';
import 'package:tarides/Model/userModel.dart';
import 'package:tarides/homePage.dart';
import 'package:tarides/widgets/text_widget.dart';

class RequestChallenge extends StatefulWidget {
  const RequestChallenge(
      {super.key,
      required this.user,
      required this.email,
      required this.userPicked});
  final Users user;
  final String email;
  final Users userPicked;

  @override
  State<RequestChallenge> createState() => _RequestChallengeState();
}

class _RequestChallengeState extends State<RequestChallenge> {
  final meetupLocationController = TextEditingController();
  final challengeMessageController = TextEditingController();
  Community? community;
  Community? hostCommunity;
  DateTime? selectedDate;
  DateTime? selectedDateTime;

  TimeOfDay? selectedTime;
  int? selectedTimestamp; // Define selectedTimestamp
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextWidget(
          text: 'Request Challenge',
          fontSize: 24,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
            child: TextWidget(
              text:
                  'Ready to set the wheels in motion? Fill in the details below to secure your challenge request',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: 'Race Date / Time',
                  fontSize: 20,
                  fontFamily: 'Bold',
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 232, 155, 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 1),
                          );
                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                            });
                            print('Selected date: $date');
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: Colors.black,
                            ),
                            Text(
                              selectedDate != null
                                  ? ' ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                  : ' Select a date',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 232, 155, 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              selectedTime = time;
                              selectedDateTime = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                selectedTime!.hour,
                                selectedTime!.minute,
                              );
                            });
                            print('Selected time: $time');
                            print('Selected DateTime: $selectedDateTime');
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 20,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              selectedTime != null
                                  ? ' ${selectedTime!.hour}:${selectedTime!.minute}'
                                  : 'Select Time',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: 'Meetup Location',
                      fontSize: 20,
                      fontFamily: 'Bold',
                      color: Colors.white,
                    ),
                    TextFormField(
                      controller: meetupLocationController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 255, 240),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 69, 69, 69),
                        ),
                        hintText: 'Specify a meetup spot',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                TextWidget(
                  text: 'Challenge Message',
                  fontSize: 20,
                  fontFamily: 'Bold',
                  color: Colors.white,
                ),
                TextFormField(
                  controller: challengeMessageController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 255, 240),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 69, 69, 69),
                    ),
                    hintText: 'Think you can keep up?',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: SizedBox(
          width: double.infinity, // Set the width
          height: 60, // Set the height
          child: FloatingActionButton.extended(
            onPressed: () async {
              final QuerySnapshot<Map<String, dynamic>> querySnapshot =
                  await FirebaseFirestore.instance
                      .collection('community')
                      .where('communityId',
                          isEqualTo: widget.userPicked.communityId)
                      .get();

              if (querySnapshot.docs.isEmpty) {
                print('No community found with the given communityId');
                return;
              }

              final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
                  querySnapshot.docs.first;
              community = Community.fromDocument(documentSnapshot);

              final QuerySnapshot<Map<String, dynamic>> hostquerySnapshot =
                  await FirebaseFirestore.instance
                      .collection('community')
                      .where('communityId', isEqualTo: widget.user.communityId)
                      .get();

              if (hostquerySnapshot.docs.isEmpty) {
                print('No community communityId');
                return;
              }

              final DocumentSnapshot<Map<String, dynamic>>
                  hostdocumentSnapshot = hostquerySnapshot.docs.first;
              hostCommunity = Community.fromDocument(hostdocumentSnapshot);

              final idRides =
                  FirebaseFirestore.instance.collection('rides').doc().id;
              print('1');
              print(community!.communityName);

              if (community == null) {
                return;
              } else {
                await FirebaseFirestore.instance.collection('rides').add({
                  'id': idRides,
                  'idRides': idRides,
                  'hostUsername': widget.user.username,
                  'hostFirstName': widget.user.firstName,
                  'hostLastName': widget.user.lastName,
                  'hostEmail': widget.user.email,
                  'hostImage': widget.user.imageUrl,
                  'hostCommunityName': hostCommunity!.communityName,
                  'hostLat': 0.0,
                  'hostLng': 0.0,
                  'startPointLat': 0.0,
                  'startPointLng': 0.0,
                  'midPointLat': 0.0,
                  'midPointLng': 0.0,
                  'endPointLat': 0.0,
                  'endPointLng': 0.0,
                  'enemyUsername': widget.userPicked.username,
                  'enemyEmail': widget.userPicked.email,
                  'enemyImage': widget.userPicked.imageUrl,
                  'enemyLat': 0.0,
                  'enemyLng': 0.0,
                  'selected': false,
                  'enemyCommunityId': widget.userPicked.communityId,
                  'enemyFirstName': widget.userPicked.firstName,
                  'enemyLastName': widget.userPicked.lastName,
                  'enemyCommunityName': community!.communityName,
                  'raceDate': selectedDate.toString(),
                  'raceTime': selectedDateTime,
                  'meetupLocation': meetupLocationController.text,
                  'challengeMessage': challengeMessageController.text,
                  'timeRequest': Timestamp.now(),
                  'isAllReady': false,
                  'startText': '',
                  'midText': '',
                  'endText': '',
                  'isPickingRoute': false,
                }).then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              homePageIndex: 1,
                              email: widget.email,
                            )),
                  );
                });
              }
            },
            label: Row(
              mainAxisSize:
                  MainAxisSize.min, // Ensure the Row takes minimum space
              children: [
                TextWidget(
                  text: 'Send Challenge',
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: 'Bold',
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.directions_bike_rounded,
                  size: 30,
                  color: Colors.black,
                ),
              ],
            ),
            backgroundColor: const Color.fromARGB(255, 232, 155, 5),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
