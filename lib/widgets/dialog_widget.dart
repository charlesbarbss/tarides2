import 'package:flutter/material.dart';
import 'package:tarides/widgets/button_widget.dart';
import 'package:tarides/widgets/text_widget.dart';

class DialogWidget extends StatefulWidget {
  String image;
  String title;
  String caption;

  VoidCallback onpressed;

  DialogWidget(
      {super.key,
      required this.image,
      required this.title,
      required this.caption,
      required this.onpressed});

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 275,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.image,
              height: 100,
            ),
            const SizedBox(
              height: 10,
            ),
            TextWidget(
              text: widget.title,
              fontSize: 24,
              color: Colors.amber,
              fontFamily: 'Bold',
            ),
            const SizedBox(
              height: 10,
            ),
            TextWidget(
              text: widget.caption,
              fontSize: 18,
              color: Colors.black,
              fontFamily: 'Bold',
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonWidget(
              width: 250,
              radius: 15,
              color: Colors.amber,
              label: 'Return to lobby',
              onPressed: widget.onpressed,
            ),
          ],
        ),
      ),
    );
  }
}
