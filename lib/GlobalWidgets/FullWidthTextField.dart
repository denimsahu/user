import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget FullWidthTextField({
  required BuildContext context,
  String? Function(String?)? validator,
  TextEditingController? controller,
  List<TextInputFormatter>? inputFormatters,
  InputDecoration? decoration,
  TextAlign textAlign=TextAlign.start,
  TextInputType KeyboardType=TextInputType.text,
  TextStyle? style,
}) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.9,
    child: TextFormField(
      validator: validator,
        controller: controller,
        keyboardType: KeyboardType,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: 18,
        
        ),
        decoration: InputDecoration(
          
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54),borderRadius: BorderRadius.circular(15),gapPadding: 0.0),
        ),
        inputFormatters: inputFormatters),
  );
}
