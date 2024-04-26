import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tarides/Model/commentModel.dart';

class CommentController extends ChangeNotifier {
  bool isLoading = false;
  late List<Comment> comment = <Comment>[];

  void getComment(String postId) async {
     isLoading = true;
    notifyListeners();
    final commentQuerySnapshot = await FirebaseFirestore.instance
        .collection('comment')
        .where('postId', isEqualTo: postId)
        .get();

    if (commentQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('No comment found');
    }

    comment = commentQuerySnapshot.docs.map((commentDocumentSnapshot) {
      return Comment.fromDocument(commentDocumentSnapshot);
    }).toList();

    comment.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    isLoading = false;
    notifyListeners();
  }
}
