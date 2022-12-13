import 'package:flutter/material.dart';
import 'package:gelirgidertakip/database_operations/firebase_operations.dart';
import 'package:gelirgidertakip/items/colors.dart';
import 'package:gelirgidertakip/items/input_decerator.dart';
import 'package:gelirgidertakip/items/paddings.dart';
import 'package:gelirgidertakip/items/border_styles.dart';
import 'package:gelirgidertakip/items/sized_boxes.dart';
import 'package:gelirgidertakip/items/dimens.dart';
import 'package:gelirgidertakip/items/text_styles.dart';
import 'package:gelirgidertakip/items/texts.dart';
import 'package:gelirgidertakip/pages/home.dart';
import 'package:gelirgidertakip/pages/main_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:unicons/unicons.dart';

class DataInputPage extends StatefulWidget {
  const DataInputPage({Key? key}) : super(key: key);

  @override
  State<DataInputPage> createState() => DataInputPageState();
}

class DataInputPageState extends State<DataInputPage> {
  final dateFormat = DateFormat('dd.MM.yyyy');
  var date = DateTime.now();

  bool read = false;

  List<String> items = ['NAKİT', 'KREDİ'];
  String? selectedItem = 'NAKİT';

  List<String> incomeCategoryItems = [
    'MAAŞ',
    'SATIŞ',
    'KİRA',
    'TAZMİNAT',
    'ALACAK',
    'BURS',
    'KUPON',
    'PİYANGO',
    'DİĞER'
  ];

  List<String> expenseCategoryItems = [
    'ALIŞVERİŞ',
    'SİGORTA',
    'VERGİ',
    'FATURA',
    'EĞLENCE',
    'SAĞLIK',
    'DİĞER'
  ];

  TextEditingController incomeController = TextEditingController();
  TextEditingController expenseController = TextEditingController();
  TextEditingController incomeCategoryController = TextEditingController();
  TextEditingController expenseCategoryController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  TextEditingController incomeNoteController = TextEditingController();
  TextEditingController expenseNoteController = TextEditingController();

  double incomeValue = 0;
  double expenseValue = 0;
  String? categoryValue;
  String? noteValue;

  //Veri giriş denetleyicileri  //Data input controllers
  void incomeInitSatete() {
    incomeController = TextEditingController();
    super.initState();
  }

  void expenseInitSatete() {
    expenseController = TextEditingController();
    super.initState();
  }

  void categoryInitState() {
    incomeCategoryController = TextEditingController();
    super.initState();
  }

  void categoryInitSatete() {
    expenseCategoryController = TextEditingController();
    super.initState();
  }

  void noteInitState() {
    incomeNoteController = TextEditingController();
    super.initState();
  }

  void noteInitSatete() {
    expenseNoteController = TextEditingController();
    super.initState();
  }

  @override
  incomeDispose() {
    incomeController = incomeDispose();
    super.dispose();
  }

  @override
  expenseDispose() {
    expenseController = expenseDispose();
    super.dispose();
  }

  @override
  typeIncomeDispose() {
    incomeCategoryController = typeIncomeDispose();
    super.dispose();
  }

  @override
  typeExpenseDispose() {
    expenseCategoryController = typeExpenseDispose();
    super.dispose();
  }

  @override
  noteIncomeDispose() {
    incomeNoteController = noteIncomeDispose();
    super.dispose();
  }

  @override
  noteExpenseDispose() {
    expenseNoteController = noteExpenseDispose();
    super.dispose();
  }

  void incomeInput() {
    setState(() {
      incomeValue = double.parse(incomeController.text);
    });
  }

  void expenseInput() {
    setState(() {
      expenseValue = double.parse(expenseController.text);
    });
  }

  void categoryIncomeInput() {
    setState(() {
      categoryValue = incomeCategoryController.text;
    });
  }

  void categoryExpenseInput() {
    setState(() {
      categoryValue = expenseCategoryController.text;
    });
  }

  void noteIncomeInput() {
    setState(() {
      noteValue = incomeNoteController.text;
    });
  }

  void noteExpenseInput() {
    setState(() {
      noteValue = expenseNoteController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          child: Row(
            children: [
              Spacer(),
              FloatingActionButton.extended( //Gelir girme butonu - //Income entry button
                onPressed: () async {

                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderStyles().showModalBottomSheetRadius),
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Padding(
                            padding: EdgeInsets.only(
                                right: 15,
                                left: 15,
                                top: 15,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Stack(
                              alignment: AlignmentDirectional.topCenter,
                              clipBehavior: Clip.none,
                              children: [
                                Position().incomeBottomSheetPositioned,
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 30,
                                          child: Center(
                                            child: Text('GELİR',
                                                style: TextStyles()
                                                    .incomeTitleTextStyle),
                                          )),
                                      SizedBoxesHeight().customSizedBox10(),
                                      SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 55,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: DropdownButtonFormField< //Gelir kategorisi seçme menüsü  //Income category selection menu
                                                          String>(
                                                      decoration:
                                                          DropdownDecoration()
                                                              .incomeDecoration,
                                                      value: selectedItem,
                                                      items: items
                                                          .map((item) =>
                                                              DropdownMenuItem<
                                                                      String>(
                                                                  value: item,
                                                                  child: Text(
                                                                    item,
                                                                    style: TextStyle(
                                                                        color: ColorsItems()
                                                                            .myBlue),
                                                                  )))
                                                          .toList(),
                                                      onChanged: (item) =>
                                                          setState(() =>
                                                              selectedItem =
                                                                  item))),
                                              SizedBoxesWidth()
                                                  .customSizedBox10(),
                                              Expanded(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      DateTime ? newDate = await showDatePicker(
                                                          context: context,
                                                          initialDate: date,
                                                          firstDate: DateTime(2022),
                                                          lastDate: DateTime(2100),
                                                      ).then((value){
                                                        setState(() {
                                                          date = value!;
                                                        });
                                                      });
                                                    },
                                                    child: Container(
                                                        height: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .height,
                                                        alignment:
                                                        Alignment.center,
                                                        color: ColorsItems()
                                                            .myBlue,
                                                        child: Text(
                                                          dateFormat
                                                              .format(date),
                                                          style: TextStyles()
                                                              .whiteTextStyle,
                                                        )),
                                                  ))
                                            ],
                                          )),
                                      SizedBoxesHeight().customSizedBox50(),
                                      TextField(
                                        onTap: () {
                                          openIncomeDialog();
                                        },
                                        cursorColor: ColorsItems().myBlue,
                                        keyboardType: TextInputType.text,
                                        controller: incomeCategoryController,
                                        readOnly: true,
                                        decoration:
                                            InputDecerator().incomeTypeInput,
                                        style: GoogleFonts.mavenPro(
                                            textStyle: TextStyle(
                                                color: ColorsItems().myBlue)),
                                      ),
                                      SizedBoxesHeight().customSizedBox10(),
                                      TextField(
                                        cursorColor: ColorsItems().myBlue,
                                        controller: incomeController,
                                        keyboardType: TextInputType.number,
                                        decoration:
                                            InputDecerator().IncomeInput,
                                        style: GoogleFonts.mavenPro(
                                            textStyle: TextStyle(
                                                color: ColorsItems().myBlue)),
                                      ),
                                      SizedBoxesHeight().customSizedBox10(),
                                      TextField(
                                        cursorColor: ColorsItems().myBlue,
                                        controller: incomeNoteController,
                                        keyboardType: TextInputType.multiline,
                                        decoration:
                                            InputDecerator().incomeNoteInput,
                                        style: GoogleFonts.mavenPro(
                                            textStyle: TextStyle(
                                                color: ColorsItems().myBlue)),
                                      ),
                                      SizedBoxesHeight().customSizedBox50(),
                                      Center(
                                          child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                                color: ColorsItems().myBlue)),
                                        onPressed: () {
                                          int month = int.parse(DateFormat('MM').format(date));
                                          int year = int.parse(DateFormat('yyyy').format(date));

                                          String? stringMonth;
                                          String? stringYear;

                                            switch (month) {
                                              case 1:
                                                {
                                                  stringMonth = 'OCAK';
                                                  break;
                                                }
                                              case 2:
                                                {
                                                  stringMonth = 'ŞUBAT';
                                                  break;
                                                }
                                              case 3:
                                                {
                                                  stringMonth = 'MART';
                                                  break;
                                                }
                                              case 4:
                                                {
                                                  stringMonth = 'NİSAN';
                                                  break;
                                                }
                                              case 5:
                                                {
                                                  stringMonth = 'MAYIS';
                                                  break;
                                                }
                                              case 6:
                                                {
                                                  stringMonth = 'HAZİRAN';
                                                  break;
                                                }
                                              case 7:
                                                {
                                                  stringMonth = 'TEMMUZ';
                                                  break;
                                                }
                                              case 8:
                                                {
                                                  stringMonth = 'AĞUSTOS';
                                                  break;
                                                }
                                              case 9:
                                                {
                                                  stringMonth = 'EYLÜL';
                                                  break;
                                                }
                                              case 10:
                                                {
                                                  stringMonth = 'EKİM';
                                                  break;
                                                }
                                              case 11:
                                                {
                                                  stringMonth = 'KASIM';
                                                  break;
                                                }
                                              case 12:
                                                {
                                                  stringMonth = 'ARALIK';
                                                  break;
                                                }
                                            }

                                            switch (year) {
                                              case 2022:
                                                {
                                                  stringYear = '2022';
                                                  break;
                                                }
                                              case 2023:
                                                {
                                                  stringYear = '2023';
                                                  break;
                                                }
                                              case 2024:
                                                {
                                                  stringYear = '2024';
                                                  break;
                                                }
                                              case 2025:
                                                {
                                                  stringYear = '2025';
                                                  break;
                                                }
                                            }

                                          incomeInput();
                                          categoryIncomeInput();
                                          noteIncomeInput();
                                          AddStatus().statusSevice.addData( //Gelir kaydı verilerinin veritabanına gönderilmesi  //Sending the income record data to the database
                                              incomeValue,
                                              0,
                                              date,
                                              categoryValue!,
                                              stringMonth!,
                                              stringYear!,
                                              selectedItem!,
                                              noteValue!);
                                          incomeController.clear();
                                          incomeCategoryController.clear();
                                          incomeNoteController.clear();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('KAYDET',
                                            style:
                                                TextStyles().incomeTextStyles),
                                      )),
                                      SizedBoxesHeight().customSizedBox20(),
                                    ])
                              ],
                            ));

                        //);
                      });
                },
                backgroundColor: ColorsItems().myLightGreyBlue,
                icon: Icon(UniconsLine.plus,
                    color: ColorsItems().myBlue, size: Dimens().iconSize),
                label: Text('Gelir Gir',
                    style: TextStyles().dataInputButtonTextStyle),
              ),
              Spacer(),
              FloatingActionButton.extended( //Gider girme butonu - //Expense entry button
                onPressed: () async {
                  showModalBottomSheet(
                      // backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderStyles().showModalBottomSheetRadius),
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return SizedBox(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    right: 15,
                                    left: 15,
                                    top: 15,
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Stack(
                                    alignment: AlignmentDirectional.topCenter,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Position().expenseBottomSheetPositioned,
                                      Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 30,
                                                child: Center(
                                                  child: Text('GİDER',
                                                      style: TextStyles()
                                                          .expenseTitleTextStyle),
                                                )),
                                            SizedBoxesHeight()
                                                .customSizedBox10(),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 55,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: DropdownButtonFormField< //Gelir kategorisi seçme menüsü  //Income category selection menu
                                                                String>(
                                                            decoration:
                                                                DropdownDecoration()
                                                                    .expenseDecoration,
                                                            value: selectedItem,
                                                            items: items
                                                                .map((item) =>
                                                                    DropdownMenuItem<
                                                                            String>(
                                                                        value:
                                                                            item,
                                                                        child:
                                                                            Text(
                                                                          item,
                                                                          style:
                                                                              GoogleFonts.mavenPro(textStyle: TextStyle(color: ColorsItems().myPurple)),
                                                                        )))
                                                                .toList(),
                                                            onChanged: (item) =>
                                                                setState(() =>
                                                                    selectedItem =
                                                                        item))),
                                                    SizedBoxesWidth()
                                                        .customSizedBox10(),
                                                    Expanded(
                                                        child: InkWell(
                                                          onTap: () async {
                                                            DateTime ? newDate = await showDatePicker(
                                                                context: context,
                                                                initialDate: date,
                                                                firstDate: DateTime(2022),
                                                                lastDate: DateTime(2100));

                                                            if(newDate == null) return;

                                                            setState(() {
                                                              date = newDate;
                                                            });
                                                          },
                                                      child: Container(
                                                          height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height,
                                                          alignment:
                                                              Alignment.center,
                                                          color: ColorsItems()
                                                              .myPurple,
                                                          child: Text(
                                                            dateFormat
                                                                .format(date),
                                                            style: TextStyles()
                                                                .whiteTextStyle,
                                                          )),
                                                    ))
                                                  ],
                                                )),
                                            SizedBoxesHeight()
                                                .customSizedBox50(),
                                            TextField(
                                              onTap: () {
                                                openExpenseDialog();
                                              },
                                              cursorColor:
                                                  ColorsItems().myPurple,
                                              controller:
                                                  expenseCategoryController,
                                              keyboardType: TextInputType.text,
                                              readOnly: true,
                                              decoration: InputDecerator()
                                                  .expenseTypeInput,
                                              style: GoogleFonts.mavenPro(
                                                  textStyle: TextStyle(
                                                      color: ColorsItems()
                                                          .myPurple)),
                                            ),
                                            SizedBoxesHeight()
                                                .customSizedBox10(),
                                            TextField(
                                              cursorColor:
                                                  ColorsItems().myPurple,
                                              controller: expenseController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration:
                                                  InputDecerator().ExpenseInput,
                                              style: GoogleFonts.mavenPro(
                                                  textStyle: TextStyle(
                                                      color: ColorsItems()
                                                          .myPurple)),
                                            ),
                                            SizedBoxesHeight()
                                                .customSizedBox10(),
                                            TextField(
                                              cursorColor:
                                                  ColorsItems().myPurple,
                                              controller: expenseNoteController,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecerator()
                                                  .expenseNoteInput,
                                              style: GoogleFonts.mavenPro(
                                                  textStyle: TextStyle(
                                                      color: ColorsItems()
                                                          .myPurple)),
                                            ),
                                            SizedBoxesHeight()
                                                .customSizedBox50(),
                                            Center(
                                              child: OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                      side: BorderSide(
                                                          color: ColorsItems()
                                                              .myPurple)),
                                                  onPressed: () {
                                                    int month = int.parse(DateFormat('MM').format(date));
                                                    int year = int.parse(DateFormat('yyyy').format(date));

                                                    String? stringMonth;
                                                    String? stringYear;

                                                      switch (month) {
                                                        case 1:
                                                          {
                                                            stringMonth = 'OCAK';
                                                            break;
                                                          }
                                                        case 2:
                                                          {
                                                            stringMonth = 'ŞUBAT';
                                                            break;
                                                          }
                                                        case 3:
                                                          {
                                                            stringMonth = 'MART';
                                                            break;
                                                          }
                                                        case 4:
                                                          {
                                                            stringMonth = 'NİSAN';
                                                            break;
                                                          }
                                                        case 5:
                                                          {
                                                            stringMonth = 'MAYIS';
                                                            break;
                                                          }
                                                        case 6:
                                                          {
                                                            stringMonth = 'HAZİRAN';
                                                            break;
                                                          }
                                                        case 7:
                                                          {
                                                            stringMonth = 'TEMMUZ';
                                                            break;
                                                          }
                                                        case 8:
                                                          {
                                                            stringMonth = 'AĞUSTOS';
                                                            break;
                                                          }
                                                        case 9:
                                                          {
                                                            stringMonth = 'EYLÜL';
                                                            break;
                                                          }
                                                        case 10:
                                                          {
                                                            stringMonth = 'EKİM';
                                                            break;
                                                          }
                                                        case 11:
                                                          {
                                                            stringMonth = 'KASIM';
                                                            break;
                                                          }
                                                        case 12:
                                                          {
                                                            stringMonth = 'ARALIK';
                                                            break;
                                                          }
                                                      }

                                                      switch (year) {
                                                        case 2022:
                                                          {
                                                            stringYear = '2022';
                                                            break;
                                                          }
                                                        case 2023:
                                                          {
                                                            stringYear = '2023';
                                                            break;
                                                          }
                                                        case 2024:
                                                          {
                                                            stringYear = '2024';
                                                            break;
                                                          }
                                                        case 2025:
                                                          {
                                                            stringYear = '2025';
                                                            break;
                                                          }
                                                      }
                                                    expenseInput();
                                                    categoryExpenseInput();
                                                    noteExpenseInput();
                                                    AddStatus() //Gider kaydı verilerinin veritabanına gönderilmesi  //Sending the expsense record data to the database
                                                        .statusSevice
                                                        .addData(
                                                            0,
                                                            expenseValue,
                                                            date,
                                                            categoryValue!,
                                                            stringMonth!,
                                                            stringYear!,
                                                            selectedItem!,
                                                            noteValue!);
                                                    expenseController.clear();
                                                    expenseCategoryController
                                                        .clear();
                                                    expenseNoteController
                                                        .clear();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'KAYDET',
                                                    style: TextStyles()
                                                        .expenseTextStyles,
                                                  )),
                                            ),
                                            SizedBoxesHeight()
                                                .customSizedBox20(),
                                          ]),
                                    ])));
                      });
                },
                backgroundColor: ColorsItems().myLightGreyBlue,
                icon: Icon(UniconsLine.minus,
                    color: ColorsItems().myPurple, size: Dimens().iconSize),
                label: Text('Gider Gir',
                    style: TextStyles().dataInputButtonTextStyle),
              ),
              Spacer(),
            ],
          ),
        ));
  }

  Future<String?> openIncomeDialog() => showDialog<String>( //Gelir kategorisi seçme diyalog penceresi  //Income category selection dialog
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderStyles().alertDialogRadius20),
            title:
                Text('Kategori Seçiniz', style: TextStyles().categoryTextStyle),
            actions: [
              SizedBox(
                height: 275,
                width: double.maxFinite,
                child: ListView(
                  children: [
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Flex(direction: Axis.horizontal, children: [
                      Flexible(
                        child: MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () {
                              incomeCategoryController.text =
                                  incomeCategoryItems[0];
                              Navigator.of(context)
                                  .pop(incomeCategoryController.text);
                            },
                            child: Text(
                              incomeCategoryItems[0],
                              style: TextStyles().incomeCategoryButtonTextStyle,
                            )),
                      ),
                      Flexible(
                        child: MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () {
                              incomeCategoryController.text =
                                  incomeCategoryItems[1];
                              Navigator.of(context)
                                  .pop(incomeCategoryController.text);
                            },
                            child: Text(
                              incomeCategoryItems[1],
                              style: TextStyles().incomeCategoryButtonTextStyle,
                            )),
                      ),
                    ]),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Flex(direction: Axis.horizontal, children: [
                      Flexible(
                        child: MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () {
                              incomeCategoryController.text =
                                  incomeCategoryItems[2];
                              Navigator.of(context)
                                  .pop(incomeCategoryController.text);
                            },
                            child: Text(
                              incomeCategoryItems[2],
                              style: TextStyles().incomeCategoryButtonTextStyle,
                            )),
                      ),
                      Flexible(
                        child: MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () {
                              incomeCategoryController.text =
                                  incomeCategoryItems[3];
                              Navigator.of(context)
                                  .pop(incomeCategoryController.text);
                            },
                            child: Text(
                              incomeCategoryItems[3],
                              style: TextStyles().incomeCategoryButtonTextStyle,
                            )),
                      ),
                    ]),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Flex(direction: Axis.horizontal, children: [
                      Flexible(
                        child: MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () {
                              incomeCategoryController.text =
                                  incomeCategoryItems[4];
                              Navigator.of(context)
                                  .pop(incomeCategoryController.text);
                            },
                            child: Text(
                              incomeCategoryItems[4],
                              style: TextStyles().incomeCategoryButtonTextStyle,
                            )),
                      ),
                      Flexible(
                        child: MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () {
                              incomeCategoryController.text =
                                  incomeCategoryItems[5];
                              Navigator.of(context)
                                  .pop(incomeCategoryController.text);
                            },
                            child: Text(
                              incomeCategoryItems[5],
                              style: TextStyles().incomeCategoryButtonTextStyle,
                            )),
                      ),
                    ]),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Flex(direction: Axis.horizontal, children: [
                      Flexible(
                        child: MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () {
                              incomeCategoryController.text =
                                  incomeCategoryItems[6];
                              Navigator.of(context)
                                  .pop(incomeCategoryController.text);
                            },
                            child: Text(
                              incomeCategoryItems[6],
                              style: TextStyles().incomeCategoryButtonTextStyle,
                            )),
                      ),
                      Flexible(
                        child: MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () {
                              incomeCategoryController.text =
                                  incomeCategoryItems[7];
                              Navigator.of(context)
                                  .pop(incomeCategoryController.text);
                            },
                            child: Text(
                              incomeCategoryItems[7],
                              style: TextStyles().incomeCategoryButtonTextStyle,
                            )),
                      ),
                    ]),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    SizedBoxesHeight().customSizedBox10(),
                    TextField(
                      cursorColor: ColorsItems().myBlue,
                      controller: otherController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: Paddings().paddingRightAndLeft30,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorsItems().myBlue),
                          borderRadius: BorderStyles().textFieldRadius,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorsItems().myBlue),
                          borderRadius: BorderStyles().textFieldRadius,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              incomeCategoryController.text =
                                  otherController.text;
                              if (incomeCategoryController.text == null) {
                                incomeCategoryController.text = 'DİĞER';
                                Navigator.of(context)
                                    .pop(incomeCategoryController.text);
                              } else {
                                Navigator.of(context)
                                    .pop(incomeCategoryController.text);
                              }
                              otherController.clear();
                            },
                            icon:
                                Icon(Icons.check, color: ColorsItems().myBlue)),
                        labelText: 'DİĞER',
                        labelStyle: TextStyles().incomeTextStyles,
                        fillColor: Colors.transparent,
                        filled: true,
                      ),
                      style: TextStyles().incomeTextStyles,
                    ),
                  ],
                ),
              )
            ],
          ));
  Future<String?> openExpenseDialog() => showDialog<String>( //Gider kategorisi seçme diyalog penceresi  //Expense
    // category selection dialog
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderStyles().alertDialogRadius20),
          title:
              Text('Kategori Seçiniz', style: TextStyles().categoryTextStyle),
          actions: [
            SizedBox(
              height: 225,
              width: double.maxFinite,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Flex(direction: Axis.horizontal, children: [
                    Flexible(
                      child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: () {
                            expenseCategoryController.text =
                                expenseCategoryItems[0];
                            Navigator.of(context)
                                .pop(expenseCategoryController.text);
                          },
                          child: Text(
                            expenseCategoryItems[0],
                            style: TextStyles().expenseTextStyles,
                          )),
                    ),
                    Flexible(
                      child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: () {
                            expenseCategoryController.text =
                                expenseCategoryItems[1];
                            Navigator.of(context)
                                .pop(expenseCategoryController.text);
                          },
                          child: Text(
                            expenseCategoryItems[1],
                            style: TextStyles().expenseTextStyles,
                          )),
                    ),
                  ]),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Flex(direction: Axis.horizontal, children: [
                    Flexible(
                      child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: () {
                            expenseCategoryController.text =
                                expenseCategoryItems[2];
                            Navigator.of(context)
                                .pop(expenseCategoryController.text);
                          },
                          child: Text(
                            expenseCategoryItems[2],
                            style: TextStyles().expenseTextStyles,
                          )),
                    ),
                    Flexible(
                      child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: () {
                            expenseCategoryController.text =
                                expenseCategoryItems[3];
                            Navigator.of(context)
                                .pop(expenseCategoryController.text);
                          },
                          child: Text(
                            expenseCategoryItems[3],
                            style: TextStyles().expenseTextStyles,
                          )),
                    ),
                  ]),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Flex(direction: Axis.horizontal, children: [
                    Flexible(
                      child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: () {
                            expenseCategoryController.text =
                                expenseCategoryItems[4];
                            Navigator.of(context)
                                .pop(expenseCategoryController.text);
                          },
                          child: Text(
                            expenseCategoryItems[4],
                            style: TextStyles().expenseTextStyles,
                          )),
                    ),
                    Flexible(
                      child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: () {
                            expenseCategoryController.text =
                                expenseCategoryItems[5];
                            Navigator.of(context)
                                .pop(expenseCategoryController.text);
                          },
                          child: Text(
                            expenseCategoryItems[5],
                            style: TextStyles().expenseTextStyles,
                          )),
                    ),
                  ]),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  SizedBoxesHeight().customSizedBox10(),
                  TextField(
                    cursorColor: ColorsItems().myPurple,
                    controller: otherController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: Paddings().paddingRightAndLeft30,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorsItems().myPurple),
                        borderRadius: BorderStyles().textFieldRadius,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorsItems().myPurple),
                        borderRadius: BorderStyles().textFieldRadius,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            expenseCategoryController.text =
                                otherController.text;
                            if (expenseCategoryController.text == null) {
                              expenseCategoryController.text = 'DİĞER';
                              Navigator.of(context)
                                  .pop(expenseCategoryController.text);
                            } else {
                              Navigator.of(context)
                                  .pop(expenseCategoryController.text);
                            }
                            otherController.clear();
                          },
                          icon:
                              Icon(Icons.check, color: ColorsItems().myPurple)),
                      labelText: 'DİĞER',
                      labelStyle: TextStyles().expenseTextStyles,
                      fillColor: Colors.transparent,
                      filled: true,
                    ),
                    style: TextStyles().expenseTextStyles,
                  ),
                ],
              ),
            )
          ],
        ),
      );
}

class Position {
  final Positioned incomeBottomSheetPositioned = Positioned(
      top: -10,
      child: Container(
        height: 3,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: ColorsItems().myBlue),
        //color: Colors.white,
      ));
  final Positioned expenseBottomSheetPositioned = Positioned(
      top: -10,
      child: Container(
        height: 3,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: ColorsItems().myPurple),
        //color: Colors.white,
      ));
}

class DropdownDecoration {
  final InputDecoration incomeDecoration = InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorsItems().myBlue),
          borderRadius: BorderRadius.zero));
  final InputDecoration expenseDecoration = InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorsItems().myPurple),
          borderRadius: BorderRadius.zero));
}
