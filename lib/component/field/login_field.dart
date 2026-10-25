import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../constants/styles.dart';


class LogInField extends StatelessWidget {
  String title;
  TextEditingController controller;
  TextInputType? type;
  Widget? prefix,suffix;
  Function(String)? fun;
  int? maxLines,length;
  bool? obsecure;

  LogInField({Key? key,
    required this.controller,
    this.obsecure,
    required this.title,
    this.type,
    this.prefix,
    this.suffix,
    this.maxLines,
    this.length,
    this.fun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
      maxLines == null ?
      55 : null,
      padding: EdgeInsets.only(left: prefix == null ? 8 : 2,right: 5),
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Colors.black12.withOpacity(0.04),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        cursorColor: mainColor,
        maxLength: length,
        obscureText: obsecure ?? false,
        maxLines: maxLines ?? 1,
        keyboardType: type ?? TextInputType.text,
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        controller: controller,
        onChanged: fun,
        decoration: InputDecoration(
          prefixIcon: prefix,
          suffixIcon: suffix,
          hintText: title,
          contentPadding: EdgeInsets.only(top:
          suffix == null && prefix == null ? 10 :
          suffix == null ? 15 : 15),
          hintStyle: myStyle(13, FontWeight.w500),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
