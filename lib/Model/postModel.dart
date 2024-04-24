import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.postId,
    required this.communityId,
    required this.usersName,
    required this.caption,
    required this.commment,
    required this.heart,
    required this.isHeart,
    required this.timestamp,
    required this.imagePost,
  });
  final String postId;
  final String communityId;
  final String usersName;
  final String caption;
  late List<String> heart;
  final List<String> commment;
  final Timestamp timestamp;
  late bool isHeart;
  final String imagePost;

  factory Post.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() as Map<String, dynamic>;
    final List<dynamic> commentData = data['comment'] ?? [];
    final List<String> comments = commentData.map((comment) {
      return comment as String;
    }).toList();
    final List<dynamic> heartData = data['heart'] ?? [];
    final List<String> hearts = heartData.map((heart) {
      return heart as String;
    }).toList();
    return Post(
      postId: data['postId'] as String,
      communityId: data['communityId'] as String,
      usersName: data['usersName'] as String,
      caption: data['caption'] as String,
      commment: comments,
      heart: hearts,
      isHeart: data['isHeart'] is bool ? data['isHeart'] as bool : false,
      timestamp: data['timestamp'] as Timestamp,
      imagePost: data['imagePost'] as String,
    );
  }
}
