import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final Icon? icon;
  final IconButton? buttonIcon;
  final TextInputType keyboardType;
  final double horizontal;
  final double vertical;
  final int? maxLine;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.icon,
    this.buttonIcon,
    this.horizontal = 0.0,
    this.vertical = 8.0,
    this.maxLine = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: TextFormField(
        controller: controller,
        autofocus: false,
        obscureText: isPassword,
        maxLines: maxLine,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: hintText,
          prefixIcon: icon,
          suffixIcon: buttonIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
