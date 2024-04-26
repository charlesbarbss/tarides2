import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tarides/Controller/commentController.dart';
import 'package:tarides/Controller/userController.dart';

class Comments extends StatefulWidget {
  const Comments(
      {super.key,
      required this.postId,
      required this.email,
      required this.userImage});
  final String postId;
  final String email;
  final String userImage;
  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  CommentController commentController = CommentController();
  UserController userController = UserController();
  TextEditingController commentText = TextEditingController();

  String _formatTimestamp(Timestamp timestamp) {
    final diff = DateTime.now().difference(timestamp.toDate());
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  @override
  void initState() {
    userController.getUser(widget.email);
    commentController.getComment(widget.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: commentText,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              hintText: 'Write a comment...',
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('comment').add({
                    'postId': widget.postId,
                    'comment': commentText.text,
                    'userEmail': userController.user.email,
                    'userImage': userController.user.imageUrl,
                    'timestamp': Timestamp.now(),
                  });
                  commentText.clear();
                  commentController.getComment(widget.postId);
                  setState(() {});
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Comments', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        height: 700,
        child: AnimatedBuilder(
          animation: commentController,
          builder: (context, snapshot) {
            if (commentController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (commentController.comment.isEmpty) {
              return Center(
                child: Text(
                  'No Comments yet',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (var i = 0; i < commentController.comment.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 300,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          commentController
                                              .comment[i].userImage),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  commentController
                                                      .comment[i].userEmail,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  commentController
                                                      .comment[i].comment,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(8, 5, 0, 8),
                                                child: Text(
                                                  _formatTimestamp(
                                                      commentController
                                                          .comment[i].timestamp),
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
