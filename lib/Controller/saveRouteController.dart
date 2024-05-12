import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarides/Model/saveRouteModel.dart';
import 'package:tarides/Model/userModel.dart';

class SaveRouteController extends ChangeNotifier {
  bool isLoading = false;

  late List<SaveRoute?> route = <SaveRoute?>[];
  late SaveRoute save;

  void getSaveRoutes() async {
    isLoading = true;
    notifyListeners();

    final pedalHistoryQuerySnapshot =
        await FirebaseFirestore.instance.collection('saveRoute').get();
    print('1');
    if (pedalHistoryQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      print('2');
      notifyListeners();
      throw Exception('Route not found');
    }
    print('pasok');
    route = pedalHistoryQuerySnapshot.docs.map((documentSnapshot) {
      return SaveRoute.fromDocument(documentSnapshot);
    }).toList();

    print('3');
    isLoading = false;
    notifyListeners();
  }

  void selectedSave() async {
    isLoading = true;
    notifyListeners();

    final pedalHistoryQuerySnapshot = await FirebaseFirestore.instance
        .collection('saveRoute')
        .where('useClicked', isEqualTo: true)
       
        .get();
    print('1');
    if (pedalHistoryQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      print('2');
      notifyListeners();
      throw Exception('Route not found');
    }
    print('pasok');
    final documentSnapshot = pedalHistoryQuerySnapshot.docs.first;
    save = SaveRoute.fromDocument(documentSnapshot);
    isLoading = false;
    notifyListeners();
  }
}
