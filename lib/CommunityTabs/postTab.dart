import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tarides/BottomNav/communityScreeen.dart';
import 'package:tarides/CommunityTabs/viewMembers.dart';
import 'package:tarides/Controller/communityController.dart';
import 'package:tarides/Controller/postController.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/Model/postModel.dart';
import 'package:tarides/Model/userModel.dart';
import 'package:tarides/homePage.dart';

class PostTab extends StatefulWidget {
  final String email;
  final String communityId;
  const PostTab({super.key, required this.email, required this.communityId});

  @override
  State<PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  final bool _isHeartFilled = false;

  final postId = FirebaseFirestore.instance.collection('post').doc().id;

  UserController userController = UserController();

  CommunityController communityController = CommunityController();

  final createPostController = TextEditingController();

  PostController postController = PostController();

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
    communityController.getCommunityAndUser(widget.email);
    postController.getPost(widget.communityId);
    super.initState();
  }

  void _createPost() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a Post'),
          content: Form(
            child: TextFormField(
              controller: createPostController,
              minLines: 1,
              maxLines: 5,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                labelText: 'Whats on your mind?',
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await FirebaseFirestore.instance.collection('post').add({
                  'postId': postId, // Add this line
                  'communityId': userController.user.communityId,
                  'usersName': userController.user.username,
                  'caption': createPostController.text,
                  'heart': [],
                  'comment': [],
                  'timestamp': Timestamp.now(),
                  'isHeart': false,
                }).then((value) => Navigator.pop(context));
              },
              child: const Text(
                'Post',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _createPost,
        backgroundColor: Colors.red[900],
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: userController,
        builder: (context, snapshot) {
          if (userController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                if (userController.user.isCommunity == false)
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Text(
                          'You are not in a community',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  )
                else
                  AnimatedBuilder(
                    animation: communityController,
                    builder: (context, snapshot) {
                      if (communityController.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (communityController.community == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  communityController.community!.communityName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.exit_to_app),
                                        color: Colors.red,
                                        onPressed: () async {
                                          if (communityController
                                                  .community!.communityAdmin !=
                                              userController.user.username) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  email: widget.email,
                                                  homePageIndex: 0,
                                                ),
                                              ),
                                            );
                                            final userDoc =
                                                await FirebaseFirestore.instance
                                                    .collection('user')
                                                    .where('username',
                                                        isEqualTo:
                                                            userController
                                                                .user.username)
                                                    .get();

                                            await userDoc.docs.first.reference
                                                .update({
                                              'communityId': '',
                                              'isCommunity': false,
                                            });

                                            final communityDoc =
                                                await FirebaseFirestore
                                                    .instance
                                                    .collection('community')
                                                    .where(
                                                        'communityId',
                                                        isEqualTo:
                                                            communityController
                                                                .community!
                                                                .communityId)
                                                    .where('communityMember',
                                                        arrayContains:
                                                            userController
                                                                .user.username)
                                                    .get();

                                            await communityDoc
                                                .docs.first.reference
                                                .update({
                                              'communityMember':
                                                  FieldValue.arrayRemove([
                                                userController.user.username
                                              ]),
                                            });
                                          }
                                          if (communityController.community!
                                                      .communityAdmin ==
                                                  userController
                                                      .user.username &&
                                              communityController.community!
                                                      .communityMember.length !=
                                                  1) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Error'),
                                                  content: Text(
                                                      'You are the admin, you cannot leave the group.'),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                          if (communityController.community!
                                                      .communityAdmin ==
                                                  userController
                                                      .user.username &&
                                              communityController.community!
                                                      .communityMember.length ==
                                                  1) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'You are the admin'), // Replace with your title
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text(
                                                            'Do you wish to delete this community?'), // Replace with your body text
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text(
                                                          'Yes'), // Replace with your button text
                                                      onPressed: () async {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    HomePage(
                                                              email:
                                                                  widget.email,
                                                              homePageIndex: 0,
                                                            ),
                                                          ),
                                                        );
                                                        final userDoc =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'user')
                                                                .where(
                                                                    'username',
                                                                    isEqualTo:
                                                                        userController
                                                                            .user
                                                                            .username)
                                                                .get();

                                                        await userDoc.docs.first
                                                            .reference
                                                            .update({
                                                          'communityId': '',
                                                          'isCommunity': false,
                                                        });

                                                        final communityDoc =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'community')
                                                                .where(
                                                                    'communityId',
                                                                    isEqualTo: communityController
                                                                        .community!
                                                                        .communityId)
                                                                .get();

                                                        await communityDoc.docs
                                                            .first.reference
                                                            .delete();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                          'No'), // Replace with your button text
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  communityController.community!.isPrivate
                                      ? 'Private Group'
                                      : 'Public Group',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                communityController.community!.isPrivate
                                    ? const Icon(Icons.lock,
                                        color: Colors.white)
                                    : const Icon(Icons.lock_open,
                                        color: Colors.white),
                                const SizedBox(width: 5),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'No of Memebers: ${communityController.community?.communityMember.length ?? 0}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                if (communityController
                                        .community!.communityAdmin ==
                                    userController.user.username)
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                side: BorderSide(
                                                    color: Colors.grey)))),
                                    onPressed: () {
                                      for (int x = 0;
                                          x <
                                              communityController.community!
                                                  .communityMember.length;
                                          x++) {
                                        if (communityController.community!
                                                .communityMember[x] ==
                                            userController.user.username) {
                                          String nonAdminMembers =
                                              communityController.community!
                                                  .communityMember[x];

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewMembers(
                                                      email: widget.email,
                                                      communityId:
                                                          widget.communityId,
                                                      admin: nonAdminMembers,
                                                    )),
                                          );
                                        }
                                      }
                                    },
                                    child: Text('View Members',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                const Text(
                                  'Group Post',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                AnimatedBuilder(
                                    animation: postController,
                                    builder: (context, snapshot) {
                                      if (postController.isLoading) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return Column(
                                        children: [
                                          for (var i = 0;
                                              i < postController.posts.length;
                                              i++)
                                            Column(
                                              children: [
                                                Container(
                                                  height: 210,
                                                  width: 400,
                                                  color: const Color.fromARGB(
                                                      31, 153, 150, 150),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              height: 50,
                                                              width: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 3.5,
                                                                ),
                                                              ),
                                                              child: ClipOval(
                                                                child: Image
                                                                    .network(
                                                                  postController
                                                                      .users[i]
                                                                      .imageUrl,
                                                                  height: 130,
                                                                  width: 130,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    postController
                                                                        .posts[
                                                                            i]
                                                                        .usersName,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    _formatTimestamp(postController
                                                                        .posts[
                                                                            i]
                                                                        .timestamp),
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                postController
                                                                    .users[i]
                                                                    .email,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            width: 92,
                                                          ),
                                                          
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                10, 0, 10, 10),
                                                        child: Text(
                                                          postController
                                                              .posts[i].caption,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          IconButton(
                                                            icon: Icon(postController
                                                                        .posts[
                                                                            i]
                                                                        .isHeart ==
                                                                    true
                                                                ? Icons.favorite
                                                                : Icons
                                                                    .favorite_border),
                                                            color: Colors.red,
                                                            iconSize: 30,
                                                            onPressed:
                                                                () async {
                                                              setState(
                                                                () {
                                                                  if (postController
                                                                          .posts[
                                                                              i]
                                                                          .isHeart ==
                                                                      true) {
                                                                    postController
                                                                        .posts[
                                                                            i]
                                                                        .isHeart = false;
                                                                    postController
                                                                        .posts[
                                                                            i]
                                                                        .heart
                                                                        .remove(userController
                                                                            .user
                                                                            .username);
                                                                  } else {
                                                                    postController
                                                                        .posts[
                                                                            i]
                                                                        .isHeart = true;
                                                                    postController
                                                                        .posts[
                                                                            i]
                                                                        .heart
                                                                        .add(userController
                                                                            .user
                                                                            .username);
                                                                  }
                                                                },
                                                              );

                                                              try {
                                                                final postDocumentSnapshot = await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'post')
                                                                    .where(
                                                                        'caption',
                                                                        isEqualTo: postController
                                                                            .posts[
                                                                                i]
                                                                            .caption)
                                                                    .where(
                                                                        'usersName',
                                                                        isEqualTo: userController
                                                                            .user
                                                                            .username)
                                                                    .where(
                                                                        'postId',
                                                                        isEqualTo: postController
                                                                            .posts[i]
                                                                            .postId)
                                                                    .get();

                                                                if (postDocumentSnapshot
                                                                    .docs
                                                                    .isEmpty) {
                                                                  throw Exception(
                                                                      'posts not found');
                                                                }

                                                                if (postController
                                                                    .posts[i]
                                                                    .isHeart) {
                                                                  await postDocumentSnapshot
                                                                      .docs
                                                                      .first
                                                                      .reference
                                                                      .update({
                                                                    'heart':
                                                                        FieldValue
                                                                            .arrayUnion(
                                                                      [
                                                                        userController
                                                                            .user
                                                                            .username,
                                                                      ],
                                                                    ),
                                                                    'isHeart':
                                                                        true
                                                                  });
                                                                } else {
                                                                  await postDocumentSnapshot
                                                                      .docs
                                                                      .first
                                                                      .reference
                                                                      .update({
                                                                    'heart':
                                                                        FieldValue
                                                                            .arrayRemove([
                                                                      userController
                                                                          .user
                                                                          .username
                                                                    ]),
                                                                    'isHeart':
                                                                        false
                                                                  });
                                                                }
                                                              } catch (e) {
                                                                print(
                                                                    'Error updating post: $e');
                                                                // Handle the error here, such as displaying an error message to the user
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(
                                                            width: 1,
                                                          ),
                                                          Text(
                                                            postController
                                                                .posts[i]
                                                                .heart
                                                                .length
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 15),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              if (postController
                                                                      .posts[i]
                                                                      .usersName ==
                                                                  userController
                                                                      .user
                                                                      .username)
                                                                IconButton(
                                                                  icon: Icon(Icons
                                                                      .delete), // Change this to your desired icon
                                                                  color: Colors
                                                                      .white,
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Delete Post'), // Replace with your title
                                                                          content:
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                ListBody(
                                                                              children: [
                                                                                Text('Do you wish to delete this post?'), // Replace with your body text
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          actions: [
                                                                            TextButton(
                                                                              child: Text('Yes'), // Replace with your button text
                                                                              // onPressed:(){
                                                                              //   print('Y E S clicked');
                                                                              // },
                                                                              onPressed: () async {
                                                                                // Replace 'postId' with the actual document ID of the post
                                                                                final postDoc = await FirebaseFirestore.instance.collection('post').where('postId', isEqualTo: postController.posts[i].postId).get();

                                                                                await postDoc.docs.first.reference.delete();

                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => HomePage(
                                                                                      email: widget.email,
                                                                                      homePageIndex: 0,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                            TextButton(
                                                                              child: Text('No'), // Replace with your button text
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                            ],
                                                          ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                        ],
                                      );
                                    }),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
