import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  Comment({
    required this.postId,
    required this.comment,
    required this.userEmail,
    required this.userImage,
    required this.timestamp,
  
  });
  
  final String postId;
  final String comment;
  final String userEmail;
  final String userImage;
  final Timestamp timestamp;

  factory Comment.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() as Map<String, dynamic>;
    return Comment(
      postId: data['postId'] as String,
      comment: data['comment'] as String,
      userEmail: data['userEmail'] as String,
      userImage: data['userImage'] as String,
      timestamp: data['timestamp'] as Timestamp,
    );
  }
}
