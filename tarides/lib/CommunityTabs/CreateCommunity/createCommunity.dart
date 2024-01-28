import 'package:flutter/material.dart';
import 'package:tarides/CommunityTabs/CreateCommunity/createCommunity2.dart';

class CreateCommunity extends StatefulWidget {
  const CreateCommunity({super.key, required this.email});
  final String email;

  @override
  State<CreateCommunity> createState() => _CreateCommunityState();
}

class _CreateCommunityState extends State<CreateCommunity> {
  final communityNameController = TextEditingController();
  bool _isPrivate = false;

  void _submit() {
  if (communityNameController.text.isEmpty) {
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateCommunity2(
          email: widget.email,
          communityName: communityNameController.text,
          isPrivate: _isPrivate,
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
            child: Column(
              children: [
                Text(
                  'Name of the Community',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: communityNameController,
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
                    labelText: 'Community Name',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SwitchListTile(
                  title: Text(
                    'Private',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: _isPrivate,
                  onChanged: (bool value) {
                    setState(() {
                      _isPrivate = value;
                    });
                  },
                  secondary: const Icon(Icons.lock, color: Colors.white),
                  activeColor: Colors.white,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _submit,
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
