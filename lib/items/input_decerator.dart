import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gelirgidertakip/items/colors.dart';
import 'package:gelirgidertakip/items/paddings.dart';
import 'package:gelirgidertakip/items/border_styles.dart';
import 'package:gelirgidertakip/items/texts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';

class InputDecerator { //Veri giriş alanları tasarımları  //Data entry fields designs
  final TextInputType textInputTypeNumber = TextInputType.number;
  final TextInputType textInputTypeEmail = TextInputType.emailAddress;
  final TextInputType textInputTypePassword = TextInputType.visiblePassword;

  final IncomeInput = InputDecoration(
    contentPadding: Paddings().paddingRightAndLeft30,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsItems().myBlue),
      borderRadius: BorderStyles().textFieldRadius,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsItems().myBlue),
      borderRadius: BorderStyles().textFieldRadius,
    ),
    suffixIcon: Icon(Icons.currency_lira, color: ColorsItems().myBlue),

    labelText: Texts.incomeExpenseTitle,
    labelStyle: GoogleFonts.mavenPro(textStyle: TextStyle(color: ColorsItems().myGreyBlue)),
    // fillColor: Colors.transparent,
    // filled: true,
  );
  final ExpenseInput = InputDecoration(
    contentPadding: Paddings().paddingRightAndLeft30,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsItems().myPurple),
      borderRadius: BorderStyles().textFieldRadius,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsItems().myPurple),
      borderRadius: BorderStyles().textFieldRadius,
    ),
    suffixIcon: Icon(Icons.currency_lira, color: ColorsItems().myPurple),
    labelText: Texts.incomeExpenseTitle,
    labelStyle: GoogleFonts.mavenPro(textStyle: TextStyle(color: ColorsItems().myGreyPurple)),
    // fillColor: Colors.transparent,
    // filled: true,
  );
  final emailtInput = InputDecoration(
    contentPadding: Paddings().paddingRightAndLeftTextFieldLogin,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsItems().myLightGrey),
      borderRadius: BorderStyles().textFieldRadius,

    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsItems().myLightGrey),
      borderRadius: BorderStyles().textFieldRadius,

    ),
    hintText: Texts.emailTitle,
    hintStyle: GoogleFonts.mavenPro(textStyle: TextStyle(color: Colors.grey)),
    icon: Icon(Icons.mail_outline, color: ColorsItems().myPink),
    fillColor: ColorsItems().myLightGrey,
    filled: true,
  );
  final passwordInput = InputDecoration(
    contentPadding: Paddings().paddingRightAndLeftTextFieldLogin,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsItems().myLightGrey),
      borderRadius: BorderStyles().textFieldRadius,

    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsItems().myLightGrey),
      borderRadius: BorderStyles().textFieldRadius,

    ),
    hintText: Texts.passwordTitle,
    hintStyle: GoogleFonts.mavenPro(textStyle: TextStyle(color: Colors.grey)),
    icon: Icon(Icons.lock_outline, color: ColorsItems().myPink),
    fillColor: ColorsItems().myLightGrey,
    filled: true,
  );
  final passwordAgainInput = InputDecoration(
    contentPadding: Paddings().paddingRightAndLeftTextFieldLogin,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsItems().myLightGrey),
      borderRadius: BorderStyles().textFieldRadius,

    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsItems().myLightGrey),
      borderRadius: BorderStyles().textFieldRadius,

    ),
    hintText: Texts.passwordAgainTitle,
    hintStyle: GoogleFonts.mavenPro(textStyle: TextStyle(color: Colors.grey)),
    icon: Icon(Icons.lock_reset, color: ColorsItems().myPink),
    fillColor: ColorsItems().myLightGrey,
    filled: true,
  );
  final incomeTypeInput = InputDecoration(
    contentPadding: Paddings()
        .paddingRightAndLeft30,
    enabledBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: ColorsItems().myBlue),
      borderRadius:
      BorderStyles().textFieldRadius,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: ColorsItems().myBlue),
      borderRadius:
      BorderStyles().textFieldRadius,
    ),
    suffixIcon: Icon(
        UniconsLine.apps,
        color: ColorsItems().myBlue),
    labelText: Texts.incomeType,
    labelStyle:
    GoogleFonts.mavenPro(textStyle: TextStyle(color: ColorsItems().myGreyBlue)),
    // fillColor: Colors.transparent,
    // filled: true,
  );
  final expenseTypeInput = InputDecoration(
    contentPadding: Paddings()
        .paddingRightAndLeft30,
    enabledBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: ColorsItems().myPurple),
      borderRadius:
      BorderStyles().textFieldRadius,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: ColorsItems().myPurple),
      borderRadius:
      BorderStyles().textFieldRadius,
    ),
    suffixIcon: Icon(
        UniconsLine.apps,
        color: ColorsItems().myPurple),
    labelText: Texts.expenseType,
    labelStyle:
    GoogleFonts.mavenPro(textStyle: TextStyle(color: ColorsItems().myGreyPurple)),
    // fillColor: Colors.transparent,
    // filled: true,
  );
  final incomeNoteInput = InputDecoration(
    contentPadding: Paddings().paddingRightAndLeft30,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsItems().myBlue),
      borderRadius: BorderStyles().textFieldRadius,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsItems().myBlue),
      borderRadius: BorderStyles().textFieldRadius,
    ),
    suffixIcon: Icon(Icons.edit_note, color: ColorsItems().myBlue),
    labelText: Texts.note,
    labelStyle: GoogleFonts.mavenPro(textStyle: TextStyle(color: ColorsItems().myGreyBlue)),
    // fillColor: Colors.transparent,
    // filled: true,
  );
  final expenseNoteInput = InputDecoration(
    contentPadding: Paddings().paddingRightAndLeft30,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsItems().myPurple),
      borderRadius: BorderStyles().textFieldRadius,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsItems().myPurple),
      borderRadius: BorderStyles().textFieldRadius,
    ),
    suffixIcon: Icon(Icons.edit_note, color: ColorsItems().myPurple),
    labelText: Texts.note,
    labelStyle: GoogleFonts.mavenPro(textStyle: TextStyle(color: ColorsItems().myGreyPurple)),
    // fillColor: Colors.transparent,
    // filled: true,
  );
}