import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  Request({
    required this.requestId,
    required this.requestCommunityId,
    required this.usersName,
  });

  final String requestId;
  final String requestCommunityId;
  final String usersName;

  factory Request.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() as Map<String, dynamic>;

    return Request(
      requestId: data['requestId'] as String? ?? '',
      requestCommunityId: data['requestCommunityId'] as String? ?? '',
      usersName: data['usersName'] as String? ?? '',
    );
  }
}