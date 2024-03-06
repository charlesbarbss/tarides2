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
) async {
  final docUser = FirebaseFirestore.instance.collection('Favs').doc();

  final json = {
    'startLat': startLat,
    'startLong': startLong,
    'start': start,
    'endLat': endLat,
    'endLong': endLong,
    'end': end,
    'dateTime': DateTime.now(),
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'type': type,
  };

  await docUser.set(json);
}
