import 'package:flutter/material.dart';

Widget CustomSmallText(
    {required String text,
    FontWeight? fontWeight,
    double? fontSize,
    Color? Color}) {
  return Text(
    text,
    style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: fontSize??15.0,
        color: Color ?? Colors.black),
  );
}