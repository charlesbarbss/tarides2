import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  Comment({
    required this.postId,
    required this.comment,
    required this.usersName,
    required this.userImage,
    required this.timestamp,
    required this.firstName,
    required this.lastName,
  });
  final String firstName;
  final String lastName;
  final String postId;
  final String comment;
  final String usersName;
  final String userImage;
  final Timestamp timestamp;

  factory Comment.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() as Map<String, dynamic>;
    return Comment(
      postId: data['postId'] as String,
      comment: data['comment'] as String,
      usersName: data['usersName'] as String,
      userImage: data['userImage'] as String,
      timestamp: data['timestamp'] as Timestamp,
      firstName: data['firstName'] as String,
      lastName: data['lastName'] as String,
    );
  }
}
