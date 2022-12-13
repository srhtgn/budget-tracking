import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gelirgidertakip/items/colors.dart';
import 'package:gelirgidertakip/items/image_items.dart';
import 'package:gelirgidertakip/items/input_decerator.dart';
import 'package:gelirgidertakip/items/sized_boxes.dart';
import 'package:gelirgidertakip/items/utils.dart';
import 'package:gelirgidertakip/pages/home.dart';
import 'package:gelirgidertakip/pages/login_page.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late var formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  TextEditingController passwordResetEmailController = TextEditingController();

  @override
  void passwordResetEmailControllerDispose(){
    passwordResetEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(direction: Axis.vertical, children: [
        Expanded(
            flex: 4,
            child: Container(

                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                            color: ColorsItems().myLightGrey,
                            child: Center(
                              child: PngImage(
                                  name: ImageItems().hesabinibilLogo720x125),
                            ))),
                    Container(
                      decoration: BoxDecoration(
                          color: ColorsItems().myLightGrey,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(50))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 105, right: 105),
                        child: Column(
                          children: [
                            SizedBoxesHeight().customSizedBox20(),
                            Text('   Şifreyi Sıfırla   ',
                              style: GoogleFonts.mavenPro(textStyle: TextStyle(fontSize: 20, color: ColorsItems().myPink))),
                            SizedBoxesHeight().customSizedBox5(),
                            Container(
                              height: 3,
                              color: ColorsItems().myOrange,
                            ),
                          ],
                        )
                      ),
                    ),
                  ],
                ))),
        Expanded(
          flex: 6,
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Spacer(
                      flex: 5,
                    ),
                    TextFormField(
                      cursorColor: ColorsItems().myOrange,
                      style: TextStyle(color: Colors.black),
                      controller: passwordResetEmailController,
                      keyboardType: InputDecerator().textInputTypeEmail,
                      decoration: InputDecerator().emailtInput,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                      email != null && ! EmailValidator.validate(email)
                          ? 'Lütfen geçerli bir e-posta adresi giriniz' : null,
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    MaterialButton(
                      height: 60,
                      shape: StadiumBorder(),
                      color: ColorsItems().myOrange,
                      onPressed: (){
                        resetPassword();
                        Utils.showSnackBar('Sıfırlama E-Postası Gönderildi');
                      },
                      child: Center(
                        child: Text(
                          'Sıfırlama E-Postası Gönder',
                          style: GoogleFonts.mavenPro(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    TextButton(onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (contex) => LoginPage())); //Giriş sayfasına dön  //Return to login page
                    }, child: Text('Giriş sayfasına dön', style: GoogleFonts.mavenPro(
                            textStyle: TextStyle(
                                color: ColorsItems().myOrange))
                    )),
                    Spacer(
                      flex: 10,
                    ),
                  ],
                ),
              )
          ),
        ),
      ]),
    );
  }
  Future resetPassword() async{

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator(color: ColorsItems().myOrange)));

    try{
      await _auth.sendPasswordResetEmail(email: passwordResetEmailController.text.trim());
      Navigator.of(context).push(MaterialPageRoute(builder: (contex) => LoginPage())); //Giriş sayfasına dön  //Return to login page
      Utils.showSnackBar('Sıfırlama E-Postası Gönderildi');
    }on FirebaseAuthException catch (e){
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}