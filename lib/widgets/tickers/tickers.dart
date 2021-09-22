import 'package:crabs_trade/constants/style.dart';
import 'package:crabs_trade/controllers/data_load_controller.dart';
import 'package:crabs_trade/helpers/custom_text.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tickers extends StatelessWidget {
  const Tickers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DataLoadController c = Get.find();
    final FluroRouter router = Get.find();
    // TODO pull to update
    return Container(
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: CustomText(
                    text: 'Tickers',
                    color: light,
                    size: 22,
                  ),
                ),
                Container(
                  height: 1,
                  width: double.maxFinite,
                  color: light,
                ),
                DataTable2(
                  showCheckboxColumn: false,
                  headingRowColor:
                      MaterialStateColor.resolveWith((states) => dark_light),
                  dataRowColor:
                      MaterialStateColor.resolveWith((states) => dark_light),
                  headingTextStyle: const TextStyle(color: light),
                  dataTextStyle: const TextStyle(color: light),
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 300,
                  columns: [
                    const DataColumn2(
                      label: Text('Name', style: TextStyle(color: active)),
                      size: ColumnSize.L,
                    ),
                    const DataColumn2(
                      label: Text('Ticker', style: TextStyle(color: active)),
                      size: ColumnSize.L,
                    ),
                    const DataColumn2(
                      label: Text('Status', style: TextStyle(color: active)),
                      size: ColumnSize.L,
                    ),
                    const DataColumn2(
                      label: Text('Profit', style: TextStyle(color: active)),
                      size: ColumnSize.S,
                    ),
                  ],
                  rows: c.tickers
                      .map(
                        (data) => DataRow(
                            onSelectChanged: (newValue) {
                              router.navigateTo(
                                  context, '/tickers/' + data['ticker'],
                                  transition: TransitionType.fadeIn);
                            },
                            cells: [
                              DataCell(Text(data['name'])),
                              DataCell(Text(data['ticker'])),
                              DataCell(Text(data['status'])),
                              DataCell(Text(
                                data['profit'].toString() + '\$',
                                style: TextStyle(
                                    color: data['profit'] > 0
                                        ? success
                                        : data['profit'] < 0
                                            ? danger
                                            : light_grey),
                              )),
                            ]),
                      )
                      .toList(),
                ),
              ],
            ),
          )),
    );
  }
}
