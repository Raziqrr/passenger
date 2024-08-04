/// @Author: Raziqrr rzqrdzn03@gmail.com
/// @Date: 2024-08-03 17:13:45
/// @LastEditors: Raziqrr rzqrdzn03@gmail.com
/// @LastEditTime: 2024-08-03 22:46:03
/// @FilePath: lib/widgets/SecondaryButton.dart
/// @Description: 这是默认设置,可以在设置》工具》File Description中进行配置

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Secondarybutton extends StatelessWidget {
  const Secondarybutton(
      {super.key, required this.onPressed, required this.text});
  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey),
            backgroundColor: Colors.transparent),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.montserrat(
              color: Colors.grey, fontWeight: FontWeight.bold),
        ));
  }
}
