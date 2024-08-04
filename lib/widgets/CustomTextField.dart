/// @Author: Raziqrr rzqrdzn03@gmail.com
/// @Date: 2024-08-03 17:12:59
/// @LastEditors: Raziqrr rzqrdzn03@gmail.com
/// @LastEditTime: 2024-08-03 18:14:40
/// @FilePath: lib/widgets/CustomTextField.dart
/// @Description: 这是默认设置,可以在设置》工具》File Description中进行配置

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.onChanged,
      this.inputFormatters = const [],
      this.obsureText = false,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1,
      this.maxLength = 128,
      required this.hintText,
      this.suffixIcon = const SizedBox(),
      required this.errorText});
  final TextEditingController controller;
  final Function(String?) onChanged;
  final List<TextInputFormatter> inputFormatters;
  final bool obsureText;
  final TextInputType keyboardType;
  final int maxLines;
  final int maxLength;
  final String hintText;
  final Widget suffixIcon;
  final String errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        obscureText: obsureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          errorText: errorText == "" ? null : errorText,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            gapPadding: 0,
            borderSide: BorderSide(color: Colors.grey, width: 3),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            gapPadding: 0,
            borderSide: BorderSide(color: Colors.grey, width: 3),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            gapPadding: 0,
            borderSide: BorderSide(color: Colors.blue, width: 4),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            gapPadding: 0,
            borderSide: BorderSide(color: Colors.red, width: 3),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            gapPadding: 0,
            borderSide: BorderSide(color: Colors.red, width: 3),
            borderRadius: BorderRadius.circular(10),
          ),
        ));
  }
}
