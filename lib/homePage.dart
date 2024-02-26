import 'package:flutter/material.dart';
import 'package:tarides/BottomNav/Goal30Screen.dart';
import 'package:tarides/BottomNav/pedalScreen.dart';
import 'package:tarides/BottomNav/profileScreen.dart';
import 'package:tarides/Controller/userController.dart';

import 'BottomNav/ridesScreen.dart';
import 'BottomNav/communityScreeen.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.email,
  });
  final String email;

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedPageIndex = 2;

  UserController userController = UserController();

  @override
  void initState() {
    super.initState();

    userController.getUser(widget.email);
  }

  void selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
    print(_selectedPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CommunityScreen(
      email: widget.email,
    );

    if (_selectedPageIndex == 1) {
      activePage = RidesScreen();
    }

    if (_selectedPageIndex == 2) {
      activePage = PedalScreeen();
    }

    if (_selectedPageIndex == 3) {
      activePage = Goal30Screen();
    }
    if (_selectedPageIndex == 4) {
      activePage = ProfileScreen(
        email: widget.email,
      );
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        onTap: selectedPage,
        currentIndex: _selectedPageIndex,
        fixedColor: const Color(0x3ffff0000),
        items: [
          if (_selectedPageIndex == 0)
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Community.png',
                height: 30,
                width: 30,
                color: const Color(0x3ffff0000),
              ),
              label: 'Community',
              backgroundColor: Colors.black,
            )
          else
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Community.png',
                height: 30,
                width: 30,
              ),
              label: 'Community',
              backgroundColor: Colors.black,
            ),
          if (_selectedPageIndex == 1)
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Rides.png',
                height: 30,
                width: 30,
                color: const Color(0x3ffff0000),
              ),
              label: 'Rides',
              backgroundColor: Colors.black,
            )
          else
            BottomNavigationBarItem(
              icon:
                  Image.asset('assets/images/Rides.png', height: 30, width: 30),
              label: 'Rides',
              backgroundColor: Colors.black,
            ),
          if (_selectedPageIndex == 2)
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Pedal.png',
                height: 30,
                width: 30,
                color: const Color(0x3ffff0000),
              ),
              label: 'Pedal',
              backgroundColor: Colors.black,
            )
          else
            BottomNavigationBarItem(
              icon:
                  Image.asset('assets/images/Pedal.png', height: 30, width: 30),
              label: 'Pedal',
              backgroundColor: Colors.black,
            ),
          if (_selectedPageIndex == 3)
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Goal30.png',
                height: 30,
                width: 30,
                color: const Color(0x3ffff0000),
              ),
              label: 'Goal 30',
              backgroundColor: Colors.black,
            )
          else
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/Goal30.png',
                  height: 30, width: 30),
              label: 'Goal 30',
              backgroundColor: Colors.black,
            ),
          if (_selectedPageIndex == 4)
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Profile.png',
                height: 30,
                width: 30,
                color: const Color(0x3ffff0000),
              ),
              label: 'You',
              backgroundColor: Colors.black,
            )
          else
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Profile.png',
                height: 30,
                width: 30,
              ),
              label: 'You',
              backgroundColor: Colors.black,
            ),
        ],
      ),
    );
  }
}
