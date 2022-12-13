import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gelirgidertakip/items/utils.dart';
import 'package:gelirgidertakip/pages/home.dart';
import 'package:gelirgidertakip/pages/login_page.dart';
import 'package:gelirgidertakip/theme/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'items/utils.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  //Firebase bağlantısı  //Firebase connection
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider()..initialize(),
    child: const MyApp(),
    )
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    navigatorKey: navigatorKey;
    scaffoldMessengerKey: Utils.messengerKey;
    return Consumer<ThemeProvider>(
        builder: (context,provider,child){
      return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,

        //Tema atamaları  //Theme assignments
        theme: Themes.lightTheme,
        darkTheme: Themes.darkTheme,
        themeMode: provider.themeMode,
        home: const Login(),
        //const MyHomePage(title: 'Flutter Demo Home Page'),
      );
    });

  }
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir şeyler yanlış gitti!'));
          } else if (snapshot.hasData) {
            return Home();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
