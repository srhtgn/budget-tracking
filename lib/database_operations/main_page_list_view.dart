import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gelirgidertakip/database_operations/firebase_operations.dart';
import 'package:gelirgidertakip/items/border_styles.dart';
import 'package:gelirgidertakip/items/colors.dart';
import 'package:gelirgidertakip/items/dimens.dart';
import 'package:gelirgidertakip/items/image_items.dart';
import 'package:gelirgidertakip/items/sized_boxes.dart';
import 'package:gelirgidertakip/items/text_styles.dart';
import 'package:gelirgidertakip/pages/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MainPageListView extends StatefulWidget {
  const MainPageListView({Key? key}) : super(key: key);

  @override
  State<MainPageListView> createState() => _MainPageListViewState();
}

class _MainPageListViewState extends State<MainPageListView> {

  StatusService statusService = StatusService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  late List<DocumentSnapshot> listOfDocumentSnap;
  var instantLength;

  var dateFormat = DateFormat("dd.MM.yyyy");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder(
        stream: statusService.getInExView(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return Center(child: Text('Bir hata oluştu tekrar deneyiniz'));
          }
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: ColorsItems().myOrange));
          } else {
            if (asyncSnapshot.hasData) {
              listOfDocumentSnap = asyncSnapshot.data.docs;

              listOfDocumentSnap.length;

              if (listOfDocumentSnap.length < 5) {  //Ana ekranda görüntülenen son işlemlerin sayısı  //Number of recent transactions displayed on the home screen
                instantLength = listOfDocumentSnap.length;
              } else {
                instantLength = 5;
              }

              return ListView.builder(
                itemCount: instantLength,
                itemBuilder: (context, index) {
                  var _income = listOfDocumentSnap[index]['gelir'];
                  var _expense = listOfDocumentSnap[index]['gider'];
                  var _date = listOfDocumentSnap[index]['tarih'];
                  var _category = listOfDocumentSnap[index]['kategori'];
                  var _type = listOfDocumentSnap[index]['tip'];

                  var state;

                  if (_income != 0) { //Eğer gelir değeri sıfırdan farklı bir değerse gelir değerini göster  //Show income value if income value is non-zero
                    state = InkWell(
                        onTap: () async {
                          await IncomeAlertDialog(context, index);
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 0.5,
                              color: ColorsItems().myGrey,
                            ),
                            ListTile(
                              title: Text('${_category} (${_type})',
                                  style: TextStyles().mainPageTitleTextStyle),
                              subtitle: Text(dateFormat.format(_date.toDate()),
                                  style: TextStyles().mainPageSubtitleTextStyle),
                              leading: Container(
                                  height: Dimens().listIconSize,
                                  width: Dimens().listIconSize,
                                  alignment: Alignment.center,
                                  child: PngImage(name: ImageItems().income)),
                              trailing: Text('${_income} ₺',
                                  style: GoogleFonts.mavenPro(
                                      textStyle: TextStyle(
                                          color: ColorsItems().myBlue,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold)
                                  )),
                              //onPressed: () {},
                            ),
                          ],
                        ));
                  } else if (_expense != 0) { //Eğer gider değeri sıfırdan farklı bir değerse gider değerini göster  //Show expense value if expense value is non-zero
                    state = InkWell(
                        onTap: () async {
                          await ExpenseAlertDialog(context, index);
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 0.5,
                              color: ColorsItems().myGrey,
                            ),
                            ListTile(
                              title: Text('${_category} (${_type})',
                                  style: TextStyles().mainPageTitleTextStyle),
                              subtitle: Text(dateFormat.format(_date.toDate()),
                                  style: TextStyles().mainPageSubtitleTextStyle),
                              leading: Container(
                                  height: Dimens().listIconSize,
                                  width: Dimens().listIconSize,
                                  alignment: Alignment.center,
                                  child: PngImage(name: ImageItems().expense)),
                              trailing: Text('${_expense} ₺',
                                  style: GoogleFonts.mavenPro(
                                    textStyle: TextStyle(
                                        color: ColorsItems().myPurple,
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold)
                                    )
                                  )
                                          ),
                          ],
                        ));
                  }
                  return state;
                },
              );
            } else {
              return Center(child: CircularProgressIndicator(color: ColorsItems().myOrange));
            }
          }
        },
      ),
    );
  }

  Future<void> IncomeAlertDialog(BuildContext context, int index) async { //Gelir kaydı işlemleri (silme ve detayları görüntüleme)  //Income record operations (deletion and detail viewing)
    showDialog<double>(
        context: context,
        builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderStyles().alertDialogRadius15),
                actions: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('NOTLAR',
                                      style: TextStyles().alertDialogNotesTextStyle),
                                  SizedBoxesHeight().customSizedBox5(),
                                  Text('${listOfDocumentSnap[index]['not']}',
                                      style: GoogleFonts.mavenPro(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              color: ColorsItems().myBlue))),
                                ])),
                        Container(
                          height: 1,
                          color: Colors.black,
                        ),
                        TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              IncomeDeleteAlertDialog(context, index);
                            },
                            child: Row(
                              children: [
                                Text(
                                  'KAYDI SİL',
                                  style: GoogleFonts.mavenPro(textStyle: TextStyle(color: ColorsItems().myBlue, fontWeight: FontWeight.bold)),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.delete_outline,
                                  color: ColorsItems().myBlue,
                                )
                              ],
                            )),
                      ])
                ]));
  }

  Future<void> IncomeDeleteAlertDialog(BuildContext context, int index) async { //Gelir kaydı silme işlemi  //Income record deletion
    showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderStyles().alertDialogRadius15),
        title: Text('Silmek istediğinizden emin misiniz?',
            style: TextStyles().deleteQuestionTextStyle),
        actions: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(),
                    side: BorderSide(
                      color: ColorsItems().myBlue,
                    )),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await listOfDocumentSnap[index].reference.delete();
                },
                child: Text(
                  'EVET',
                  style: GoogleFonts.mavenPro(
                      textStyle: TextStyle(color: ColorsItems().myBlue)),
                )),
            SizedBoxesWidth().customSizedBox10(),
            MaterialButton(
                shape: StadiumBorder(),
                color: ColorsItems().myBlue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'HAYIR',
                  style: TextStyles().whiteTextStyle,
                )),
          ])
        ],
      ),
    );
  }

  Future<void> ExpenseAlertDialog(BuildContext context, int index) async { //Gider kaydı işlemleri (silme ve detayları görüntüleme)  //Income record operations (deletion and detail viewing)
    showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderStyles().alertDialogRadius15),
        actions: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NOTLAR',
                        style: TextStyles().alertDialogNotesTextStyle),
                    SizedBoxesHeight().customSizedBox5(),
                    Text('${listOfDocumentSnap[index]['not']}',
                        style: GoogleFonts.mavenPro(
                            textStyle: TextStyle(
                                fontSize: 16, color: ColorsItems().myPurple))),
                  ],
                )),
            Container(
              height: 1,
              color: Colors.black,
            ),
            TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  ExpenseDeleteAlertDialog(context, index);
                },
                child: Row(
                  children: [
                    Text(
                      'KAYDI SİL',
                      style: GoogleFonts.mavenPro(textStyle: TextStyle(color: ColorsItems().myPurple, fontWeight: FontWeight.bold)),
                    ),
                    Spacer(),
                    Icon(
                      Icons.delete_outline,
                      color: ColorsItems().myPurple,
                    )
                  ],
                )),
          ])
        ],
      ),
    );
  }

  Future<void> ExpenseDeleteAlertDialog(BuildContext context, int index) async { //Gider kaydı silme işlemi  //Expense record deletion
    showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderStyles().alertDialogRadius15),
        title: Text('Silmek istediğinizden emin misiniz?',
            style: TextStyles().deleteQuestionTextStyle),
        actions: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(),
                    side: BorderSide(
                      color: ColorsItems().myPurple,
                    )),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await listOfDocumentSnap[index].reference.delete();
                },
                child: Text(
                  'EVET',
                  style: GoogleFonts.mavenPro(
                    textStyle: TextStyle(color: ColorsItems().myPurple)),
                )),
            SizedBoxesWidth().customSizedBox10(),
            MaterialButton(
                shape: StadiumBorder(),
                color: ColorsItems().myPurple,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'HAYIR',
                  style: TextStyles().whiteTextStyle,
                )),
          ])
        ],
      ),
    );
  }
}

class IncomeDetail extends StatefulWidget { //Gelir kaydı detayları //Income record details
  const IncomeDetail({Key? key}) : super(key: key);

  @override
  State<IncomeDetail> createState() => _IncomeDetailState();
}

class _IncomeDetailState extends State<IncomeDetail> {
  StatusService statusService = StatusService();

  late List<DocumentSnapshot> listOfDocumentSnap;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: statusService.getUserView(),
      builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
        if (asyncSnapshot.hasError) {
          return Center(child: Text('Bir hata oluştu tekrar deneyiniz'));
        }
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: ColorsItems().myOrange));
        } else {
          if (asyncSnapshot.hasData) {
            listOfDocumentSnap = asyncSnapshot.data.docs;

            String note = '';
            for (int i = 0; i < listOfDocumentSnap.length; i++) {
              note = listOfDocumentSnap[i]['not'];
            }
            return Text('${note}');
          } else {
            return Center(child: CircularProgressIndicator(color: ColorsItems().myOrange));
          }
        }
      },
    );
  }
}

class ExpenseDetail extends StatefulWidget { //Gider kaydı detayları //Expense record details
  const ExpenseDetail({Key? key}) : super(key: key);

  @override
  State<ExpenseDetail> createState() => _ExpenseDetailState();
}

class _ExpenseDetailState extends State<ExpenseDetail> {
  StatusService statusService = StatusService();

  late List<DocumentSnapshot> listOfDocumentSnap;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: statusService.getUserView(),
      builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
        if (asyncSnapshot.hasError) {
          return Center(child: Text('Bir hata oluştu tekrar deneyiniz'));
        }
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: ColorsItems().myOrange));
        } else {
          if (asyncSnapshot.hasData) {
            listOfDocumentSnap = asyncSnapshot.data.docs;

            String note = '';
            for (int i = 0; i < listOfDocumentSnap.length; i++) {
              note = listOfDocumentSnap[i]['not'];
            }
            return Text('${note}');
          } else {
            return  Center(child: CircularProgressIndicator(color: ColorsItems().myOrange));
          }
        }
      },
    );
  }
}