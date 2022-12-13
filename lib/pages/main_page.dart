import 'package:flutter/material.dart';
import 'package:gelirgidertakip/database_operations/main_page_list_view.dart';
import 'package:gelirgidertakip/database_operations/total_view.dart';
import 'package:gelirgidertakip/items/sized_boxes.dart';
import 'package:gelirgidertakip/pages/data_input_page.dart';
import '../items/paddings.dart';

class MainPage extends StatefulWidget { //Ana sayfa  //MainPage
  MainPage({Key? key,}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: Paddings().paddingRightLeftTop,
          child: Flex(
            direction: Axis.vertical,
            children: [
              Flexible(
                flex: 30,
                child: TotalView(),
              ),
              Flexible(
                flex: 20,
                child: MainPageListView(),
              ),
              SizedBoxesHeight().customSizedBox10(),
              Flexible(
                flex: 5,
                child: DataInputPage(),
              ),
              SizedBox(
                height: 79,
              ),
            ],
          ),
        ));
  }
}