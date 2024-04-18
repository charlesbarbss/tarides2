import 'package:cloud_firestore/cloud_firestore.dart';

class Achievements {
  Achievements({
    required this.username,
    required this.legendary,
    required this.newbie,
   
    required this.flawlessGoal30,
    required this.consistentGoal30,
    required this.resilientgoal30,
    required this.flawlessGoal60,
    required this.consistentGoal60,
    required this.resilientgoal60,
    required this.flawlessGoal90,
    required this.consistentGoal90,
    required this.resilientgoal90,
  });
  final String username;

  final bool newbie;
  final bool legendary;

  final bool flawlessGoal30;
  final bool consistentGoal30;
  final bool resilientgoal30;

  final bool flawlessGoal60;
  final bool consistentGoal60;
  final bool resilientgoal60;

  final bool flawlessGoal90;
  final bool consistentGoal90;
  final bool resilientgoal90;

  factory Achievements.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() as Map<String, dynamic>;
    return Achievements(
      username: data['userName'] as String? ?? '',
      legendary: data['legendary'] as bool? ?? false,
      newbie: data['newbie'] as bool? ?? false,
      flawlessGoal30: data['flawlessGoal30'] as bool? ?? false,
      consistentGoal30: data['consistentGoal30'] as bool? ?? false,
      resilientgoal30: data['resilientgoal30'] as bool? ?? false,
      flawlessGoal60: data['flawlessGoal60'] as bool? ?? false,
      consistentGoal60: data['consistentGoal60'] as bool? ?? false,
      resilientgoal60: data['resilientgoal60'] as bool? ?? false,
      flawlessGoal90: data['flawlessGoal90'] as bool? ?? false,
      consistentGoal90: data['consistentGoal90'] as bool? ?? false,
      resilientgoal90: data['resilientgoal90'] as bool? ?? false,
    );
  }
}
