import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tarides/Admin/adminHomePage.dart';
import 'package:tarides/Admin/widgets/adminViewAccount.dart';
import 'package:tarides/Controller/userController.dart';

class AdminUserTab extends StatefulWidget {
  const AdminUserTab({super.key});

  @override
  State<AdminUserTab> createState() => _AdminUserTabState();
}

class _AdminUserTabState extends State<AdminUserTab> {
  UserController userController = UserController();

  @override
  void initState() {
    userController.getAllUsers();
    super.initState();
  }

  void _accountClicked(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an action'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Text("View account"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminViewAccount(
                                index: index,
                              )), // Replace with your screen
                    );
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
               GestureDetector(
  child: Text("Delete account"),
  onTap: () async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete this account?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                final deleteUser = await FirebaseFirestore.instance
                    .collection('user')
                    .where('email',
                        isEqualTo: userController.users[index].email)
                    .get();

                await deleteUser.docs.first.reference.delete();

                final goal30 = await FirebaseFirestore.instance
                    .collection('goal30')
                    .where('username',
                        isEqualTo: userController.users[index].username)
                    .get();

                await goal30.docs.first.reference
                    .delete()
                    .then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminHomePage(
                        email: userController.users[index].email,
                      ),
                    ),
                  );
                });
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
          animation: userController,
          builder: (context, snapshot) {
            if (userController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return GridView.count(
              crossAxisCount: 2, // Number of columns
              children: List.generate(userController.users.length, (index) {
                // Replace 6 with the number of users you have
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        _accountClicked(index);
                      },
                      child: Container(
                        height: 180,
                        width: 200,
                        color: Colors.grey[900],
                        margin: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3.5,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    userController.users[index].imageUrl
                                        .toString(),
                                    height: 130,
                                    width: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Text(
                                userController.users[index].email,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ), // Replace with your email
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Text(
                                userController.users[index].username,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ), // Replace with your username
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            );
          }),
    );
  }
}
