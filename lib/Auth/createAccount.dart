import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarides/image_picker.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

enum Gender {
  male,
  female,
}

class _CreateAccountState extends State<CreateAccount> {
  final lastNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  File? selectUserImage;

  bool _obscureText = true;

  Gender? selectedGender;

  IconData? maleIcon = Icons.male;
  IconData? femaleIcon = Icons.female;

  String capitalize(String s) {
    if (s == null || s.isEmpty) {
      return s;
    }
    return s[0].toUpperCase() + s.substring(1);
  }

  DateTime? newSelectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Color(0x3ffFF0000),
              onPrimary: Colors.white,
            ),
            textTheme: TextTheme(),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formattedDate = DateFormat('MM/dd/yyyy').format(picked);
      setState(() {
        dateController.text = formattedDate;
        newSelectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void _createAccount() async {
      if (lastNameController.text.trim().isEmpty ||
          firstNameController.text.trim().isEmpty ||
          emailController.text.trim().isEmpty ||
          usernameController.text.trim().isEmpty ||
          phoneNumberController.text.trim().isEmpty ||
          locationController.text.trim().isEmpty ||
          dateController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty ||
          selectUserImage == null ||
          selectedGender == null) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Invalid input'),
            content: const Text('Please Complete the Form'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Exit',
                ),
              ),
            ],
          ),
        );
      } else {
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        final userId = userCredential.user!.uid;
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('$userId.jpg');
        await storageRef.putFile(selectUserImage!);

        // Get the download URL of the uploaded image
        final imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance.collection('user').add({
          'username': usernameController.text.trim(), // Add this line
          'lastName': lastNameController.text,
          'firstName': firstNameController.text,
          'email': emailController.text,
          'phoneNumber': phoneNumberController.text,
          'location': locationController.text,
          'birthday': dateController.text,
          'gender': selectedGender.toString(),
          'password': passwordController.text,
          'imageUrl': imageUrl,
          'isCommunity': false,
          'isAchievement': false,
          'communityId': '',
        }).then((value) => Navigator.pop(context));
        // print('Account Created Successfully');
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Create Account',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Center(
                child: PickerImage(onImagePick: (File pickedImage) {
                  setState(() {
                    selectUserImage = pickedImage;
                  });
                }),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                    controller: usernameController,
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
                      labelText: 'Username',
                    ),
                  ),
                  SizedBox(height: 10,),
              Row(
                children: [
                  
                 
                  Expanded(
                    child: TextFormField(
                      controller: lastNameController,
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
                        labelText: 'Last Name',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: firstNameController,
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
                        labelText: 'First Name',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: emailController,
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
                  labelText: 'Email',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dateController,
                      onTap: () {
                        _selectDate(context);
                      },
                      style: TextStyle(color: Colors.white),
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
                        prefixIcon: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                        prefixIconColor: Colors.white,
                        suffixIcon: dateController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () => dateController.clear(),
                              ),
                        labelText: 'Birthday',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: selectedGender,
                      dropdownColor: Colors.black,
                      items: Gender.values
                          .map(
                            (gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(
                                capitalize(gender.name),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: selectedGender == gender
                                      ? Colors.white
                                      : Colors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        print(value);
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          selectedGender = value;
                          if (selectedGender == Gender.male) {
                            maleIcon;
                          } else if (selectedGender == Gender.female) {
                            femaleIcon;
                          }
                        });
                      },
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
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        prefixIcon: selectedGender == Gender.male
                            ? Icon(
                                maleIcon,
                                color: Colors.white,
                              )
                            : selectedGender == Gender.female
                                ? Icon(
                                    femaleIcon,
                                    color: Colors.white,
                                  )
                                : null,
                        prefixIconColor: Colors.white,
                        labelText: 'Gender',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
             
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: phoneNumberController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLines: 1,
                maxLength: 11,
                decoration: InputDecoration(
                  counterText: "",
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
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  prefixIconColor: Colors.white,
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  suffixIcon: phoneNumberController.text.isEmpty
                      ? Container(width: 0)
                      : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => phoneNumberController.clear(),
                        ),
                  labelText: 'Phone Number',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: locationController,
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
                  labelText: 'Location',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: _obscureText,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x3ffffffff0),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x3ffffffff0),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  labelStyle: TextStyle(
                    color:  Colors.white,
                  ),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  prefixIconColor: Colors.white,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off),
                  ),
                  suffixIconColor:  Colors.white,
                  labelText: 'Password',
                ),
              ),
              SizedBox(
                height: 10,
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
                onPressed: () {
                  _createAccount();
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
