import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/styles.dart';

class TapMeBox extends StatelessWidget {
  String title;
  TextStyle? style;
  Color? color;
  VoidCallback callback;
  double? height,width,round;
  TapMeBox({Key? key,
    required this.callback,
     this.color,
     this.height,
     this.width,
    required this.title,
     this.round,
     this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        height: height ?? Get.height * 0.06,
        width: width ?? Get.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
          gradient: const LinearGradient(
            colors: [
              Color(0xff0b8f4d),
              Color(0xff064d28),
            ],
          ),
          // gradient: const LinearGradient(
          //   colors: [Color(0xff00D100), mainColor],
          // ),
          borderRadius: BorderRadius.circular(round ?? 10),
        ),
        child: Center(
          child: Text(title,style: style ?? customStyle(white, 16, FontWeight.w600)),
        ),
      ),
    );
  }
}
class CustomBox extends StatelessWidget {
  String title,img;
  TextStyle? style;
  Color? color;
  VoidCallback callback;
  double? height,width,round;
  CustomBox({Key? key,
    required this.callback,
    required this.img,
     this.color,
     this.height,
     this.width,
    required this.title,
     this.round,
     this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        height: height ?? Get.height * 0.06,
        width: width ?? Get.width,
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(round ?? 15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(img,height: 25,color: white),
            SizedBox(width: 10),
            Text(title,style: style ?? customStyle(white, 16, FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}

