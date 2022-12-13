import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gelirgidertakip/database_operations/firebase_operations.dart';
import 'package:gelirgidertakip/database_operations/total_view.dart';
import 'package:gelirgidertakip/items/border_styles.dart';
import 'package:gelirgidertakip/items/colors.dart';
import 'package:gelirgidertakip/items/dimens.dart';
import 'package:gelirgidertakip/items/paddings.dart';
import 'package:gelirgidertakip/items/sized_boxes.dart';
import 'package:gelirgidertakip/items/text_styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatisticsPageView extends StatefulWidget {
  const StatisticsPageView({Key? key}) : super(key: key);

  @override
  State<StatisticsPageView> createState() => _StatisticsPageViewState();
}

class _StatisticsPageViewState extends State<StatisticsPageView>
    with TickerProviderStateMixin {
  StatusService statusService = StatusService();
  final FirebaseAuth auth = FirebaseAuth.instance;

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

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController = TabController(length: 3, vsync: this);
  }

  late List<DocumentSnapshot> listOfDocumentSnap;
  late List<DocumentSnapshot> indexDoc;

  var dateFormat = DateFormat("dd/MM/yyyy");

  ButtonStyle ButtonsStyle() {
    return OutlinedButton.styleFrom(
      shape: StadiumBorder(),
      side: BorderSide(color: ColorsItems().myPink),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: Paddings().paddingTop,
              child: Flex(direction: Axis.vertical, children: [
                Flexible(
                  flex: 10,
                  child: Row(
                    children: [
                      Expanded(
                          child: DropdownButtonFormField<String>( //Ay menüsü  //Month menu
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorsItems().myPink),
                                      borderRadius: BorderStyles().monthMenuRadius)),
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
                          child: DropdownButtonFormField<String>( //Yıl menüsü  //Year menu
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorsItems().myPink),
                                      borderRadius: BorderStyles().yearMenuRadius)),
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
                SizedBoxesHeight().customSizedBox10(),
                Flexible(
                  flex: 90,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      GeneralStatistics(),
                      IncomeStatistics(),
                      ExpenseStatistics()
                    ],
                  ),
                ),
                Flexible(
                    flex: 25,
                        child: Column(
                      children: [
                        Container(

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          child: Padding(
                            padding: Paddings().paddingRightAndLeft15,
                            child: TabBar(
                              controller: tabController,
                              labelColor: ColorsItems().myPink,
                              labelStyle: GoogleFonts.mavenPro(
                                  textStyle: TextStyle(fontSize: 20)),
                              indicatorColor: ColorsItems().myOrange,
                              indicatorWeight: 3,
                              indicatorSize: TabBarIndicatorSize.label,
                              tabs: [
                                Tab(text: "  Genel  "),
                                Tab(text: "  Gelir  "),
                                Tab(text: "  Gider  ")
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                        ),)

                      ],
                    )),
              ]),
            )));
  }

  Padding GeneralStatistics() {
    return Padding(
      padding: Paddings().paddingBottomStatisticsPage,
      child: StreamBuilder<QuerySnapshot>(
        stream: statusService.getTotalView(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.hasError) { //Verilerin gelmemesi anında //When the data does not come
            return Center(child: Text('Bir hata oluştu tekrar deneyiniz'));
          }
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {  //Veriler gelme aşamasındayken //While the data is in the process of coming
            return Center(child: CircularProgressIndicator(color: ColorsItems().myOrange));
          } else {
            if (asyncSnapshot.hasData) {
              listOfDocumentSnap = asyncSnapshot.data.docs;
              listOfDocumentSnap;

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

              for (int i = 0; i < listOfDocumentSnap.length; i++) {  //Seçilen aya göre verileri geitrmek  //Fetch the data according to the selected month
                void monthOperations() {
                  if (selectedMonth == listOfDocumentSnap[i]['ay']) {
                    totalIncome = 0;
                    totalExpense = 0;

                    switch (selectedMonth) {
                      case 'OCAK':
                        {
                          janIncome =
                              janIncome + listOfDocumentSnap[i]['gelir'];
                          janExpense =
                              janExpense + listOfDocumentSnap[i]['gider'];
                          totalIncome = janIncome;
                          totalExpense = janExpense;
                          break;
                        }
                      case 'ŞUBAT':
                        {
                          febIncome =
                              febIncome + listOfDocumentSnap[i]['gelir'];
                          febExpense =
                              febExpense + listOfDocumentSnap[i]['gider'];
                          totalIncome = febIncome;
                          totalExpense = febExpense;
                          break;
                        }
                      case 'MART':
                        {
                          marIncome =
                              marIncome + listOfDocumentSnap[i]['gelir'];
                          marExpense =
                              marExpense + listOfDocumentSnap[i]['gider'];
                          totalIncome = marIncome;
                          totalExpense = marExpense;
                          break;
                        }
                      case 'NİSAN':
                        {
                          aprIncome =
                              aprIncome + listOfDocumentSnap[i]['gelir'];
                          aprExpense =
                              aprExpense + listOfDocumentSnap[i]['gider'];
                          totalIncome = aprIncome;
                          totalExpense = aprExpense;
                          break;
                        }
                      case 'MAYIS':
                        {
                          mayIncome =
                              mayIncome + listOfDocumentSnap[i]['gelir'];
                          mayExpense =
                              mayExpense + listOfDocumentSnap[i]['gider'];
                          totalIncome = mayIncome;
                          totalExpense = mayExpense;
                          break;
                        }
                      case 'HAZİRAN':
                        {
                          junIncome =
                              junIncome + listOfDocumentSnap[i]['gelir'];
                          junExpense =
                              junExpense + listOfDocumentSnap[i]['gider'];
                          totalIncome = junIncome;
                          totalExpense = junExpense;
                          break;
                        }
                      case 'TEMMUZ':
                        {
                          julIncome =
                              julIncome + listOfDocumentSnap[i]['gelir'];
                          julExpense =
                              julExpense + listOfDocumentSnap[i]['gider'];
                          totalIncome = julIncome;
                          totalExpense = julExpense;
                          break;
                        }
                      case 'AĞUSTOS':
                        {
                          aguIncome =
                              aguIncome + listOfDocumentSnap[i]['gelir'];
                          aguExpense =
                              aguExpense + listOfDocumentSnap[i]['gider'];
                          totalIncome = aguIncome;
                          totalExpense = aguExpense;
                          break;
                        }
                      case 'EYLÜL':
                        {
                          sepIncome =
                              sepIncome + listOfDocumentSnap[i]['gelir'];
                          sepExpense =
                              sepExpense + listOfDocumentSnap[i]['gider'];
                          totalIncome = sepIncome;
                          totalExpense = sepExpense;
                          break;
                        }
                      case 'EKİM':
                        {
                          octIncome =
                              octIncome + listOfDocumentSnap[i]['gelir'];
                          octExpense =
                              octExpense + listOfDocumentSnap[i]['gider'];
                          totalIncome = octIncome;
                          totalExpense = octExpense;
                          break;
                        }
                      case 'KASIM':
                        {
                          novIncome =
                              novIncome + listOfDocumentSnap[i]['gelir'];
                          novExpense =
                              novExpense + listOfDocumentSnap[i]['gider'];
                          totalIncome = novIncome;
                          totalExpense = novExpense;
                          break;
                        }
                      case 'ARALIK':
                        {
                          decIncome =
                              decIncome + listOfDocumentSnap[i]['gelir'];
                          decExpense =
                              decExpense + listOfDocumentSnap[i]['gider'];
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
                    totalIncome = totalIncome + listOfDocumentSnap[i]['gelir'];
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
                TotalIncomeExpense('Gelir', totalIncome, ColorsItems().myBlue),
              ];

              List<charts.Series<TotalIncomeExpense, String>> series = [
                charts.Series(
                    data: data,
                    id: 'Income-Expense Status',
                    domainFn: (TotalIncomeExpense pops, _) => pops.type,
                    measureFn: (TotalIncomeExpense pops, _) => pops.value,
                    colorFn: (TotalIncomeExpense pops, _) =>
                        charts.ColorUtil.fromDartColor(pops.color),
                    labelAccessorFn: (TotalIncomeExpense pops, _) =>
                        '${pops.value}')
              ];
              return Column(
                children: [
                  Text(
                    'Genel İstatistik',
                    style: TextStyles().statisticTitlesTextStyle,
                  ),
                  Expanded(
                    child: charts.PieChart<String>( //Daire grafik ayarları  //Circle charts settings
                      series,
                      // vertical: false,
                      animate: true,
                      animationDuration: Duration(seconds: 1),
                      defaultRenderer: charts.ArcRendererConfig(
                          arcWidth: Dimens().graphicArcWidth,
                          arcRendererDecorators: [
                            charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.inside)
                          ]),
                    ),
                  ),
                  Row( //İşaretler  //Markers
                    children: [
                      Spacer(),
                      Row(children: [
                        Container(
                            height: Dimens().containerSize,
                            width: Dimens().containerSize,
                            decoration: BoxDecoration(
                                color: ColorsItems().myBlue,
                                borderRadius: BorderStyles().categoryColorBoxRadius)),
                        SizedBoxesWidth().customSizedBox10(),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('GELİR',
                                  style: TextStyles().typeTextStyle),
                              Text('${totalIncome}₺',
                                  style: TextStyles().valueTextStyle),
                            ]),
                      ]),
                      Spacer(),
                      Row(children: [
                        Container(
                            height: Dimens().containerSize,
                            width: Dimens().containerSize,
                            decoration: BoxDecoration(
                                color: ColorsItems().myPurple,
                                borderRadius: BorderStyles().categoryColorBoxRadius)),
                        SizedBoxesWidth().customSizedBox10(),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('GİDER',
                                  style: TextStyles().typeTextStyle),
                              Text('${totalExpense}₺',
                                  style: TextStyles().valueTextStyle),
                            ]),
                      ]),
                      Spacer(),
                      Row(
                        children: [
                          SizedBoxesWidth().customSizedBox20(),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Net',
                                    style: TextStyles().typeTextStyle),
                                Text('${budget}₺',
                                    style: TextStyles().valueTextStyle),
                              ]),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator(color: ColorsItems().myOrange));
            }
          }
        },
      ),
    );
  }

  Padding IncomeStatistics() {
    return Padding(
      padding: Paddings().paddingBottomStatisticsPage,
      child: StreamBuilder<QuerySnapshot>(
        stream: statusService.getTotalView(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return Center(child: Text('Bir hata oluştu tekrar deneyiniz'));
          }
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: ColorsItems().myOrange));
          } else {
            if (asyncSnapshot.hasData) {
              listOfDocumentSnap = asyncSnapshot.data.docs;
              listOfDocumentSnap;

              double salary = 0;
              double sale = 0;
              double rent = 0;
              double compensation = 0;
              double willReceive = 0;
              double scholarship = 0;
              double coupon = 0;
              double lottery = 0;
              double other = 0;

              for (int i = 0; i < listOfDocumentSnap.length; i++) { //Kategorilere göre veri eklemek  //Adding data by categories
                void categoryOperations() {
                  switch (listOfDocumentSnap[i]['kategori']) {
                    case 'MAAŞ':
                      {
                        salary = salary + listOfDocumentSnap[i]['gelir'];
                        break;
                      }
                    case 'SATIŞ':
                      {
                        sale = sale + listOfDocumentSnap[i]['gelir'];
                        break;
                      }
                    case 'KİRA':
                      {
                        rent = rent + listOfDocumentSnap[i]['gelir'];
                        break;
                      }
                    case 'TAZMİNAT':
                      {
                        compensation =
                            compensation + listOfDocumentSnap[i]['gelir'];
                        break;
                      }
                    case 'ALACAK':
                      {
                        willReceive =
                            willReceive + listOfDocumentSnap[i]['gelir'];
                        break;
                      }
                    case 'BURS':
                      {
                        scholarship =
                            scholarship + listOfDocumentSnap[i]['gelir'];
                        break;
                      }
                    case 'KUPON':
                      {
                        coupon = coupon + listOfDocumentSnap[i]['gelir'];
                        break;
                      }
                    case 'PİYANGO':
                      {
                        lottery = lottery + listOfDocumentSnap[i]['gelir'];
                        break;
                      }
                    default:
                      {
                        other = other + listOfDocumentSnap[i]['gelir'];
                        break;
                      }
                  }
                }

                void monthOperations() {
                  if (selectedMonth == listOfDocumentSnap[i]['ay']) {
                    switch (selectedMonth) {
                      case 'OCAK':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'ŞUBAT':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'MART':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'NİSAN':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'MAYIS':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'HAZİRAN':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'TEMMUZ':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'AĞUSTOS':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'EYLÜL':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'EKİM':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'KASIM':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'ARALIK':
                        {
                          categoryOperations();
                          break;
                        }
                    }
                  } else if (selectedMonth == 'TÜM AYLAR') {
                    categoryOperations();
                  }
                }

                if (selectedYear == listOfDocumentSnap[i]['yıl']) {
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
              List<CategoryIncomeExpense> data = [  //Daire grafik renkleri  //Circle charts colors
                CategoryIncomeExpense('Maaş', salary, ColorsItems().wageColor),
                CategoryIncomeExpense('Satış', sale, ColorsItems().salesColor),
                CategoryIncomeExpense('Kira', rent, ColorsItems().rentColor),
                CategoryIncomeExpense(
                    'Tazminat', compensation, ColorsItems().compensationColor),
                CategoryIncomeExpense(
                    'Alacak', willReceive, ColorsItems().willReceiveColor),
                CategoryIncomeExpense(
                    'Burs', scholarship, ColorsItems().scholarshipColor),
                CategoryIncomeExpense(
                    'Kupon', coupon, ColorsItems().couponColor),
                CategoryIncomeExpense(
                    'Piyango', lottery, ColorsItems().lotteryColor),
                CategoryIncomeExpense(
                    'Diğer', other, ColorsItems().otherIncomeColor),
              ];

              List<charts.Series<CategoryIncomeExpense, String>> series = [
                charts.Series(
                    data: data,
                    id: 'Monthly Income Status',
                    domainFn: (CategoryIncomeExpense pops, _) => pops.type,
                    measureFn: (CategoryIncomeExpense pops, _) => pops.value,
                    colorFn: (CategoryIncomeExpense pops, _) =>
                        charts.ColorUtil.fromDartColor(pops.color),
                    labelAccessorFn: (CategoryIncomeExpense pops, _) =>
                        '${pops.value}')
              ];
              var status;

              return Column(
                children: [
                  Text(
                    'Gelir İstatistiği',
                    style: TextStyles().statisticTitlesTextStyle,
                  ),
                  Expanded(
                    child: charts.PieChart<String>(
                      series,
                      // vertical: false,
                      animate: true,
                      animationDuration: Duration(seconds: 1),
                      defaultRenderer: charts.ArcRendererConfig(
                          arcWidth: Dimens().graphicArcWidth,
                          arcRendererDecorators: [
                            charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.inside)
                          ]),
                    ),
                  ),
                  Row( //İşaretler //Markers
                    children: [
                      Spacer(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().wageColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('MAAŞ',
                                        style: TextStyles().typeTextStyle),
                                    Text('${salary}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                            SizedBoxesHeight().customSizedBox10(),
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().salesColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('SATIŞ',
                                        style: TextStyles().typeTextStyle),
                                    Text('${sale}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                            SizedBoxesHeight().customSizedBox10(),
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().rentColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('KİRA',
                                        style: TextStyles().typeTextStyle),
                                    Text('${rent}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                          ]),
                      Spacer(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().compensationColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('TAZMİNAT',
                                        style: TextStyles().typeTextStyle),
                                    Text('${compensation}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                            SizedBoxesHeight().customSizedBox10(),
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().willReceiveColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ALACAK',
                                        style: TextStyles().typeTextStyle),
                                    Text('${willReceive}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                            SizedBoxesHeight().customSizedBox10(),
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().scholarshipColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('BURS',
                                        style: TextStyles().typeTextStyle),
                                    Text('${scholarship}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                          ]),
                      Spacer(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().couponColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('KUPON',
                                        style: TextStyles().typeTextStyle),
                                    Text('${coupon}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                            SizedBoxesHeight().customSizedBox10(),
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().lotteryColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('PİYANGO',
                                        style: TextStyles().typeTextStyle),
                                    Text('${lottery}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                            SizedBoxesHeight().customSizedBox10(),
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().otherIncomeColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('DİĞER',
                                        style: TextStyles().typeTextStyle),
                                    Text('${other}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                          ]),
                      Spacer(),
                    ],
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator(color: ColorsItems().myOrange));
            }
          }
        },
      ),
    );
  }

  Padding ExpenseStatistics() {
    return Padding(
      padding: Paddings().paddingBottomStatisticsPage,
      child: StreamBuilder<QuerySnapshot>(
        stream: statusService.getTotalView(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return Center(child: Text('Bir hata oluştu tekrar deneyiniz'));
          }
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: ColorsItems().myOrange));
          } else {
            if (asyncSnapshot.hasData) {
              listOfDocumentSnap = asyncSnapshot.data.docs;
              listOfDocumentSnap;

              double shopping = 0;
              double insurance = 0;
              double tax = 0;
              double invoice = 0;
              double fun = 0;
              double health = 0;
              double other = 0;

              for (int i = 0; i < listOfDocumentSnap.length; i++) {
                void categoryOperations() {
                  switch (listOfDocumentSnap[i]['kategori']) {
                    case 'ALIŞVERİŞ':
                      {
                        shopping = shopping + listOfDocumentSnap[i]['gider'];
                        break;
                      }
                    case 'SİGORTA':
                      {
                        insurance = insurance + listOfDocumentSnap[i]['gider'];
                        break;
                      }
                    case 'VERGİ':
                      {
                        tax = tax + listOfDocumentSnap[i]['gider'];
                        break;
                      }
                    case 'FATURA':
                      {
                        invoice = invoice + listOfDocumentSnap[i]['gider'];
                        break;
                      }
                    case 'EĞLENCE':
                      {
                        fun = fun + listOfDocumentSnap[i]['gider'];
                        break;
                      }
                    case 'SAĞLIK':
                      {
                        health = health + listOfDocumentSnap[i]['gider'];
                        break;
                      }
                    default:
                      {
                        other = other + listOfDocumentSnap[i]['gider'];
                        break;
                      }
                  }
                }

                void monthOperations() {
                  if (selectedMonth == listOfDocumentSnap[i]['ay']) {
                    switch (selectedMonth) {
                      case 'OCAK':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'ŞUBAT':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'MART':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'NİSAN':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'MAYIS':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'HAZİRAN':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'TEMMUZ':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'AĞUSTOS':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'EYLÜL':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'EKİM':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'KASIM':
                        {
                          categoryOperations();
                          break;
                        }
                      case 'ARALIK':
                        {
                          categoryOperations();
                          break;
                        }
                    }
                  }else if (selectedMonth == 'TÜM AYLAR') {
                    categoryOperations();
                  }
                }

                if (selectedYear == listOfDocumentSnap[i]['yıl']) {
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
                }else if (selectedYear == 'TÜM YILLAR') {
                  monthOperations();
                }
              }
              List<CategoryIncomeExpense> data = [
                CategoryIncomeExpense(
                    'Alışveriş', shopping, ColorsItems().shoppingColor),
                CategoryIncomeExpense(
                    'Sigorta', insurance, ColorsItems().insuranceColor),
                CategoryIncomeExpense('Vergi', tax, ColorsItems().taxColor),
                CategoryIncomeExpense(
                    'Fatura', invoice, ColorsItems().invoiceColor),
                CategoryIncomeExpense('Eğlence', fun, ColorsItems().funColor),
                CategoryIncomeExpense(
                    'Sağlık', health, ColorsItems().healthColor),
                CategoryIncomeExpense(
                    'Diğer', other, ColorsItems().otherExpenseColor),
              ];

              List<charts.Series<CategoryIncomeExpense, String>> series = [
                charts.Series(
                    data: data,
                    id: 'Monthly Expense Status',
                    domainFn: (CategoryIncomeExpense pops, _) => pops.type,
                    measureFn: (CategoryIncomeExpense pops, _) => pops.value,
                    colorFn: (CategoryIncomeExpense pops, _) =>
                        charts.ColorUtil.fromDartColor(pops.color),
                    labelAccessorFn: (CategoryIncomeExpense pops, _) =>
                        '${pops.value}')
              ];
              var status;

              return Column(
                children: [
                  Text(
                    'Gider İstatistiği',
                    style: TextStyles().statisticTitlesTextStyle,
                  ),
                  Expanded(
                    child: charts.PieChart<String>(
                      series,
                      // vertical: false,
                      animate: true,
                      animationDuration: Duration(seconds: 1),
                      defaultRenderer: charts.ArcRendererConfig(
                          arcWidth: Dimens().graphicArcWidth,
                          arcRendererDecorators: [
                            charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.inside)
                          ]),
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().shoppingColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ALIŞVERİŞ',
                                        style: TextStyles().typeTextStyle),
                                    Text('${shopping}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                            SizedBoxesHeight().customSizedBox10(),
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().insuranceColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('SİGORTA',
                                        style: TextStyles().typeTextStyle),
                                    Text('${insurance}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                            SizedBoxesHeight().customSizedBox10(),
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().taxColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('VERGİ',
                                        style: TextStyles().typeTextStyle),
                                    Text('${tax}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                          ]),
                      Spacer(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().invoiceColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('FATURA',
                                        style: TextStyles().typeTextStyle),
                                    Text('${invoice}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                            SizedBoxesHeight().customSizedBox10(),
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().funColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('EĞLENCE',
                                        style: TextStyles().typeTextStyle),
                                    Text('${fun}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                            SizedBoxesHeight().customSizedBox10(),
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().healthColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('SAĞLIK',
                                        style: TextStyles().typeTextStyle),
                                    Text('${health}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                          ]),
                      Spacer(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                  height: Dimens().containerSize,
                                  width: Dimens().containerSize,
                                  decoration: BoxDecoration(
                                      color: ColorsItems().otherExpenseColor,
                                      borderRadius: BorderStyles().categoryColorBoxRadius)),
                              SizedBoxesWidth().customSizedBox10(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('DİĞER',
                                        style: TextStyles().typeTextStyle),
                                    Text('${other}₺',
                                        style: TextStyles().valueTextStyle),
                                  ]),
                            ]),
                          ]),
                      Spacer(),
                    ],
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator(color: ColorsItems().myOrange));
            }
          }
        },
      ),
    );
  }
}