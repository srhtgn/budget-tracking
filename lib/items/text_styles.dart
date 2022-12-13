import 'package:flutter/material.dart';
import 'package:gelirgidertakip/items/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  final TextStyle typeTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(fontWeight: FontWeight.bold));
  final TextStyle valueTextStyle = TextStyle(fontStyle: FontStyle.italic);
  final TextStyle incomeTitleTextStyle = TextStyle(color: ColorsItems().myBlue,fontSize: 20);
  final TextStyle expenseTitleTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(color: ColorsItems().myPurple,fontSize: 20));
  final TextStyle whiteTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(color: Colors.white));
  final TextStyle loginPageTextFieldStyle = GoogleFonts.mavenPro(textStyle: TextStyle(color: Colors.black));
  final TextStyle incomeTextStyles = GoogleFonts.mavenPro(textStyle: TextStyle(color: ColorsItems().myBlue));
  final TextStyle expenseTextStyles = GoogleFonts.mavenPro(textStyle: TextStyle(color: ColorsItems().myPurple));
  final TextStyle incomeCategoryButtonTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(color: ColorsItems().myBlue));
  final TextStyle expenseCategoryButtonTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(color: ColorsItems().myPurple));
  final TextStyle categoryTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(fontWeight: FontWeight.bold));
  final TextStyle dataInputButtonTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),);
  final TextStyle monthMenuTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(fontSize: 15));
  final TextStyle yearMenuTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(fontSize: 15));
  final TextStyle themeTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
  final TextStyle mainPageTitleTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
  final TextStyle mainPageSubtitleTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(fontSize: 10,fontStyle: FontStyle.italic));
  final TextStyle alertDialogNotesTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
  final TextStyle alertDialogDeleteTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(color: ColorsItems().myBlue, fontWeight: FontWeight.bold));
  final TextStyle statisticTitlesTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24));
  final TextStyle deleteQuestionTextStyle = GoogleFonts.mavenPro(textStyle: TextStyle(fontSize: 18));
}