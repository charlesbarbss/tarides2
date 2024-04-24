import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tarides/CommunityTabs/CreateCommunity/createCommunity2.dart';
import 'package:tarides/image_picker_rectangle.dart';

class CreateCommunity extends StatefulWidget {
  const CreateCommunity({super.key, required this.email});
  final String email;

  @override
  State<CreateCommunity> createState() => _CreateCommunityState();
}

class _CreateCommunityState extends State<CreateCommunity> {
  final communityNameController = TextEditingController();
  final communityDescriptionController = TextEditingController();
  File? selectCommunityImage;
  bool _isPrivate = false;

  void _submit() {
    if (communityNameController.text.isEmpty ||
        communityDescriptionController.text.isEmpty || selectCommunityImage == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in the form'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
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
            communityDescription: communityDescriptionController.text,
            imageUrl: selectCommunityImage?.path ?? '',
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
        title: const Text(
          'Create a Community',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: Column(
                children: [
                  const Text(
                    'Name of the Community',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: communityNameController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x3ffffffff0),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x3ffffffff0),
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
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: communityDescriptionController,
                      minLines: 1,
                      maxLines: 10,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type here...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: PickerImageRec(onImagePick: (File pickedImage) {
                      setState(() {
                        selectCommunityImage = pickedImage;
                      });
                    }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SwitchListTile(
                    title: const Text(
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
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _submit,
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
