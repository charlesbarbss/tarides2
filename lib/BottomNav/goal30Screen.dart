import 'package:flutter/material.dart';

class Goal30Screen extends StatefulWidget {
  const Goal30Screen({super.key});

  @override
  State<Goal30Screen> createState() => _Goal30ScreenState();
}

class _Goal30ScreenState extends State<Goal30Screen> {
  final TextEditingController firstPinPoint = TextEditingController();
  final TextEditingController secondPinPoint = TextEditingController();
  final List<String> entries = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30'
  ]; // Replace with your data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Goal 30'), backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            height: 150, // Specify the height of the ListView
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 100,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  color: Colors.amber[600],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Day',
                          style: TextStyle(color: Colors.white, fontSize: 25)),
                      SizedBox(height: 10),
                      Text(entries[index],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Remark:',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      Icon(true ? Icons.check : Icons.close,
                          color: true ? Colors.lightGreenAccent : Colors.red),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Container(
            color: Color(0x3FFF454545),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "Today's Goal: 1km",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: firstPinPoint,
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
                    labelText: 'Enter your first value',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: secondPinPoint,
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
                    labelText: 'Enter your first value',
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Proceed',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
