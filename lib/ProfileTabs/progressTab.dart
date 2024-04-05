import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tarides/widgets/text_widget.dart';

class ProgressTab extends StatefulWidget {
  const ProgressTab({super.key});

  @override
  State<ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Statistics',
            fontSize: 14,
            color: Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'This Week',
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Bold',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Rides')
                          .where('status', isEqualTo: 'Finished')
                          .where('userId',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return const Center(child: Text('Error'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.black,
                            )),
                          );
                        }

                        double totalDistance = 0;
                        double totalTime = 0;

                        final data = snapshot.requireData;

                        for (int i = 0; i < data.docs.length; i++) {
                          totalDistance += double.parse(data.docs[i]['distance']
                              .toString()
                              .replaceAll('KM', ''));
                        }

                        for (int i = 0; i < data.docs.length; i++) {
                          totalTime += double.parse(data.docs[i]['time']
                              .toString()
                              .replaceAll('hrs', ''));
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'Distance',
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextWidget(
                                  text:
                                      '${totalDistance.toStringAsFixed(2)} km',
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontFamily: 'Bold',
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'Time',
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextWidget(
                                  text: '${totalTime.toStringAsFixed(2)} h',
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontFamily: 'Bold',
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'Elevation Gain',
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextWidget(
                                  text: '0 m',
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontFamily: 'Bold',
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Rides')
                          .where('status', isEqualTo: 'Finished')
                          .where('userId',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return const Center(child: Text('Error'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.black,
                            )),
                          );
                        }

                        final data = snapshot.requireData;
                        return Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SfCartesianChart(
                                primaryXAxis: DateTimeAxis(
                                  minimum: DateTime(2024),
                                ),
                                series: <CartesianSeries>[
                                  // Renders line chart
                                  LineSeries<SalesData, DateTime>(
                                      dataSource: [
                                        for (int i = 0;
                                            i < data.docs.length;
                                            i++)
                                          SalesData(
                                              data.docs[i]['dateTime'].toDate(),
                                              double.parse(data.docs[i]
                                                      ['distance']
                                                  .toString()
                                                  .replaceAll('KM', '')))
                                      ],
                                      xValueMapper: (SalesData sales, _) =>
                                          sales.year,
                                      yValueMapper: (SalesData sales, _) =>
                                          sales.sales)
                                ]));
                      }),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            tileColor: Colors.white,
            leading: TextWidget(
              text: 'GOAL30',
              fontSize: 18,
              fontFamily: 'Bold',
            ),
            trailing: const Icon(
              Icons.keyboard_arrow_right_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}
