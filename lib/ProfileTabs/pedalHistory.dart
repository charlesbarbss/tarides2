import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarides/widgets/text_widget.dart';

class PedalHistory extends StatefulWidget {
  const PedalHistory({super.key});

  @override
  State<PedalHistory> createState() => _PedalHistoryState();
}

class _PedalHistoryState extends State<PedalHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextWidget(
          text: 'Pedal History',
          fontSize: 20,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Pedals')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            // .orderBy('dateTime', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(
              child: Text(
                'Error',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.red,
              )),
            );
          }

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  top: 10,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 40, 40, 40),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 200,
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    text: DateFormat.yMMMd().format(
                                        data.docs[index]['dateTime'].toDate()),
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontFamily: 'Bold',
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 150,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: TextWidget(
                                        text: data.docs[index]['distance'],
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontFamily: 'Bold',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: 'TIME',
                                  fontSize: 12,
                                  color: Colors.amber,
                                ),
                                TextWidget(
                                  text: data.docs[index]['time'],
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'Bold',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'AVG SPEED',
                                  fontSize: 12,
                                  color: Colors.amber,
                                ),
                                TextWidget(
                                  text: DateFormat().add_jm().format(
                                      data.docs[index]['dateTime'].toDate()),
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'Bold',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'START TIME',
                                  fontSize: 12,
                                  color: Colors.amber,
                                ),
                                TextWidget(
                                  text: DateFormat().add_jm().format(
                                      data.docs[index]['dateTime'].toDate()),
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'Bold',
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: 'TOTAL DISTANCE',
                                  fontSize: 12,
                                  color: Colors.amber,
                                ),
                                TextWidget(
                                  text: data.docs[index]['distance'],
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'Bold',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'DISTANCE TRAVEL',
                                  fontSize: 12,
                                  color: Colors.amber,
                                ),
                                TextWidget(
                                  text: data.docs[index]['distance'],
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'Bold',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'END TIME',
                                  fontSize: 12,
                                  color: Colors.amber,
                                ),
                                TextWidget(
                                  text: DateFormat().add_jm().format(
                                      data.docs[index]['dateTime'].toDate()),
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'Bold',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
