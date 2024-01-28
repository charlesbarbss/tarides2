import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarides/Model/userModel.dart';


class UserController extends ChangeNotifier {
  late final String email;

  late Users user;
  bool isLoading = false;

  void setEmail(String email) {
    this.email = email;
  }

  void getUser(String email) async {
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
    isLoading = false;
    notifyListeners();
  }
}