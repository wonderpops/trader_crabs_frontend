import 'package:crabs_trade/constants/style.dart';
import 'package:crabs_trade/helpers/api_controller.dart';
import 'package:crabs_trade/helpers/custom_text.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return const Test();
  }
}

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ApiProvider.watch(context)?.model;

    if (model?.tikers == null) {
      model?.getTickers(context);
    }

    if (model?.walletMoney == null) {
      model?.getWallet(context);
    }

    if (model?.allActions == null) {
      model?.getAllActions(context, 1);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const _Tikers(),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // height: 100,
                      // color: Colors.red,
                      child: const _WalletHistory(),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // height: 100,
                      // color: Colors.blue,
                      child: const _AllActions(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _Tikers extends StatelessWidget {
  const _Tikers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ApiProvider.watch(context)?.model;
    var tickers = model?.tikers ?? [];
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CustomText(
                text: 'Tickers',
                color: light,
                size: 22,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: tickers
                    .map(
                      (data) => _Tiker(
                        data: data,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tiker extends StatelessWidget {
  final Map data;
  const _Tiker({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: dark.withOpacity(.5),
            boxShadow: [
              BoxShadow(
                color: data['profit'] > 0
                    ? success.withOpacity(0.3)
                    : data['profit'] < 0
                        ? danger.withOpacity(0.3)
                        : light_grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 0),
              ),
            ]),
        height: 80,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: data['profit'] > 0 ? success : danger,
                ),
                width: 60,
                height: 60,
                child: Center(
                  child: CustomText(
                    text: data['ticker'],
                    size: 18,
                    color: light,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: data['name'],
                    color: light,
                  ),
                  CustomText(
                    text: data['profit'].toString() + '\$',
                    color: light,
                  ),
                  CustomText(
                    text: data['status'],
                    color: data['status'] == 'Selling' ? success : light_grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletHistory extends StatelessWidget {
  const _WalletHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ApiProvider.watch(context)?.model;
    var actions = model?.allActions ?? [];
    var walletData = [];
    var m_value = 0.0;
    var money = model?.walletMoney ?? 0;

    if (actions.isNotEmpty) {
      actions.reversed.forEach((element) {
        m_value += element['profit'];
        var date = DateTime.parse(element['date']);
        walletData.add(
            {'date': date.millisecondsSinceEpoch.toDouble(), 'value': m_value});
      });
    }

    print(walletData.toString());

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        height: 600,
        width: double.maxFinite,
        decoration:
            BoxDecoration(color: dark, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 8),
                child: CustomText(
                  text: model?.walletMoney != null
                      ? 'Wallet: ' + money.toString() + '\$'
                      : '',
                  color: light,
                  size: 22,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 1,
                  width: double.maxFinite,
                  color: light,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 450,
                  width: double.maxFinite,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.white12,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                          bottomTitles: SideTitles(
                            getTextStyles: (context, value) {
                              return const TextStyle(color: light);
                            },
                            showTitles: true,
                            getTitles: (value) {
                              var date = DateTime.fromMillisecondsSinceEpoch(
                                  value.toInt());
                              return DateFormat.Hm().format(date);
                            },
                            margin: 8,
                            // interval: 21,
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (context, value) {
                              return const TextStyle(color: light);
                            },
                          ),
                          rightTitles: SideTitles(showTitles: false),
                          topTitles: SideTitles(showTitles: false)),

                      lineBarsData: [
                        LineChartBarData(
                            colors: [active],
                            isCurved: true,
                            preventCurveOverShooting: true,
                            aboveBarData: BarAreaData(colors: [success]),
                            spots: walletData
                                .map((e) => FlSpot(e['date'], e['value']))
                                .toList())
                      ],
                      // read about it in the LineChartData section
                    ),
                    swapAnimationDuration:
                        const Duration(milliseconds: 150), // Optional
                    swapAnimationCurve: Curves.linear, // Optional
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AllActions extends StatelessWidget {
  const _AllActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ApiProvider.watch(context)?.model;
    var actions = model?.allActions ?? [];
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 600,
            decoration: BoxDecoration(
                color: dark, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          child: CustomText(
                            text: 'Actions',
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
                          headingRowColor:
                              MaterialStateColor.resolveWith((states) => dark),
                          dataRowColor:
                              MaterialStateColor.resolveWith((states) => dark),
                          headingTextStyle: const TextStyle(color: light),
                          dataTextStyle: const TextStyle(color: light),
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 300,
                          columns: [
                            const DataColumn2(
                              label: Text('Ticker',
                                  style: TextStyle(color: active)),
                              size: ColumnSize.L,
                            ),
                            const DataColumn2(
                              label: Text('Action',
                                  style: TextStyle(color: active)),
                              size: ColumnSize.L,
                            ),
                            const DataColumn2(
                              label: Text('Price',
                                  style: TextStyle(color: active)),
                              size: ColumnSize.L,
                            ),
                            const DataColumn2(
                              label: Text('Profit',
                                  style: TextStyle(color: active)),
                              size: ColumnSize.S,
                            ),
                          ],
                          rows: actions
                              .map(
                                (data) => DataRow(cells: [
                                  DataCell(Text(data['ticker'])),
                                  DataCell(Text(
                                    data['action'],
                                    style: TextStyle(
                                        color: data['action'] == 'Sell'
                                            ? success
                                            : danger),
                                  )),
                                  DataCell(
                                      Text(data['price'].toString() + '\$')),
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
            ),
          ),
        ],
      ),
    );
  }
}
