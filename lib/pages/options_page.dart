import 'package:flutter/material.dart';
import 'package:gelirgidertakip/items/colors.dart';
import 'package:gelirgidertakip/items/sized_boxes.dart';
import 'package:gelirgidertakip/items/text_styles.dart';
import 'package:gelirgidertakip/theme/themes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SEÇENEKLER',
          style: GoogleFonts.mavenPro(
              textStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: ColorsItems().myOrange,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                children: [
                  Card(
                    color: ColorsItems().myGrey,
                    child: Row(
                      children: [
                        SizedBoxesWidth().customSizedBox30(),
                        Text('Tema:',
                            style: TextStyles().themeTextStyle),
                        Spacer(),
                        Consumer<ThemeProvider>(
                            builder: (context, provider, child) {
                          return DropdownButton<String>( //Tema seçme menüsü  //Theme select menu
                            value: provider.currentTheme,
                            items: [
                              DropdownMenuItem<String>(
                                  value: 'light',
                                  child: Text(
                                    'Açık',
                                    style: TextStyles().themeTextStyle,
                                  )),
                              DropdownMenuItem<String>(
                                  value: 'dark',
                                  child: Text(
                                    'Koyu',
                                    style: TextStyles().themeTextStyle,
                                  )),
                              DropdownMenuItem<String>(
                                  value: 'system',
                                  child: Text(
                                    'Sistem',
                                    style: TextStyles().themeTextStyle,
                                  )),
                            ],
                            onChanged: (String? value) {
                              provider.changeTheme(value ?? 'system');
                            },
                          );
                        }),
                        SizedBoxesWidth().customSizedBox30(),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}