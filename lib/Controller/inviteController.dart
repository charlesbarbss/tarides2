import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tarides/Model/communityInviteModel.dart';
import 'package:tarides/Model/userModel.dart';

class InviteController extends ChangeNotifier {
  late List<Invite> invite = <Invite>[];
  bool isLoading = false;
  late List<Users> user;
  late List<Users> users = <Users>[];

  void getInvite(String username) async {
    isLoading = true;
    notifyListeners();

    final inviteQuerySnapshot = await FirebaseFirestore.instance
        .collection('invite')
        .where('invitee', isEqualTo: username)
        .get();

    if (inviteQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('No invitation found');
    }
    invite = inviteQuerySnapshot.docs.map((documentSnapshot) {
      return Invite.fromDocument(documentSnapshot);
    }).toList();

    final userQuerySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('username', whereIn: invite.map((inv) => inv.invitee).toList())
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

    for (final inv in invite) {
      for (final user in user) {
        if (inv.invitee == user.username) {
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
