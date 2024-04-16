import 'package:cloud_firestore/cloud_firestore.dart';

class Achievements {
  Achievements({
    required this.username,
    required this.isgoal30Completer,
    required this.isgoal30Participant,
    required this.isgoal60Completer,
    required this.isgoal60Participant,
    required this.isgoal90Completer,
    required this.isgoal90Participant,
  });
  final String username;

  final bool isgoal30Completer;

  final bool isgoal30Participant;

  final bool isgoal60Completer;

  final bool isgoal60Participant;

  final bool isgoal90Completer;

  final bool isgoal90Participant;

  factory Achievements.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() as Map<String, dynamic>;

    return Achievements(
      username: data['username'] as String? ?? '',
      isgoal30Completer: data['isgoal30Completer'] as bool? ?? false,
      isgoal30Participant: data['isgoal30Participant'] as bool? ?? false,
      isgoal60Completer: data['isgoal60Completer'] as bool? ?? false,
      isgoal60Participant: data['isgoal60Participant'] as bool? ?? false,
      isgoal90Completer: data['isgoal90Completer'] as bool? ?? false,
      isgoal90Participant: data['isgoal90Participant'] as bool? ?? false,
    );
  }
}
