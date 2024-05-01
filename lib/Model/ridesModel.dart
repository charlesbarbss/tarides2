import 'package:cloud_firestore/cloud_firestore.dart';

class Rides {
  Rides({
    required this.id,
    required this.idRides,
    required this.hostUsername,
    required this.hostFirstName,
    required this.hostLastName,
    required this.hostEmail,
    required this.hostImage,
    required this.hostLat,
    required this.hostLng,
    required this.startPointLat,
    required this.startPointLng,
    required this.midPointLat,
    required this.midPointLng,
    required this.endPointLat,
    required this.endPointLng,
    required this.enemyUsername,
    required this.enemyEmail,
    required this.enemyImage,
    required this.enemyLat,
    required this.enemyLng,
    required this.selected,
    required this.enemyCommunityId,
    required this.enemyFirstName,
    required this.enemyLastName,
    required this.enemyCommunityName,
    required this.raceDate,
    required this.raceTime,
    required this.meetupLocation,
    required this.challengeMessage,
    required this.isAllReady,
    required this.timeRequest,
    required this.hostCommunityName,
    required this.startText,
    required this.midText,
    required this.endText,
    required this.isPickingRoute,
    required this.isContinue,
    required this.timer,
    required this.hostAvgSpeed,
    required this.enemyAvgSpeed,
    required this.isFinished,
  });

  final String id;
  final String idRides;
  final String hostUsername;
  final String hostFirstName;
  final String hostLastName;
  final String hostEmail;
  final String hostImage;
  final double hostLat;
  final double hostLng;
  final String hostCommunityName;
  final double startPointLat;
  final double startPointLng;
  final double midPointLat;
  final double midPointLng;
  final double endPointLat;
  final double endPointLng;
  final String enemyUsername;
  final String enemyEmail;
  final String enemyImage;
  final double enemyLat;
  final double enemyLng;
  final String enemyFirstName;
  final String enemyLastName;
  final bool selected;
  final String enemyCommunityId;
  final String enemyCommunityName;
  final String raceDate;
  final Timestamp raceTime;
  final String meetupLocation;
  final String challengeMessage;
  final Timestamp timeRequest;
  final bool isAllReady;
  final String startText;
  final String midText;
  final String endText;
  late bool isPickingRoute;
  final bool isContinue;
  final String timer;
  final double hostAvgSpeed;
  final double enemyAvgSpeed;
  final bool isFinished;

  factory Rides.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() as Map<String, dynamic>;
    return Rides(
        id: document.id,
        idRides: data['idRides'] as String? ?? '',
        hostUsername: data['hostUsername'] as String? ?? '',
        hostFirstName: data['hostFirstName'] as String? ?? '',
        hostLastName: data['hostLastName'] as String? ?? '',
        hostEmail: data['hostEmail'] as String? ?? '',
        hostImage: data['hostImage'] as String? ?? '',
        hostLat: (data['hostLat'] as num? ?? 0).toDouble(),
        hostLng: (data['hostLng'] as num? ?? 0).toDouble(),
        startPointLat: (data['startPointLat'] as num? ?? 0).toDouble(),
        startPointLng: (data['startPointLng'] as num? ?? 0).toDouble(),
        midPointLat: (data['midPointLat'] as num? ?? 0).toDouble(),
        midPointLng: (data['midPointLng'] as num? ?? 0).toDouble(),
        endPointLat: (data['endPointLat'] as num? ?? 0).toDouble(),
        endPointLng: (data['endPointLng'] as num? ?? 0).toDouble(),
        enemyUsername: data['enemyUsername'] as String? ?? '',
        enemyEmail: data['enemyEmail'] as String? ?? '',
        enemyImage: data['enemyImage'] as String? ?? '',
        enemyLat: (data['enemyLat'] as num? ?? 0).toDouble(),
        enemyLng: (data['enemyLng'] as num? ?? 0).toDouble(),
        selected: data['selected'] as bool? ?? false,
        enemyCommunityId: data['enemyCommunityId'] as String,
        enemyFirstName: data['enemyFirstName'] as String? ?? '',
        enemyLastName: data['enemyLastName'] as String? ?? '',
        enemyCommunityName: data['enemyCommunityName'] as String? ?? '',
        raceDate: data['raceDate'] as String? ?? '',
        raceTime: data['raceTime'] as Timestamp? ?? Timestamp.now(),
        meetupLocation: data['meetupLocation'] as String? ?? '',
        challengeMessage: data['challengeMessage'] as String? ?? '',
        isAllReady: data['isAllReady'] as bool? ?? false,
        timeRequest: data['timeRequest'] as Timestamp? ?? Timestamp.now(),
        hostCommunityName: data['hostCommunityName'] as String? ?? '',
        startText: data['startText'] as String? ?? '',
        midText: data['midText'] as String? ?? '',
        endText: data['endText'] as String? ?? '',
        isPickingRoute: data['isPickingRoute'] as bool? ?? false,
        isContinue: data['isContinue'] as bool? ?? false,
        timer: data['timer'] as String? ?? '',
        hostAvgSpeed: (data['hostAvgSpeed'] as num? ?? 0).toDouble(),
        enemyAvgSpeed: (data['enemyAvgSpeed'] as num? ?? 0).toDouble(),
        isFinished: data['isFinished'] as bool? ?? false);
  }
}
