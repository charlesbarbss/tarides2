import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarides/Model/pedalHistoryModel.dart';
import 'package:tarides/Model/userModel.dart';


class PedalHistoryController extends ChangeNotifier {
  bool isLoading = false;

  late List<PedalHistory?> historys = <PedalHistory?>[];

  late Users user;


  void getPedalHistory(String username) async {
  
    isLoading = true;
    notifyListeners();

    final pedalHistoryQuerySnapshot = await FirebaseFirestore.instance
        .collection('pedalHistory')
        .where('username', isEqualTo: username)
        .get();
print('1');
    if (pedalHistoryQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      print('2');
      notifyListeners();
      throw Exception('User not found');
    }
print('pasok');
    historys = pedalHistoryQuerySnapshot.docs.map((documentSnapshot) {
      return PedalHistory.fromDocument(documentSnapshot);

    }).toList();

print('3');
    isLoading = false;
    notifyListeners();
  }
}
