import 'package:flutter/material.dart';
import 'package:tarides/Controller/communityController.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:tarides/Model/createCommunityModel.dart';

class ViewMembers extends StatefulWidget {
  const ViewMembers({
    super.key,
  });

  @override
  State<ViewMembers> createState() => _ViewMembersState();
}

class _ViewMembersState extends State<ViewMembers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(100, 100, 0,
                  0), // position where you want to show the popup menu on screen
              items: [
                PopupMenuItem(
                  child: Text("Remove Member"),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Text("Promote to Admin"),
                  value: 1,
                ),

                // Add more PopupMenuItems for more options
              ],
            ).then((value) {
              if (value == 0) {
             //remove user to the group
              
              }
              if (value == 1) {
                //promote user as admin
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 150,
              width: 400,
              color: Color.fromARGB(31, 153, 150, 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
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
                              'image',
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'username',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            'email',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
