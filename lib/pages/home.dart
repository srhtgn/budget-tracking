import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gelirgidertakip/items/colors.dart';
import 'package:gelirgidertakip/items/paddings.dart';
import 'package:gelirgidertakip/items/sized_boxes.dart';
import 'package:gelirgidertakip/items/dimens.dart';
import 'package:gelirgidertakip/pages/login_page.dart';
import 'package:gelirgidertakip/pages/main_page.dart';
import 'package:gelirgidertakip/pages/statistics_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'options_page.dart';
import 'package:unicons/unicons.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final key = GlobalKey();

  final DateTime date = DateTime.now();


  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;

  FocusNode focusNodeTextFieldOne = FocusNode();

  int currentTab = 0;
  final List<Widget> screens = [ //Bottom navigation bar sayfaları //Bottom navigation bar pages
    MainPage(),
    OptionsPage(),
    StatisticsPage(),
  ];

  Widget currentScreen = MainPage();

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          child: Icon(UniconsLine.home_alt,size: Dimens().bottomBarIconSize,color: Theme.of(context).primaryColor),
          backgroundColor: ColorsItems().myPink,
          onPressed: () {
            setState(() {
              currentScreen = MainPage();
              currentTab = 0;
            });
          }),
      bottomNavigationBar: BottomAppBar(
        color: ColorsItems().myOrange,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () {
                  setState(
                    () {
                      currentScreen = OptionsPage();
                      currentTab = 1;
                    },
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(UniconsLine.setting, size: Dimens().bottomBarIconSize, color: Theme.of(context).primaryColor),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(
                    () {
                      currentScreen = StatisticsPage();
                      currentTab = 2;
                    },
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(UniconsLine.chart_growth, size: Dimens().bottomBarIconSize, color: Theme.of(context).primaryColor),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('HESABINIBİL',
            style: GoogleFonts.mavenPro(
                textStyle: TextStyle(
                    color: ColorsItems().myPink,
                    fontWeight: FontWeight.bold,
                    fontSize: 35))),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              UserAlertDialog(context);
            },
            icon:
                Icon(UniconsLine.user, size: 40),
            color: ColorsItems().myPink,
            focusColor: ColorsItems().myOrange,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Container(
            height: 5,
            color: ColorsItems().myOrange,
          ),
        ),
      ),
      body: Padding(
        padding: Paddings().paddingTop,
        child: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
      ),
    );
  }

  Future<void> UserAlertDialog(BuildContext context) async { //Kullanıcı bilgisi ve çıkış yapma penceresi  //User information and logout window
    showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          Column(
            children: [
              Column(
                children: [
                  Text('HESABIM',
                      style:
                      GoogleFonts.mavenPro(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  Text(user.email!, style: GoogleFonts.mavenPro(textStyle: TextStyle(fontSize: 16))),
                ],
              ),
              SizedBoxesHeight().customSizedBox10(),
              Container(
                height: 0.5,
                color: Colors.black,
              ),
              TextButton(
                  onPressed: () async {
                    UserLogOutAlertDialog(context);
                  },
                  child: Row(
                    children: [
                      Text('ÇIKIŞ YAP',
                          style: GoogleFonts.mavenPro(textStyle: TextStyle(color: Colors.red, fontSize: 16,fontWeight: FontWeight.bold))),
                      Spacer(),
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.red,
                      )
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }

  Future<void> UserLogOutAlertDialog(BuildContext context) async { //Çıkış yapma penceresi  //Logout window
    showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Çıkış yapmak istediğinizden emin misiniz?',
            style: GoogleFonts.mavenPro(textStyle: TextStyle(fontSize: 18))),
        actions: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(),
                    side: BorderSide(color: Colors.red)),
                onPressed: () async {
                  auth.signOut().then((value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (Route<dynamic> route) => false);
                  });
                },
                child: Text(
                  'EVET',
                  style: TextStyle(color: Colors.red),
                )),
            SizedBoxesWidth().customSizedBox10(),
            MaterialButton(
                shape: StadiumBorder(),
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'HAYIR',
                  style: TextStyle(color: Colors.white),
                )),
          ])
        ],
      ),
    );
  }
}

class PngImage extends StatelessWidget {
  const PngImage({Key? key, required this.name}) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/png/$name.png', fit: BoxFit.cover);
  }
}
