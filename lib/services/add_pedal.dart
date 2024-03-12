import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addPedal(
  double startLat,
  double startLong,
  String start,
  double endLat,
  double endLong,
  String end,
  String distance,
  String time,
) async {
  final docUser = FirebaseFirestore.instance.collection('Pedals').doc();

  final json = {
    'startLat': startLat,
    'startLong': startLong,
    'start': start,
    'endLat': endLat,
    'endLong': endLong,
    'end': end,
    'dateTime': DateTime.now(),
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'distance': distance,
    'time': time,
    'status': 'Not Started'
  };

  await docUser.set(json);
}
