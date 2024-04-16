import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarides/Model/goal30Model.dart';
import 'package:tarides/Model/userModel.dart';

class Goal30Controller extends ChangeNotifier {
  bool isLoading = false;

  late Goal30 goal30;

  late Users user;

  void getGoal30(String email) async {
    isLoading = true;
    notifyListeners();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('User not found');
    }

    final documentSnapshot = querySnapshot.docs.first;
    user = Users.fromDocument(documentSnapshot);

    final goal30QuerySnapshot = await FirebaseFirestore.instance
        .collection('goal30')
        .where('username', isEqualTo: user.username)
        .get();

    if (goal30QuerySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('User not found');
    }

    final goal30DocumentSnapshot = goal30QuerySnapshot.docs.first;
    goal30 = Goal30.fromDocument(goal30DocumentSnapshot);
    isLoading = false;
    notifyListeners();
  }
  
}
