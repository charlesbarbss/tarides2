import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarides/Model/userModel.dart';

import '../Model/goal30HistoryModel.dart';

class Goal30HistoryController extends ChangeNotifier {
  bool isLoading = false;

  late List<Goal30History?> historys = <Goal30History?>[];

  late Users user;


  void getGoal30History(String username) async {
    isLoading = true;
    notifyListeners();

    final goal30HistoryQuerySnapshot = await FirebaseFirestore.instance
        .collection('goal30History')
        .where('user', isEqualTo: username)
        .orderBy('dateDone', descending: true)
        .get();

    if (goal30HistoryQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('User not found');
    }

    historys = goal30HistoryQuerySnapshot.docs.map((documentSnapshot) {
      return Goal30History.fromDocument(documentSnapshot);

    }).toList();


    isLoading = false;
    notifyListeners();
  }
}
