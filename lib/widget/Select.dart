import 'package:flutter/material.dart';

class Select extends StatelessWidget {

  final void Function(String) onChanged;

  //FirstWidget({required this.onChanged});

  Select({required this.text, required this.options, required this.selected, required this.onChanged});
  final String text;
  var options;
  var selected;
  late final String controller;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text,style: TextStyle(fontSize: 16.0)),
        SizedBox(height: 5.0),
        Container(
          width: double.infinity,
          color: Colors.white,
          child: DropdownButton<String>(
            value: selected,
            onChanged: (String? newValue) => onChanged(newValue!),
            underline: Container(), // Remove the underline
            isExpanded: true, // Ensure the dropdown button takes the full width
            icon: Icon(Icons.arrow_drop_down), // Add your custom dropdown icon if needed
            items: options.map<DropdownMenuItem<String>>((Map<String, String> option) {
              return DropdownMenuItem<String>(
                value: option['name']!,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding if needed
                  child: Text(option['title']!),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 15.0),
      ],
    );
  }
}