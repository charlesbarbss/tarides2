import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addRide(
  double startLat,
  double startLong,
  String start,
  double endLat1,
  double endLong1,
  String end1,
  double endLat2,
  double endLong2,
  String end2,
  double endLat3,
  double endLong3,
  String end3,
  String distance,
  String time,
  String team1,
  String team2,
) async {
  final docUser = FirebaseFirestore.instance.collection('Rides').doc();

  final json = {
    'loc1lat': startLat,
    'loc1long': startLong,
    'loc1': start,
    'loc2lat': endLat1,
    'loc2long': endLong1,
    'loc2': end1,
    'loc3lat': endLat2,
    'loc3long': endLong2,
    'loc3': end2,
    'loc4lat': endLat3,
    'loc4long': endLong3,
    'loc4': end3,
    'dateTime': DateTime.now(),
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'distance': distance,
    'time': time,
    'status': 'Not Started',
    'winner': '',
    'team1': team1,
    'team2': team2,
  };

  await docUser.set(json);
}
