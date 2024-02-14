import 'package:flutter/material.dart';

class PedalScreeen extends StatefulWidget {
  const PedalScreeen({super.key});

  @override
  State<PedalScreeen> createState() => _PedalScreeenState();
}

class _PedalScreeenState extends State<PedalScreeen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Text(
            'Pedal',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}