import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.postId,
    required this.communityId,
    required this.usersName,
    required this.caption,
    required this.heart,
    required this.commment,
    required this.timestamp,
    required this.isHeart,
  });

  final String postId;
  final String communityId;
  final String usersName;
  final String caption;
  late List<String> heart;
  final List<String> commment;
  final Timestamp timestamp;
  late bool isHeart;

  factory Post.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() as Map<String, dynamic>;
    return Post(
      postId: data['postId'] as String? ?? '',
      communityId: data['communityId'] as String? ?? '',
      usersName: data['usersName'] as String? ?? '',
      caption: data['caption'] as String? ?? '',
      heart: List<String>.from(data['heart'] as List? ?? []),
      commment: List<String>.from(data['commment'] as List? ?? []),
      timestamp: data['timestamp'] as Timestamp? ?? Timestamp.now(),
      isHeart: data['isHeart'] as bool? ?? false,
    );
  }
}
