import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  Color boxColor,iconColor;
  MyBackButton({Key? key,required this.iconColor,required this.boxColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> Navigator.pop(context),
      child: Container(
        height: 32,
        width: 32,
        padding: const EdgeInsets.only(left: 5),
        decoration:  BoxDecoration(
          color: boxColor,
          shape: BoxShape.circle,
        ),
        child:  Center(
          child: Icon(Icons.arrow_back_ios,color: iconColor,size: 18,),
        ),
      ),
    );
  }
}
