import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  const Textfield(
      {super.key, required this.textController, required this.hintText, required this.validatitonText});

  final TextEditingController textController;
  final String hintText;
  final String validatitonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: TextFormField(

        controller: textController,
        decoration: InputDecoration.collapsed(
          hintText: hintText,
        ),
        validator:  (value) => value!.isNotEmpty ? null : validatitonText,

      ),
    );
  }
}
