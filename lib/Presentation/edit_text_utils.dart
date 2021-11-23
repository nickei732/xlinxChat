import 'package:flutter/material.dart';
class EditTextUtils {
  TextFormField getCustomEditTextField(
      {String hintValue = "",
         TextEditingController controller,
        EdgeInsetsGeometry contentPadding =const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
             Widget prefixWidget,
         Widget suffixWidget ,
         TextStyle style,
        bool obscureValue = false,
        int maxLines = 1,
       TextInputType keyboardType}) {
    return  TextFormField(
      maxLines: maxLines,
      keyboardType:keyboardType,
      controller: controller,
      decoration: InputDecoration(
        fillColor: Color(0xffE5E5E5),
        filled: true,
        prefixIcon: prefixWidget,

        suffixIcon: suffixWidget,
        contentPadding:contentPadding,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 5.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color:Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color:Colors.transparent),
        ),
        hintText: hintValue,
        hintStyle: style,
      ),
      style: style,
      obscureText: obscureValue,

    );
  }
}
