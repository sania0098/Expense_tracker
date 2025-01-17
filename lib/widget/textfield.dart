import 'package:budget_tracker/utils/color.dart';
import 'package:flutter/material.dart';

class textfield_widget extends StatelessWidget {
  const textfield_widget(
      {super.key,
      required this.Controller,
      required this.hinttext,
      required this.labeltext,
      this.keyboard});

  final TextEditingController Controller;
  final keyboard;
  final labeltext;
  final hinttext;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboard,
      controller: Controller,
      style: TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        labelText: labeltext,
        hintText: hinttext,
        filled: true,
        fillColor: Colors.white.withOpacity(.1),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 14.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: pro_color.maincolor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
