import 'package:flutter/material.dart';

import '../../constants/colors.dart';

showDialogF(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 50,
            child: Center(
              child: Row(
                children:  [
                  const CircularProgressIndicator(
                    color: mainColor,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text("Please wait..."),
                ],
              ),
            ),
          ),
        );
      });
}
