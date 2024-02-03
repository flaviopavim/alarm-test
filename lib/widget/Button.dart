import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Text(widget.text,style: TextStyle(fontSize: 16.0)),
        Container(height: 24.0), //pra alinhar com os inputs
        //Container(height: 5.0),
        Container(
          width: double.infinity,
            height: 48.0,
            decoration: BoxDecoration(
              color: color,
              //borderRadius: BorderRadius.circular(4.0),
            ),
            child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(child: Text(text,style: const TextStyle(fontSize:16,color: Colors.white))),
        )),
        Container(height: 15.0),
      ],
    );
  }
}