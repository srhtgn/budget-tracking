import 'package:flutter/material.dart';
import 'package:gelirgidertakip/database_operations/statistics_page_view.dart';
import 'package:gelirgidertakip/items/paddings.dart';

class StatisticsPage extends StatefulWidget { //İstatistik sayfası  //Statistics page
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Padding(
          padding: Paddings().paddingRightAndLeft,
          child: StatisticsPageView(),
        )
    );
  }
}