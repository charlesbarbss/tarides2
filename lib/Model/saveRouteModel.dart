import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SaveRoute {
  SaveRoute({
    required this.routeId,
    required this.username,
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.finalDestinationLat,
    required this.finalDestinationLng,
    required this.firstPinPoint,
    required this.secondPinPoint,
    required this.thirdPinPoint,
    required this.useClicked,
  });

  final String routeId;
  final String username;
   double originLat;
   double originLng;
   double destinationLat;
   double destinationLng;
   double finalDestinationLat;
   double finalDestinationLng;
   String firstPinPoint;
   String secondPinPoint;
   String thirdPinPoint;
  final bool useClicked;
  
  //info
  //info2
 factory SaveRoute.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
  final data = document.data() as Map<String, dynamic>;

  return SaveRoute(
routeId: data['routeId'] as String? ?? '',
username: data['username'] as String? ?? '',
originLat: data['originLat'] as double? ?? 0.0,
originLng: data['originLng'] as double? ?? 0.0,
destinationLat: data['destinationLat'] as double? ?? 0.0,
destinationLng: data['destinationLng'] as double? ?? 0.0,
finalDestinationLat: data['finalDestinationLat'] as double? ?? 0.0,
finalDestinationLng: data['finalDestinationLng'] as double? ?? 0.0,
firstPinPoint: data['firstPinPoint'] as String? ?? '',
secondPinPoint: data['secondPinPoint'] as String? ?? '',
thirdPinPoint: data['thirdPinPoint'] as String? ?? '',
useClicked: data['useClicked'] as bool? ?? false,
  );
}
  
}
