import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

 blackStyle(double size,FontWeight weight){
  return GoogleFonts.nunito(
    color: black,
    fontSize: size,
    fontWeight: weight,
  );
}
 greyStyle(double size,FontWeight weight){
  return GoogleFonts.nunito(
    color: Colors.grey,
    fontSize: size,
    fontWeight: weight,
  );
}
 whiteStyle(double size,FontWeight weight){
  return GoogleFonts.nunito(
    color: white,
    fontSize: size,
    fontWeight: weight,
  );
}
 mainStyle(double size,FontWeight weight){
  return GoogleFonts.nunito(
    color: mainColor,
    fontSize: size,
    fontWeight: weight,
  );
}
 headerStyle(Color color,double size,FontWeight weight){
  return GoogleFonts.nunito(
    color: color,
    fontSize: size,
    fontWeight: weight,
  );
}
lightBlack(double size,FontWeight weight){
  return GoogleFonts.nunito(
    color: Colors.black54,
    fontSize: size,
    fontWeight: weight,
  );
}

 customStyle(Color color,double size,FontWeight weight){
  return GoogleFonts.nunito(
    color: color,
    fontSize: size,
    fontWeight: weight,
  );
}
 myStyle(double size,FontWeight weight){
  return GoogleFonts.nunito(
    fontSize: size,
    fontWeight: weight,
  );
}
 underlineStyle(Color color,double size,FontWeight weight){
  return GoogleFonts.nunito(
    color: color,
    fontSize: size,
    fontWeight: weight,
    decoration: TextDecoration.underline,
  );
}