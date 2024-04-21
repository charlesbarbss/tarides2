import 'package:flutter/material.dart';
import 'package:tarides/BottomNav/NewRides/homePageRides.dart';
import 'package:tarides/BottomNav/goal30Screen.dart';
import 'package:tarides/BottomNav/pedalScreen.dart';
import 'package:tarides/BottomNav/preridesScreen.dart';
import 'package:tarides/BottomNav/profileScreen.dart';
import 'package:tarides/Controller/userController.dart';
import 'package:location/location.dart';

import 'BottomNav/communityScreeen.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.email,
    required this.homePageIndex,
  });
  final String email;
  final int homePageIndex;

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late int _selectedPageIndex;
  late bool _serviceEnabled;
  Location location = new Location();
  late PermissionStatus _permissionGranted;
  LocationData? _locationData;

  UserController userController = UserController();

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = widget.homePageIndex;
    userController.getUser(widget.email);

    initializeLocation();
  }

  void initializeLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      _locationData = _locationData;
    });
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
      activePage = AnimatedBuilder(
        animation: userController,
        builder: (context, snapshot) {
          if (userController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return HomePageRides(
            locationUser: _locationData!,
            email: widget.email,
            user: userController.user,
          );
        },
      );
    }

    if (_selectedPageIndex == 2) {
      activePage = _locationData != null
          ? AnimatedBuilder(
              animation: userController,
              builder: (context, snapshot) {
                if (userController.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return PedalScreen(
                  email: widget.email,
                  location: _locationData!,
                );
              })
          : const Center(
              child:
                  CircularProgressIndicator()); // Replace this with your placeholder widget
    }

    if (_selectedPageIndex == 3) {
      activePage = AnimatedBuilder(
          animation: userController,
          builder: (context, snapshot) {
            if (userController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Goal30Screen(
              locationData: _locationData,
              email: widget.email,
              user: userController.user,
            );
          });
    }

    if (_selectedPageIndex == 4) {
      activePage = AnimatedBuilder(
          animation: userController,
          builder: (context, snapshot) {
            if (userController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ProfileScreen(
              user: userController.user,
              email: widget.email,
            );
          });
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
