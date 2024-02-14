import 'package:flutter/material.dart';

class Goal30Screen extends StatefulWidget {
  const Goal30Screen({super.key});

  @override
  State<Goal30Screen> createState() => _Goal30ScreenState();
}

class _Goal30ScreenState extends State<Goal30Screen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Text(
            'Goal30',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}