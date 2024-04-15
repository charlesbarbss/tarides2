import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarides/Model/userModel.dart';


class UserController extends ChangeNotifier {
  
  late final String email;

  late Users user;
  bool isLoading = false;

  late List<Users> users = <Users>[];

  late List<Users> members = <Users>[];



 

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

  void getAllUsers() async {
    isLoading = true;
    notifyListeners();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isNotEqualTo: 'super.admin@tarides.com')
        .get();

    if (querySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('Users not found');
    }

    users = querySnapshot.docs.map((snapshot) {
      return Users.fromDocument(snapshot);
    }).toList();

    isLoading = false;
    notifyListeners();
  }

  void getAllMembers(String communityId, String admin) async {
    isLoading = true;
    notifyListeners();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('communityId', isEqualTo: communityId)
        .get();

    if (querySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('Members not found');
    }
    members = querySnapshot.docs.map((snapshot) {
      return Users.fromDocument(snapshot);
    }).toList();
    isLoading = false;
    notifyListeners();
  }

 
}
