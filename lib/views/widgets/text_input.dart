import 'package:flutter/material.dart';
import 'package:tiktok/constaints.dart';

class TextInputField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final IconData icon;
  bool isObsecure;
  TextInputField(
      {Key? key,
      required this.title,
      required this.controller,
      required this.icon,
      this.isObsecure = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        prefixIcon: Icon(icon),
        labelStyle: const TextStyle(fontSize: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: kBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: kBorderColor),
        ),
      ),
      obscureText: isObsecure,
    );
  }
}
