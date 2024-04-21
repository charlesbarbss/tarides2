import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarides/Model/ridesModel.dart';

class RidesController extends ChangeNotifier {
  bool isLoading = false;
  late List<Rides> rides = <Rides>[];
  late List<Rides> enemyRides = <Rides>[];
  late Rides ride;
  void getRides(String username) async {
    isLoading = true;
    notifyListeners();

    final rulesQuerySnapshot = await FirebaseFirestore.instance
        .collection('rides')
        .where('hostUsername', isEqualTo: username)
        .get();

    if (rulesQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('No rides found');
    }

    rides = rulesQuerySnapshot.docs.map((snapshot) {
      return Rides.fromDocument(snapshot);
    }).toList();

    // rides.sort((a, b) => a.timePost.compareTo(b.timePost));

    isLoading = false;
    notifyListeners();
  }

  void getEnemyRides(String enemyUsername) async {
    isLoading = true;
    notifyListeners();

    final rulesQuerySnapshot = await FirebaseFirestore.instance
        .collection('rides')
        .where('enemyUsername', isEqualTo: enemyUsername)
        .get();

    if (rulesQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('No rides found');
    }

    enemyRides = rulesQuerySnapshot.docs.map((snapshot) {
      return Rides.fromDocument(snapshot);
    }).toList();

    // rides.sort((a, b) => a.timePost.compareTo(b.timePost));

    isLoading = false;
    notifyListeners();
  }

  void getRideId(String id) async {
    isLoading = true;
    notifyListeners();

    final rulesQuerySnapshot = await FirebaseFirestore.instance
        .collection('rides')
        .where('idRides', isEqualTo: id)
        .get();

    if (rulesQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('No rides found');
    }
    ride = Rides.fromDocument(rulesQuerySnapshot.docs.first);

    // rides.sort((a, b) => a.timePost.compareTo(b.timePost));

    isLoading = false;
    notifyListeners();
  }
}
