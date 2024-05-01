import 'package:cloud_firestore/cloud_firestore.dart';

class RidesHistory {
  RidesHistory({
    required this.winner,
    required this.loser,
    required this.id,
    required this.imageGoal,
   
    required this.dateDone,
  
  });

  final String winner;
  final String loser;
  final String id;
  final String imageGoal;
  final Timestamp dateDone;


  factory RidesHistory.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() as Map<String, dynamic>;

    return RidesHistory(
      winner: data['winner'] as String? ?? '',
      loser: data['loser'] as String? ?? '',
      id: data['id'] as String? ?? '',
      imageGoal: data['imageGoal'] as String? ?? '',
    
      dateDone: data['dateDone'] as Timestamp? ?? Timestamp.now(),
   
    );
  }
}
