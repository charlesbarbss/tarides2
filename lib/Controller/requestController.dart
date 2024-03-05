import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarides/Model/communityRequestModel.dart';
import 'package:tarides/Model/createCommunityModel.dart';
import 'package:tarides/Model/userModel.dart';

class RequestContoller extends ChangeNotifier {
  bool isLoading = false;
  late List<Request> request = <Request>[];
  late List<Users> user;
  late List<Users> users = <Users>[];

  void getAllReqeust() async {
    isLoading = true;
    notifyListeners();
    final requestQuerySnapshot =
        await FirebaseFirestore.instance.collection('request').get();

    if (requestQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('No request found');
    }

    request = requestQuerySnapshot.docs.map((documentSnapshot) {
      return Request.fromDocument(documentSnapshot);
    }).toList();

    final userQuerySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('username',
            whereIn: request.map((req) => req.usersName).toList())
        .get();

    if (userQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('No users1 found');
    }
    user = userQuerySnapshot.docs.map((usersDocumentSnapshot) {
      return Users.fromDocument(usersDocumentSnapshot);
    }).toList();
    isLoading = false;
    notifyListeners();

    for (final req in request) {
      for (final user in user) {
        if (req.usersName == user.username) {
          users.add(user);
          notifyListeners();

          print('Match found!');
        }
      }
    }

    isLoading = false;
    notifyListeners();
  }
}
