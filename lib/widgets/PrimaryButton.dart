/// @Author: Raziqrr rzqrdzn03@gmail.com
/// @Date: 2024-08-03 17:13:27
/// @LastEditors: Raziqrr rzqrdzn03@gmail.com
/// @LastEditTime: 2024-08-03 18:21:11
/// @FilePath: lib/widgets/PrimaryButton.dart
/// @Description: 这是默认设置,可以在设置》工具》File Description中进行配置

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Primarybutton extends StatelessWidget {
  const Primarybutton({super.key, required this.onPressed, required this.text});
  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: CupertinoColors.systemGreen),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.montserrat(
              color: Colors.white, fontWeight: FontWeight.bold),
        ));
  }
}
