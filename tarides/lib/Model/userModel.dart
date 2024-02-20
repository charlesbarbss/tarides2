import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  Users({
    required this.id,
    required this.username,
    required this.birthday,
    required this.email,
    required this.firstName,
    required this.gender,
    required this.imageUrl,
    required this.lastName,
    required this.location,
    required this.password,
    required this.phoneNumber,
    required this.isCommunity,
    required this.isAchievement,
    required this.communityId,
  });

  final String id;
  final String username;
  final String birthday;
  final String email;
  final String firstName;
  final String gender;
  final String imageUrl;
  final String lastName;
  final String location;
  final String password;
  final String phoneNumber;
  late bool isCommunity;
  final bool isAchievement;
  late String communityId;

  factory Users.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() as Map<String, dynamic>;
    return Users(
      id: document.id,
      username: data['username'] as String? ?? '',
      birthday: data['birthday'] as String? ?? '',
      email: data['email'] as String? ?? '',
      firstName: data['firstName'] as String? ?? '',
      gender: data['gender'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      lastName: data['lastName'] as String? ?? '',
      location: data['location'] as String? ?? '',
      password: data['password'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      isCommunity: data['isCommunity'] as bool? ?? false,
      isAchievement: data['isAchievement'] as bool? ?? false,
      communityId: data['communityId'] as String? ?? '',
    );
  }
}
