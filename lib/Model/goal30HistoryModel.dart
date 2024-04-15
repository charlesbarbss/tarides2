import 'package:cloud_firestore/cloud_firestore.dart';

class Goal30History {
  Goal30History({
    required this.height,
    required this.width,
    required this.result,
    required this.bmiCategory,
    required this.time,
    required this.averageSpeed,
    required this.totalDistance,
    required this.day,
    required this.id,
    required this.imageGoal,
    required this.user,
    required this.dateDone,
  });

  final String height;
  final String width;
  final String result;
  final String bmiCategory;
  final String time;
  final String averageSpeed;
  final String totalDistance;
  final String day;
  final String id;
  final String imageGoal;
  final String user;
  final Timestamp dateDone;

  factory Goal30History.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() as Map<String, dynamic>;

    return Goal30History(
      height: data['height'] as String,
      width: data['width'] as String,
      result: data['result'] as String,
      bmiCategory: data['bmiCategory'] as String,
      time: data['time'] as String,
      averageSpeed: data['averageSpeed'] as String,
      totalDistance: data['totalDistance'] as String,
      day: data['day'] as String,
      id: data['id'] as String,
      imageGoal: data['imageGoal'] as String,
      user: data['user'] as String,
      dateDone: data['dateDone'] as Timestamp,
    );
  }
}
