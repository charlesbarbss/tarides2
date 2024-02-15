import 'package:flutter/material.dart';
import 'package:tarides/widgets/button_widget.dart';
import 'package:tarides/widgets/text_widget.dart';

class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  final searchController = TextEditingController();
  String nameSearched = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Rides',
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'Bold',
                  ),
                  Container(
                    width: 75,
                    height: 25,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.amber,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: TextWidget(
                        text: 'Race Log',
                        fontSize: 12,
                        color: Colors.white,
                        fontFamily: 'Bold',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(100)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Regular',
                        fontSize: 14),
                    onChanged: (value) {
                      setState(() {
                        nameSearched = value;
                      });
                    },
                    decoration: const InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            fontFamily: 'QRegular', color: Colors.white),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        )),
                    controller: searchController,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextWidget(
                text: 'Your Team',
                fontSize: 14,
                color: Colors.white,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.brown[100]!.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'OCTO CIRCUIT CLUB',
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Bold',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/Ellipse 1849.png',
                            height: 75,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: 'Matt Snipe',
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'Bold',
                              ),
                              TextWidget(
                                text: '@sniperuuu',
                                fontSize: 12,
                                color: Colors.grey,
                                fontFamily: 'Regular',
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextWidget(
                text: 'Enemy Team',
                fontSize: 14,
                color: Colors.white,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.brown[100]!.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'DEW LITTLE CLUB',
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Bold',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/Ellipse 1849 (1).png',
                            height: 75,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: 'Jack Hurr',
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'Bold',
                              ),
                              TextWidget(
                                text: '@hurray',
                                fontSize: 12,
                                color: Colors.grey,
                                fontFamily: 'Regular',
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              Align(
                alignment: Alignment.bottomCenter,
                child: ButtonWidget(
                  radius: 15,
                  width: double.infinity,
                  color: Colors.amber,
                  label: 'Ready',
                  textColor: Colors.black,
                  onPressed: () {},
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
