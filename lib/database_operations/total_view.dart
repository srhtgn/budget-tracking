import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gelirgidertakip/database_operations/firebase_operations.dart';
import 'package:gelirgidertakip/items/border_styles.dart';
import 'package:gelirgidertakip/items/dimens.dart';
import 'package:gelirgidertakip/items/paddings.dart';
import 'package:gelirgidertakip/items/text_styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../items/colors.dart';
import '../items/sized_boxes.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TotalView extends StatefulWidget {
  const TotalView({Key? key}) : super(key: key);

  @override
  State<TotalView> createState() => _TotalViewState();
}

class _TotalViewState extends State<TotalView> {
  final key = GlobalKey();
  StatusService statusService = StatusService();

  late List<DocumentSnapshot> listOfDocumentSnap;

  var dateFormat = DateFormat("dd/MM/yyyy");
  var date = DateTime.now;

  List<String> months = [
    'TÜM AYLAR',
    'OCAK',
    'ŞUBAT',
    'MART',
    'NİSAN',
    'MAYIS',
    'HAZİRAN',
    'TEMMUZ',
    'AĞUSTOS',
    'EYLÜL',
    'EKİM',
    'KASIM',
    'ARALIK',
  ];

  String? selectedMonth = 'TÜM AYLAR';

  List<String> years = ['TÜM YILLAR', '2022', '2023', '2024', '2025'];

  String? selectedYear = 'TÜM YILLAR';

  ButtonStyle MonthButtonsStyle() {
    return OutlinedButton.styleFrom(
      shape: StadiumBorder(),
      side: BorderSide(color: ColorsItems().myPink),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Flex(direction: Axis.vertical, children: [
          Flexible(
            flex: 5,
            child: Row(
              children: [
                Expanded(
                    child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderStyles().monthButtonsColor,
                                borderRadius:
                                    BorderStyles().monthMenuRadius)),
                        value: selectedMonth,
                        items: months
                            .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Padding(
                                    padding: Paddings()
                                        .paddingRightAndLeftDateOperations,
                                    child: Text(
                                      item,
                                      style: TextStyles().monthMenuTextStyle,
                                    ))))
                            .toList(),
                        onChanged: (item) =>
                            setState(() => selectedMonth = item))),
                SizedBoxesWidth().customSizedBox10(),
                Expanded(
                    child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderStyles().monthButtonsColor,
                                borderRadius:
                                    BorderStyles().yearMenuRadius)),
                        value: selectedYear,
                        items: years
                            .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Padding(
                                  padding: Paddings()
                                      .paddingRightAndLeftDateOperations,
                                  child: Text(
                                    item,
                                    style: TextStyles().yearMenuTextStyle,
                                  ),
                                )))
                            .toList(),
                        onChanged: (item) =>
                            setState(() => selectedYear = item))),
              ],
            ),
          ),
          Flexible(
              flex: 25,
              child: StreamBuilder<QuerySnapshot>( //Genel İstatistikler  //General Statistics
                stream: statusService.getTotalView(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  if (asyncSnapshot.hasError) { //Verilerin gelmemesi anında //When the data does not come
                    return Center(
                        child: Text('Bir hata oluştu tekrar deneyiniz'));
                  }
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) { //Veriler gelme aşamasındayken //While the data is in the process of coming
                    return Center(
                        child: CircularProgressIndicator(
                            color: ColorsItems().myOrange));
                  } else {
                    if (asyncSnapshot.hasData) {
                      listOfDocumentSnap = asyncSnapshot.data.docs;

                      double totalIncome = 0;
                      double totalExpense = 0;
                      double budget = 0;

                      double janIncome = 0;
                      double janExpense = 0;

                      double febIncome = 0;
                      double febExpense = 0;

                      double marIncome = 0;
                      double marExpense = 0;

                      double aprIncome = 0;
                      double aprExpense = 0;

                      double mayIncome = 0;
                      double mayExpense = 0;

                      double junIncome = 0;
                      double junExpense = 0;

                      double julIncome = 0;
                      double julExpense = 0;

                      double aguIncome = 0;
                      double aguExpense = 0;

                      double sepIncome = 0;
                      double sepExpense = 0;

                      double octIncome = 0;
                      double octExpense = 0;

                      double novIncome = 0;
                      double novExpense = 0;

                      double decIncome = 0;
                      double decExpense = 0;

                      for (int i = 0; i < listOfDocumentSnap.length; i++) { //Seçilen aya göre verileri geitrmek  //Fetch the data according to the selected month
                        void monthOperations() {
                          if (selectedMonth == listOfDocumentSnap[i]['ay']) {
                            totalIncome = 0;
                            totalExpense = 0;

                            switch (selectedMonth) {
                              case 'OCAK':
                                {
                                  janIncome = janIncome +
                                      listOfDocumentSnap[i]['gelir'];
                                  janExpense = janExpense +
                                      listOfDocumentSnap[i]['gider'];
                                  totalIncome = janIncome;
                                  totalExpense = janExpense;
                                  debugPrint('$selectedMonth');
                                  break;
                                }
                              case 'ŞUBAT':
                                {
                                  febIncome = febIncome +
                                      listOfDocumentSnap[i]['gelir'];
                                  febExpense = febExpense +
                                      listOfDocumentSnap[i]['gider'];
                                  totalIncome = febIncome;
                                  totalExpense = febExpense;
                                  break;
                                }
                              case 'MART':
                                {
                                  marIncome = marIncome +
                                      listOfDocumentSnap[i]['gelir'];
                                  marExpense = marExpense +
                                      listOfDocumentSnap[i]['gider'];
                                  totalIncome = marIncome;
                                  totalExpense = marExpense;
                                  break;
                                }
                              case 'NİSAN':
                                {
                                  aprIncome = aprIncome +
                                      listOfDocumentSnap[i]['gelir'];
                                  aprExpense = aprExpense +
                                      listOfDocumentSnap[i]['gider'];
                                  totalIncome = aprIncome;
                                  totalExpense = aprExpense;
                                  break;
                                }
                              case 'MAYIS':
                                {
                                  mayIncome = mayIncome +
                                      listOfDocumentSnap[i]['gelir'];
                                  mayExpense = mayExpense +
                                      listOfDocumentSnap[i]['gider'];
                                  totalIncome = mayIncome;
                                  totalExpense = mayExpense;
                                  break;
                                }
                              case 'HAZİRAN':
                                {
                                  junIncome = junIncome +
                                      listOfDocumentSnap[i]['gelir'];
                                  junExpense = junExpense +
                                      listOfDocumentSnap[i]['gider'];
                                  totalIncome = junIncome;
                                  totalExpense = junExpense;
                                  break;
                                }
                              case 'TEMMUZ':
                                {
                                  julIncome = julIncome +
                                      listOfDocumentSnap[i]['gelir'];
                                  julExpense = julExpense +
                                      listOfDocumentSnap[i]['gider'];
                                  totalIncome = julIncome;
                                  totalExpense = julExpense;
                                  break;
                                }
                              case 'AĞUSTOS':
                                {
                                  aguIncome = aguIncome +
                                      listOfDocumentSnap[i]['gelir'];
                                  aguExpense = aguExpense +
                                      listOfDocumentSnap[i]['gider'];
                                  totalIncome = aguIncome;
                                  totalExpense = aguExpense;
                                  break;
                                }
                              case 'EYLÜL':
                                {
                                  sepIncome = sepIncome +
                                      listOfDocumentSnap[i]['gelir'];
                                  sepExpense = sepExpense +
                                      listOfDocumentSnap[i]['gider'];
                                  totalIncome = sepIncome;
                                  totalExpense = sepExpense;
                                  break;
                                }
                              case 'EKİM':
                                {
                                  octIncome = octIncome +
                                      listOfDocumentSnap[i]['gelir'];
                                  octExpense = octExpense +
                                      listOfDocumentSnap[i]['gider'];
                                  totalIncome = octIncome;
                                  totalExpense = octExpense;
                                  break;
                                }
                              case 'KASIM':
                                {
                                  novIncome = novIncome +
                                      listOfDocumentSnap[i]['gelir'];
                                  novExpense = novExpense +
                                      listOfDocumentSnap[i]['gider'];
                                  totalIncome = novIncome;
                                  totalExpense = novExpense;
                                  break;
                                }
                              case 'ARALIK':
                                {
                                  decIncome = decIncome +
                                      listOfDocumentSnap[i]['gelir'];
                                  decExpense = decExpense +
                                      listOfDocumentSnap[i]['gider'];
                                  totalIncome = decIncome;
                                  totalExpense = decExpense;
                                  break;
                                }
                              default:
                                {
                                  totalIncome = 0;
                                  totalExpense = 0;
                                }
                                break;
                            }
                          } else if (selectedMonth == 'TÜM AYLAR') {
                            totalIncome =
                                totalIncome + listOfDocumentSnap[i]['gelir'];
                            totalExpense =
                                totalExpense + listOfDocumentSnap[i]['gider'];
                          }
                        }

                        if (selectedYear == listOfDocumentSnap[i]['yıl']) { //Seçilen yıla göre verileri geitrmek  //Fetch the data according to the selected year
                          switch (selectedYear) {
                            case '2022':
                              {
                                monthOperations();
                                break;
                              }
                            case '2023':
                              {
                                monthOperations();
                                break;
                              }
                            case '2024':
                              {
                                monthOperations();
                                break;
                              }
                            case '2025':
                              {
                                monthOperations();
                                break;
                              }
                          }
                        } else if (selectedYear == 'TÜM YILLAR') {
                          monthOperations();
                        }
                      }

                      budget = totalIncome - totalExpense;

                      List<TotalIncomeExpense> data = [
                        TotalIncomeExpense(
                            'Gider', totalExpense, ColorsItems().myPurple),
                        TotalIncomeExpense(
                            'Gelir', totalIncome, ColorsItems().myBlue),
                      ];

                      List<charts.Series<TotalIncomeExpense, String>> series = [
                        charts.Series(
                            data: data,
                            id: 'Income-Expense Status',
                            domainFn: (TotalIncomeExpense pops, _) => pops.type,
                            measureFn: (TotalIncomeExpense pops, _) =>
                                pops.value,
                            colorFn: (TotalIncomeExpense pops, _) =>
                                charts.ColorUtil.fromDartColor(pops.color),
                            labelAccessorFn: (TotalIncomeExpense pops, _) =>
                                '${pops.value}')
                      ];
                      var state;

                      if (totalIncome != 0 || totalExpense != 0) {
                        state = Row(
                          children: [
                            Expanded( //Daire grafik ayarları  //Circle charts settings
                              child: charts.PieChart<String>(
                                series,
                                animate: true,
                                animationDuration: const Duration(seconds: 1),
                                defaultRenderer: charts.ArcRendererConfig(
                                    arcWidth: 60,
                                    arcRendererDecorators: [
                                      charts.ArcLabelDecorator(
                                          labelPosition:
                                              charts.ArcLabelPosition.inside)
                                    ]),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Container(
                                      height: Dimens().containerSize,
                                      width: Dimens().containerSize,
                                      decoration: BoxDecoration(
                                          color: ColorsItems().myBlue,
                                          borderRadius:
                                          BorderStyles().categoryColorBoxRadius)),
                                  SizedBoxesWidth().customSizedBox10(),
                                  Column(children: [
                                    Text('GELİR',
                                        style: TextStyles().typeTextStyle),
                                    Text('${totalIncome}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                                ]),
                                SizedBoxesHeight().customSizedBox20(),
                                Row(children: [
                                  Container(
                                      height: Dimens().containerSize,
                                      width: Dimens().containerSize,
                                      decoration: BoxDecoration(
                                          color: ColorsItems().myPurple,
                                          borderRadius:
                                          BorderStyles().categoryColorBoxRadius)),
                                  SizedBoxesWidth().customSizedBox10(),
                                  Column(children: [
                                    Text('GİDER',
                                        style: TextStyles().typeTextStyle),
                                    Text('${totalExpense}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                                ]),
                                SizedBoxesHeight().customSizedBox10(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBoxesWidth().customSizedBox20(),
                                    Column(children: [
                                      Text('Net',
                                          style: TextStyles().typeTextStyle),
                                      Text('${budget}₺',
                                          style: TextStyles().valueTextStyle),
                                    ]),
                                  ],
                                )
                              ],
                            ),
                          ],
                        );
                      } else {
                        state = Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      height: Dimens().containerSize,
                                      width: Dimens().containerSize,
                                      decoration: BoxDecoration(
                                          color: ColorsItems().myBlue,
                                          borderRadius:
                                              BorderStyles().categoryColorBoxRadius)),
                                  SizedBoxesWidth().customSizedBox10(),
                                  Column(children: [
                                    Text('GELİR',
                                        style: TextStyles().typeTextStyle),
                                    Text('${totalIncome}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                                ]),
                            SizedBoxesHeight().customSizedBox20(),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      height: Dimens().containerSize,
                                      width: Dimens().containerSize,
                                      decoration: BoxDecoration(
                                          color: ColorsItems().myPurple,
                                          borderRadius:
                                          BorderStyles().categoryColorBoxRadius)),
                                  SizedBoxesWidth().customSizedBox10(),
                                  Column(children: [
                                    Text('GİDER',
                                        style: TextStyles().typeTextStyle),
                                    Text('${totalExpense}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                                ]),
                            SizedBoxesHeight().customSizedBox10(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBoxesWidth().customSizedBox20(),
                                Column(children: [
                                  Text('Net',
                                      style: TextStyles().typeTextStyle),
                                  Text('${budget}₺',
                                      style: TextStyles().valueTextStyle),
                                ]),
                              ],
                            )
                          ],
                        );
                      }
                      return state;
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                              color: ColorsItems().myOrange));
                    }
                  }
                },
              ))
        ]));
  }
}

class TotalIncomeExpense {
  late final String type;
  late final double value;
  late final Color color;

  TotalIncomeExpense(this.type, this.value, this.color);
}

class CategoryIncomeExpense {
  late final String type;
  late final double value;
  late final Color color;

  CategoryIncomeExpense(this.type, this.value, this.color);
}
