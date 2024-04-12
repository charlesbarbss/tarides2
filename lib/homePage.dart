import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tarides/BottomNav/Goal30Screen.dart';
import 'package:tarides/BottomNav/pedalScreen.dart';
import 'package:tarides/BottomNav/preridesScreen.dart';
import 'package:tarides/BottomNav/profileScreen.dart';
import 'package:tarides/Controller/userController.dart';

import 'BottomNav/communityScreeen.dart';

int selectedPageIndex = 0;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.email, this.index = 0});
  final String email;
  final int? index;

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  UserController userController = UserController();

  @override
  void initState() {
    determinePosition();
    super.initState();

    userController.getUser(widget.email);
  }

  void selectedPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
    print(selectedPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CommunityScreen(
      email: widget.email,
    );

    if (selectedPageIndex == 1) {
      activePage = const PreRidesScreen();
    }

    if (selectedPageIndex == 2) {
      activePage = PedalScreeen(
        email: widget.email,
      );
    }

    if (selectedPageIndex == 3) {
      activePage = const Goal30Screen();
    }
    if (selectedPageIndex == 4) {
      activePage = ProfileScreen(
        index: widget.index,
        email: widget.email,
      );
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        onTap: selectedPage,
        currentIndex: selectedPageIndex,
        fixedColor: const Color(0x3ffff0000),
        items: [
          if (selectedPageIndex == 0)
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
          if (selectedPageIndex == 1)
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
          if (selectedPageIndex == 2)
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
          if (selectedPageIndex == 3)
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
          if (selectedPageIndex == 4)
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

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
