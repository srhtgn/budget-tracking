import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gelirgidertakip/items/image_items.dart';
import 'package:gelirgidertakip/items/paddings.dart';
import 'package:gelirgidertakip/items/sized_boxes.dart';
import 'package:gelirgidertakip/items/text_styles.dart';
import 'package:gelirgidertakip/items/utils.dart';
import 'package:gelirgidertakip/main.dart';
import 'package:gelirgidertakip/pages/home.dart';
import 'package:gelirgidertakip/pages/main_page.dart';
import 'package:gelirgidertakip/pages/password_reset_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../items/colors.dart';
import '../items/input_decerator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin
{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late var formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailRecordController = TextEditingController();
  TextEditingController passwordRecordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  late TabController tabController;

  //Veri giriş denetleyicileri  //Data input controllers
  @override
  void emailControllerDispose(){
    emailController.dispose();
    super.dispose();
  }
  @override
  void passwordControllerDispose(){
    passwordController.dispose();
    super.dispose();
  }
  @override
  void emailRecordControllerDispose(){
    emailRecordController.dispose();
    super.dispose();
  }
  @override
  void passwordRecordControllerDispose(){
    passwordRecordController.dispose();
    super.dispose();
  }
  @override
  void passwordAgainControllerDispose(){
    passwordAgainController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference recordRef = _firestore.collection('records');

    return DefaultTabController( //Giriş yap ve üye ol ekranları barı  //Log in and sign up screens bar
        length: 2,
        child: Scaffold(
          body: Flex(
              direction: Axis.vertical,
              children: [
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
                        padding: Paddings().paddingRightAndLeft30,
                        child: TabBar(
                          controller: tabController,
                          labelColor: ColorsItems().myPink,
                          labelStyle: GoogleFonts.mavenPro(
                              textStyle: TextStyle(fontSize: 20)),
                          indicatorColor: ColorsItems().myOrange,
                          indicatorWeight: 3,
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: [
                            Tab(text: "   Giriş Yap   "),
                            Tab(text: "   Üye Ol   ")
                          ],
                        ),
                      ),
                    )
                  ],
                ))),
            Expanded(
              flex: 6,
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(), //Kaydırma kapalı  //Scrolling off
                children: [
                  SignInPage(),
                  SignUpPage(),
                ],
              ),
            ),
          ]),
        ));
  }

  Padding SignInPage() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: formKey = GlobalKey<FormState>(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Spacer(
              flex: 1,
            ),
            TextFormField(
              cursorColor: ColorsItems().myOrange,
              style: TextStyles().loginPageTextFieldStyle,
              controller: emailController,
              keyboardType: InputDecerator().textInputTypeEmail,
              decoration: InputDecerator().emailtInput,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
              email != null && ! EmailValidator.validate(email)
                  ? 'Lütfen geçerli bir e-posta adresi giriniz' : null,
            ),
            SizedBoxesHeight().customSizedBox10(),
            TextFormField(
              cursorColor: ColorsItems().myOrange,
              style: TextStyles().loginPageTextFieldStyle,
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecerator().passwordInput,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value){
                if(value != null && value.length < 6){
                  return 'Lütfen en az 6 karakterli bir parola giriniz';
                } else {
                  return null;
                }
              },
            ),
            TextButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (contex) => PasswordResetPage()));  //Şifre sıfırlama ekranına geçiş  // Switch to the password reset screen
            }, child: Text(
                'Şifrenizi mi unuttunuz?',
                style: GoogleFonts.mavenPro(
                  textStyle: TextStyle(
                      color: ColorsItems().myOrange)))),
            Spacer(
              flex: 1,
            ),
            MaterialButton(
              height: 60,
              shape: StadiumBorder(),
              color: ColorsItems().myOrange,
              onPressed: () {
                final isValidForm = formKey.currentState!.validate();
                if(isValidForm){
                  signIn();
                  // emailController.clear();
                  // passwordController.clear();
                }
              },
              child: Center(
                child: Text(
                  'Giriş Yap',
                  style: GoogleFonts.mavenPro(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Üye değil misiniz?', style: GoogleFonts.mavenPro(
                    textStyle: TextStyle(color: Colors.grey))),
                TextButton(
                    onPressed: () {
                      tabController.animateTo(1);
                    },
                    child: Text('Üye Ol',
                        style: GoogleFonts.mavenPro(
                            textStyle: TextStyle(color: ColorsItems().myOrange))))
              ],
            ),
          ],
        ),
      )
    );
  }

  Padding SignUpPage() {
    return
      Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
          children: [
            Spacer(
              flex: 1,
            ),
            TextFormField(
              cursorColor: ColorsItems().myOrange,
              style: TextStyles().loginPageTextFieldStyle,
              controller: emailRecordController,
              keyboardType: InputDecerator().textInputTypeEmail,
              decoration: InputDecerator().emailtInput,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
              email != null && ! EmailValidator.validate(email)
                  ? 'Lütfen geçerli bir e-posta adresi giriniz' : null,
            ),
            SizedBoxesHeight().customSizedBox10(),
            TextFormField(
              cursorColor: ColorsItems().myOrange,
              style: TextStyles().loginPageTextFieldStyle,
              controller: passwordRecordController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecerator().passwordInput,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value){
                if(value != null && value.length < 6){
                  return 'Lütfen en az 6 karakterli bir parola giriniz';
                } else {
                  return null;
                }
              },
            ),
            SizedBoxesHeight().customSizedBox10(),
            TextFormField(
              cursorColor: ColorsItems().myOrange,
              style: TextStyles().loginPageTextFieldStyle,
              controller: passwordAgainController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecerator().passwordAgainInput,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value){
                if(value != null && value.length < 6){
                  return 'Lütfen şifrenizi tekrar giriniz';
                } else {
                  return null;
                }
              },
            ),
            Spacer(
              flex: 3,
            ),
            MaterialButton(
              height: 60,
              shape: StadiumBorder(),
              color: ColorsItems().myOrange,
              onPressed: () {
                if (passwordRecordController.text ==
                    passwordAgainController.text) {
                  signUp();
                  emailController = emailRecordController;
                  passwordController = passwordRecordController;

                } else {
                  passwordRecordController.clear();
                  passwordAgainController.clear();
                }
              },
              child: Center(
                child: Text(
                  'Üye Ol',
                  style: GoogleFonts.mavenPro(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Üye misiniz?', style: GoogleFonts.mavenPro(
                    textStyle: TextStyle(color: Colors.grey))),
                TextButton(
                    onPressed: () {
                      tabController.animateTo(0);
                    },
                    child: Text('Giriş Yap',
                        style: GoogleFonts.mavenPro(
                            textStyle: TextStyle(color: ColorsItems().myOrange))))
              ],
            ),
          ],
        ),
    );
  }

  Future<void> signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator(color: ColorsItems().myOrange)));

    try{
      await _auth
          .createUserWithEmailAndPassword(
          email: emailRecordController.text.trim(),
          password: passwordRecordController.text.trim());

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const Home()), //Ana ekrana geç  //Switch to main screen
              (Route<dynamic> route) => false);
    }on FirebaseAuthException catch (e){
      print(e);

      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<void> signIn() async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator(color: ColorsItems().myOrange)));
    try{
      await _auth
          .signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text)
          .then((user) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const Home()), //Ana ekrana geç  //Switch to main screen
                (Route<dynamic> route) => false);
      });
    } on FirebaseAuthException catch(e){
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}