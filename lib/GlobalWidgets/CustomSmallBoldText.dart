import 'package:flutter/material.dart';

Widget CustomSmallBoldText({required String text}) {

  return Container(margin: EdgeInsets.all(10),child: Text(text,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),));
}
