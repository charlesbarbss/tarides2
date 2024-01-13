import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

File? Image;
final lastNameController = TextEditingController();
final firstNameController = TextEditingController();
final emailController = TextEditingController();
final phoneNumberController = TextEditingController();
final locationController = TextEditingController();
final dateController = TextEditingController();

enum Gender {
  male,
  female,
}

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

class _CreateAccountState extends State<CreateAccount> {
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
    return Scaffold(
      backgroundColor:  Colors.black,
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
              // Center(
              //   child: PickerImage(
              //     onImagePick: (File pickedImage) {
              //       setState(() {});
              //     },
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
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
                          color:  Colors.white,
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
                          color:  Colors.white,
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
                    color:  Colors.white,
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
                          color:  Colors.white,
                        ),
                        prefixIcon: const Icon(
                          Icons.calendar_today,
                          color:  Colors.white,
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
                onTap: () async {},
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
                    color:  Colors.white,
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
                    color:  Colors.white,
                  ),
                  labelText: 'Location',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
