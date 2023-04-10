import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class MyTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      primarySwatch: Colors.deepPurple,
      fontFamily: GoogleFonts.poppins().fontFamily,
      cardColor: Colors.white,
      canvasColor: creamColor,
      backgroundColor: Colors.white,
      buttonColor: darkPurple,
      accentColor: darkGreyColor,
      textTheme: TextTheme(headlineSmall: TextStyle(color: darkGreyColor)),
      appBarTheme: AppBarTheme(
        color: Colors.purple,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ));

  static ThemeData darkTheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.poppins().fontFamily,
        cardColor: Colors.black,
        backgroundColor: Color.fromARGB(255, 43, 43, 43),
        canvasColor: darkGreyColor,
        buttonColor: darkPurple,
        accentColor: Colors.white,
        textTheme: TextTheme(headlineSmall: TextStyle(color: creamColor)),
        appBarTheme: AppBarTheme(
          color: Colors.purple,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          systemOverlayStyle: SystemUiOverlayStyle(
            //<-- SEE HERE
            // Status bar color
            statusBarColor: darkPurple,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),
      );

  //Colors
  static Color darkPurple = Colors.purple;
  static Color creamColor = Color(0xfff5f5f5);
  static Color darkGreyColor = Color.fromARGB(255, 51, 51, 51);
 // static Color lightBluishColor = Vx.indigo500;
}
