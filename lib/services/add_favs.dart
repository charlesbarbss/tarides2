import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addFav(
  double startLat,
  double startLong,
  String start,
  double endLat,
  double endLong,
  String end,
  String type,
  double endLat1,
  double endLong1,
  String end1,
  double endLat2,
  double endLong2,
  String end2,
) async {
  final docUser = FirebaseFirestore.instance.collection('Favs').doc();

  final json = {
    'startLat': startLat,
    'startLong': startLong,
    'start': start,
    'endLat': endLat,
    'endLong': endLong,
    'end': end,
    'endLat1': endLat1,
    'endLong1': endLong1,
    'end1': end1,
    'endLat2': endLat2,
    'endLong2': endLong2,
    'end2': end2,
    'dateTime': DateTime.now(),
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'type': type,
  };

  await docUser.set(json);
}
