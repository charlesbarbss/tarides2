import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarides/widgets/text_widget.dart';

class RaceLogs extends StatefulWidget {
  const RaceLogs({super.key});

  @override
  State<RaceLogs> createState() => _RaceLogsState();
}

class _RaceLogsState extends State<RaceLogs> {
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
        children: [
          TextWidget(
            text: 'Race History',
            fontSize: 14,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Pedals')
                .where('dateTime', isNotEqualTo: null)
                .orderBy('dateTime', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextWidget(
                                          text: DateFormat.yMMMd().format(data
                                              .docs[index]['dateTime']
                                              .toDate()),
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: TextWidget(
                                              text: data.docs[index]
                                                  ['distance'],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        text: DateFormat().add_jm().format(data
                                            .docs[index]['dateTime']
                                            .toDate()),
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
                                        text: DateFormat().add_jm().format(data
                                            .docs[index]['dateTime']
                                            .toDate()),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        text: DateFormat().add_jm().format(data
                                            .docs[index]['dateTime']
                                            .toDate()),
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
                  });
            },
          ),
        ],
      ),
    );
  }
}
