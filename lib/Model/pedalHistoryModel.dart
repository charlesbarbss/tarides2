import 'package:cloud_firestore/cloud_firestore.dart';

class PedalHistory {
  PedalHistory({
    required this.time,
    required this.averageSpeed,
    required this.totalDistance,
    required this.id,
    required this.imageGoal,
    required this.username,
    required this.dateDone,
  });

  final String time;
  final String averageSpeed;
  final String totalDistance;
  final String id;
  final String imageGoal;
  final String username;
  final Timestamp dateDone;

  factory PedalHistory.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() as Map<String, dynamic>;

    return PedalHistory(
      time: data['time'] as String,
      averageSpeed: data['averageSpeed'] as String,
      totalDistance: data['totalDistance'] as String,
      id: data['id'] as String,
      imageGoal: data['imageGoal'] as String,
      username: data['username'] as String,
      dateDone: data['dateDone'] as Timestamp,
    );
  }
}
