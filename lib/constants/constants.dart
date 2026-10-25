import 'package:cresentshieldinsurance/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../component/snack/snack_abr.dart';
import 'colors.dart';

class AppConstant {
  static const fill = "Please fill in the required fields";
}

InputDecoration dropDownDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: greyStyle(14, FontWeight.w500),
    filled: true,
    fillColor: const Color(0xffF8FAF9),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: mainColor, width: 1.3),
    ),
  );
}

InputDecoration dropDownFieldDecoration(String title) {
  return InputDecoration(
    filled: true,
    hintText: title,
    labelText: title,
    hintStyle: greyStyle(14, FontWeight.w500),
    labelStyle: greyStyle(14, FontWeight.w400),
    floatingLabelStyle: mainStyle(12, FontWeight.w700),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: white),
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: white),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: white),
      borderRadius: BorderRadius.circular(12),
    ),
    fillColor: Colors.black12.withOpacity(0.03),
  );
}

BoxDecoration gradientDecoration() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [mainColor, mainColor],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(60),
      bottomRight: Radius.circular(60),
    ),
  );
}

void launchMyURL(BuildContext context, String url) async {
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    showFloatingFlushBar(context, "Could not launch");
  }
}
