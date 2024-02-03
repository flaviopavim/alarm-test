import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  Input({required this.text, required this.controller});
  final String text;
  final TextEditingController controller;
  @override
  _Input createState() => _Input();
}

class _Input extends State<Input> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.text,style: TextStyle(fontSize: 16.0)),
        Container(height: 5.0),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            //borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0,right: 15.0),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                //hintText: 'Username',
              ),
              onChanged: (value) {

              },
              onSubmitted: (value) async {

              },
              controller: widget.controller,
            ),
          ),
        ),
        Container(height: 15.0),
      ],
    );
  }
}