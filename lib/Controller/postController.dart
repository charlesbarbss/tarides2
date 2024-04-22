import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarides/Model/postModel.dart';
import 'package:tarides/Model/userModel.dart';

class PostController extends ChangeNotifier {
  late final String email;
  bool isLoading = false;
  late List<Post> posts = <Post>[];
  late List<Users> user = <Users>[];
  late List<Users> users = <Users>[];

  void setEmail(String email) {
    this.email = email;
  }

  void getPost(String communityId) async {
   
    isLoading = true;
    notifyListeners();

    final postsQuerySnapshot = await FirebaseFirestore.instance
        .collection('post')
        .where('communityId', isEqualTo: communityId)
        // .orderBy('timestamp', descending: true)
        .get();

    if (postsQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('No post found');
    }

    posts = postsQuerySnapshot.docs.map((snapshot) {
      return Post.fromDocument(snapshot);
    }).toList();
    isLoading = false;
    notifyListeners();

    final userQuerySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('username',
            whereIn: posts.map((post) => post.usersName).toList())
        .get();

    if (userQuerySnapshot.docs.isEmpty) {
      isLoading = false;
      notifyListeners();
      throw Exception('No users1 found');
    }
    user = userQuerySnapshot.docs.map((usersDocumentSnapshot) {
      return Users.fromDocument(usersDocumentSnapshot);
    }).toList();
    isLoading = false;
    notifyListeners();
    print(["us lenght", user.length]);
    print(["user  lenght", user[0].username]);
    for (final post in posts) {
      for (final user in user) {
        if (post.usersName == user.username) {
          users.add(user);
          notifyListeners();

          print('Match found!');
        }
      }
    }
isLoading = false;
notifyListeners();
    print(["user lenght", users.length]);
    print(["post lenght", posts.length]);
  }

  
}