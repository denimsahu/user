import 'package:flutter/material.dart';

Widget CustomBigText(
    {required String text,
    FontWeight? fontWeight,
    double? fontSize,
    Color? Color}) {
  return Container(
    margin: EdgeInsets.all(10),
    child: Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? 28.0,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: Color??Colors.black
      ),
    ),
  );
}