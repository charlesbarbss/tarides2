import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tarides/Auth/CreateAccount.dart';
import 'package:tarides/Auth/forgotPassword.dart';

import '../homePage.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _obscureText = true;

  final emailController = TextEditingController();
  final passController = TextEditingController();

  void _logIn() {
    // print('pasok');
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passController.text)
        .then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  email: emailController.text,
                )),
      );
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid username or password.',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 150, 10, 10),
          child: Column(
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Ta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 70,
                        fontWeight: FontWeight.w900,
                        fontFamily: "DM Sans",
                      ),
                    ),
                    TextSpan(
                      text: 'RIDES',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 70,
                        fontWeight: FontWeight.w900,
                        fontFamily: "DM Sans",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: emailController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x3fffFFFFF0),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 255, 240),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  labelText: 'email',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: _obscureText,
                style: const TextStyle(
                  color: Colors.white,
                ),
                controller: passController,
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 255, 240),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 255, 240),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 240),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: const Color.fromARGB(255, 255, 255, 240),
                    ),
                  ),
                  suffixIconColor: const Color.fromARGB(255, 255, 255, 240),
                  labelText: 'password',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAccount(),
                        ),
                      );
                    },
                    child: const Text(
                      'Create Account',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPassword(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 160, vertical: 18),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: _logIn,
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 240),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
