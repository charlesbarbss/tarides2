import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarides/Model/createCommunityModel.dart';
import 'package:tarides/Model/userModel.dart';

class CommunityController extends ChangeNotifier {

  late final String email;

  late Users user;
  Community? community;
  bool isLoading = false;
 late List<Community> communities = <Community>[];
 



  void getCommunityAndUser(String email) async {
   
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

    final communityQuerySnapshot = await FirebaseFirestore.instance
        .collection('community')
        .where('communityId', isEqualTo: user.communityId)
        .get();

    if (communityQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('Community not found');
    }

    final communityDocumentSnapshot = communityQuerySnapshot.docs.first;
    community = Community.fromDocument(communityDocumentSnapshot);

    isLoading = false;
    notifyListeners();


  }

 void getAllCommunity() async {
    final communitiesQuerySnapshot =
        await FirebaseFirestore.instance.collection('community').get();

    if (communitiesQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('No communities found');
    }

    communities = communitiesQuerySnapshot.docs.map((documentSnapshot) {
      return Community.fromDocument(documentSnapshot);
    }).toList();

    isLoading = false;
    notifyListeners();
    print(["communities lenght", communities.length]);
   
  }

}