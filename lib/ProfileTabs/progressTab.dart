import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
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
      child: SingleChildScrollView(
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
              height: 305,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                            .collection('Pedals')
                            .where('userId',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
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
                            totalDistance += double.parse(data.docs[i]
                                    ['distance']
                                .toString()
                                .replaceAll('KM', ''));
                          }

                          for (int i = 0; i < data.docs.length; i++) {
                            totalTime += double.parse(data.docs[i]['time']
                                .toString()
                                .replaceAll('hrs', ''));
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'Bold',
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0), // Adjust the value as needed
                                child: Column(
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
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily: 'Bold',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Pedals')
                            .where('userId',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
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
                                                data.docs[i]['dateTime']
                                                    .toDate(),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ExpansionTile(
                backgroundColor: Colors.white,
                title: const SizedBox(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: TextWidget(
                  text: 'PEDAL',
                  fontSize: 18,
                  fontFamily: 'Bold',
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right_rounded,
                ),
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Pedals')
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
                          color: Colors.black,
                          height: 300,
                          width: 500,
                          child: ListView.builder(
                            itemCount: data.docs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Container(
                                  width: double.infinity,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: Colors.brown[100]!.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 300,
                                              width: 125,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextWidget(
                                                    text: DateFormat.yMMMd()
                                                        .add_jm()
                                                        .format(data.docs[index]
                                                                ['dateTime']
                                                            .toDate()),
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontFamily: 'Bold',
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: 225,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: GoogleMap(
                                                        zoomControlsEnabled:
                                                            false,
                                                        markers: {
                                                          Marker(
                                                              position: LatLng(
                                                                  data.docs[
                                                                          index]
                                                                      [
                                                                      'startLat'],
                                                                  data.docs[
                                                                          index]
                                                                      [
                                                                      'startLong']),
                                                              markerId:
                                                                  const MarkerId(
                                                                      '1')),
                                                          Marker(
                                                              position: LatLng(
                                                                  data.docs[
                                                                          index]
                                                                      [
                                                                      'endLat'],
                                                                  data.docs[
                                                                          index]
                                                                      [
                                                                      'endLong']),
                                                              markerId:
                                                                  const MarkerId(
                                                                      '2')),
                                                        },
                                                        polylines: {
                                                          Polyline(
                                                              color: Colors.red,
                                                              width: 1,
                                                              points: [
                                                                LatLng(
                                                                    data.docs[
                                                                            index]
                                                                        [
                                                                        'startLat'],
                                                                    data.docs[
                                                                            index]
                                                                        [
                                                                        'startLong']),
                                                                LatLng(
                                                                    data.docs[
                                                                            index]
                                                                        [
                                                                        'endLat'],
                                                                    data.docs[
                                                                            index]
                                                                        [
                                                                        'endLong']),
                                                              ],
                                                              polylineId:
                                                                  const PolylineId(
                                                                      '1')),
                                                        },
                                                        initialCameraPosition:
                                                            CameraPosition(
                                                                zoom: 14,
                                                                target: LatLng(
                                                                    data.docs[
                                                                            index]
                                                                        [
                                                                        'startLat'],
                                                                    data.docs[
                                                                            index]
                                                                        [
                                                                        'startLong']))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              height: 300,
                                              width: 180,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextWidget(
                                                            text: 'TIME',
                                                            fontSize: 10,
                                                            color: Colors.amber,
                                                          ),
                                                          TextWidget(
                                                            text:
                                                                data.docs[index]
                                                                    ['time'],
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontFamily: 'Bold',
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          TextWidget(
                                                            text: 'START TIME',
                                                            fontSize: 10,
                                                            color: Colors.amber,
                                                          ),
                                                          TextWidget(
                                                            text: DateFormat()
                                                                .add_jm()
                                                                .format(data
                                                                    .docs[index]
                                                                        [
                                                                        'dateTime']
                                                                    .toDate()),
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontFamily: 'Bold',
                                                          ),
                                                          const SizedBox(
                                                            height: 100,
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextWidget(
                                                            text:
                                                                'TOTAL DISTANCE',
                                                            fontSize: 10,
                                                            color: Colors.amber,
                                                          ),
                                                          TextWidget(
                                                            text: data
                                                                    .docs[index]
                                                                ['distance'],
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontFamily: 'Bold',
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          TextWidget(
                                                            text:
                                                                'DISTANCE TRAVEL',
                                                            fontSize: 10,
                                                            color: Colors.amber,
                                                          ),
                                                          TextWidget(
                                                            text: data
                                                                    .docs[index]
                                                                ['distance'],
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontFamily: 'Bold',
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          const SizedBox(
                                                            height: 100,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}
