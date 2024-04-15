import 'package:cloud_firestore/cloud_firestore.dart';

class Achievements {
  Achievements({
    required this.goal30Completer,
    required this.isgoal30Completer,
    required this.goal30Participant,
    required this.isgoal30Participant,
    required this.goal60Completer,
    required this.isgoal60Completer,
    required this.goal60Participant,
    required this.isgoal60Participant,
    required this.goal90Completer,
    required this.isgoal90Completer,
    required this.goal90Participant,
    required this.isgoal90Participant,
  });

  final String goal30Completer;
  final bool isgoal30Completer;
  final String goal30Participant;
  final bool isgoal30Participant;
  final String goal60Completer;
  final bool isgoal60Completer;
  final String goal60Participant;
  final bool isgoal60Participant;
  final String goal90Completer;
  final bool isgoal90Completer;
  final String goal90Participant;
  final bool isgoal90Participant;

factory Achievements.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
  final data = document.data() as Map<String, dynamic>;

  return Achievements(
    goal30Completer: data['goal30Completer'] as String,
    isgoal30Completer: data['isgoal30Completer'] as bool,
    goal30Participant: data['goal30Participant'] as String,
    isgoal30Participant: data['isgoal30Participant'] as bool,
    goal60Completer: data['goal60Completer'] as String,
    isgoal60Completer: data['isgoal60Completer'] as bool,
    goal60Participant: data['goal60Participant'] as String,
    isgoal60Participant: data['isgoal60Participant'] as bool,
    goal90Completer: data['goal90Completer'] as String,
    isgoal90Completer: data['isgoal90Completer'] as bool,
    goal90Participant: data['goal90Participant'] as String,
    isgoal90Participant: data['isgoal90Participant'] as bool,
  );
}
}
