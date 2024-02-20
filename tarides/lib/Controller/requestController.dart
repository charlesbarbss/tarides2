import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarides/Model/communityRequestModel.dart';
import 'package:tarides/Model/createCommunityModel.dart';
import 'package:tarides/Model/userModel.dart';

class RequestContoller extends ChangeNotifier {
  bool isLoading = false;
  late List<Request> request = <Request>[];

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

    isLoading = false;
    notifyListeners();
  }
}
