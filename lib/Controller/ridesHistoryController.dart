import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarides/Model/ridesHistoryModel.dart';
import 'package:tarides/Model/userModel.dart';

class RidesHistoryController extends ChangeNotifier {
  bool isLoading = false;

  late List<RidesHistory?> historys = <RidesHistory?>[];

  late Users user;

  void getRidesHistory(String username) async {
    isLoading = true;
    notifyListeners();

    final winnerQuerySnapshot = await FirebaseFirestore.instance
        .collection('ridesHistory')
        .where('winner', isEqualTo: username)
        .get();

    final loserQuerySnapshot = await FirebaseFirestore.instance
        .collection('ridesHistory')
        .where('loser', isEqualTo: username)
        .get();

    if (winnerQuerySnapshot.docs.isEmpty && loserQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('User not found');
    }

    historys = [...winnerQuerySnapshot.docs, ...loserQuerySnapshot.docs].map((documentSnapshot) {
      return RidesHistory.fromDocument(documentSnapshot);
    }).toList();

    isLoading = false;
    notifyListeners();
  }
}