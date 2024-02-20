import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tarides/BottomNav/communityScreeen.dart';
import 'package:tarides/CommunityTabs/postTab.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/homePage.dart';

class CreateCommunity2 extends StatefulWidget {
  const CreateCommunity2(
      {super.key,
      required this.email,
      required this.communityName,
      required this.isPrivate,
      required this.communityDescription});
  final String email;
  final String communityName;
  final bool isPrivate;
  final String communityDescription;
  @override
  State<CreateCommunity2> createState() => _CreateCommunity2State();
}

class _CreateCommunity2State extends State<CreateCommunity2> {
  UserController userController = UserController();
  final communityId =
      FirebaseFirestore.instance.collection('community').doc().id;

  final postId = FirebaseFirestore.instance.collection('post').doc().id;
  @override
  void initState() {
    userController.getUser(widget.email);
    super.initState();
  }

  final postController = TextEditingController();

  void submitCreateGroup() async {
    if (postController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in the form'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    } else {
      await FirebaseFirestore.instance.collection('community').add({
        'communityName': widget.communityName,
        'communityId': communityId,
        'isPrivate': widget.isPrivate,
        'communityAdmin': userController.user.username,
        'communityMember': [userController.user.username],
        'communityDescription': widget.communityDescription,
      });

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userController.user.id)
          .update({
        'communityId': communityId,
        'isCommunity': true,
      });

      await FirebaseFirestore.instance.collection('post').add({
        'postId': postId,
        'communityId': communityId,
        'usersName': userController.user.username,
        'caption': postController.text,
        'heart': [],
        'commment': [],
        'timestamp': Timestamp.now(),
        'isHeart': false,
      });

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (ctx) => HomePage(
                  email: widget.email,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: userController,
      builder: (context, snapshot) {
        if (userController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              'Create a Community',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create your 1st Community Post',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        height: 220,
                        width: 380,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(31, 153, 150, 150),
                          borderRadius: BorderRadius.circular(
                              15), // adjust the value as needed
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3.5,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      userController.user.imageUrl.toString(),
                                      height: 130,
                                      width: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${userController.user.firstName} ${userController.user.lastName}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      userController.user.username,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: TextFormField(
                                controller: postController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x3fffFFFFF0),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x3fffFFFFF0),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  labelText: "What's on your mind?",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 10),
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: submitCreateGroup,
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
