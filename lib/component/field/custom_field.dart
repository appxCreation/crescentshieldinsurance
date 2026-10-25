import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/styles.dart';

class CustomField extends StatelessWidget {
  String title,subTitle;
  TextEditingController controller;
  TextInputType? type;
  bool? isOptional;
  CustomField({super.key,
    required this.controller,
    required this.title,
    required this.subTitle,
    this.type,
    this.isOptional,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fieldLabel(title, required: isOptional != true),
          TextFormField(
            keyboardType: type ?? TextInputType.text,
            controller: controller,
            style: blackStyle(
              14,
              FontWeight.w600,
            ),
            decoration: decoration(
              subTitle,
              icon: Icons.person_outline,
            ),
            validator: (value) {
              if (isOptional != true &&
                  (value == null || value.trim().isEmpty)) {
                return 'Please fill this required field';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  InputDecoration decoration(
      String hint, {
        IconData? icon,
      }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: greyStyle(
        14,
        FontWeight.w500,
      ),
      prefixIcon: icon == null
          ? null
          : Icon(
        icon,
        color: Colors.grey.shade500,
        size: 21,
      ),
      filled: true,
      fillColor: const Color(0xffF8FAF9),
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(13),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: mainColor,
          width: 1.3,
        ),
      ),
    );
  }

  Widget fieldLabel(String text, {required bool required}) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: RichText(
        text: TextSpan(
          text: text,
          style: blackStyle(
            14,
            FontWeight.w800,
          ),
          children: required
              ? const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ]
              : const [],
        ),
      ),
    );
  }

}
