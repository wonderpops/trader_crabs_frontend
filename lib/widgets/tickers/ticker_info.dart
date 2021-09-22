import 'package:crabs_trade/constants/style.dart';
import 'package:crabs_trade/controllers/data_load_controller.dart';
import 'package:crabs_trade/helpers/custom_text.dart';
import 'package:crabs_trade/helpers/responsiveness.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TickerInfo extends StatefulWidget {
  final String ticker;
  const TickerInfo({Key? key, required this.ticker}) : super(key: key);

  @override
  _TickerInfoState createState() => _TickerInfoState();
}

class _TickerInfoState extends State<TickerInfo> {
  @override
  Widget build(BuildContext context) {
    final DataLoadController c = Get.find();
    final RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    void _onRefresh() async {
      // monitor network fetch
      await c.load_ticker_info(widget.ticker);
      await c.load_actions();
      await c.load_wallet_history();
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
      setState(() {});
    }

    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: _TickerInfo(
                ticker: widget.ticker,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ResponsiveWidget.is_small_screen(context)
                  ? Column(
                      children: [
                        _TickerHistory(ticker: widget.ticker),
                        _TickerActions(ticker: widget.ticker)
                      ],
                    )
                  : Row(
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
                                child: Container(
                                  child: _TickerHistory(ticker: widget.ticker),
                                  // width: 700,
                                ),
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
                                child: _TickerActions(ticker: widget.ticker),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TickerInfo extends StatefulWidget {
  final String ticker;
  const _TickerInfo({Key? key, required this.ticker}) : super(key: key);

  @override
  __TickerInfoState createState() => __TickerInfoState();
}

class __TickerInfoState extends State<_TickerInfo> {
  @override
  Widget build(BuildContext context) {
    final DataLoadController c = Get.find();
    if (c.ticker_info['ticker'] == widget.ticker) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: c.ticker_info['name'],
              color: light,
              size: 20,
            ),
            Switch(
                hoverColor: light.withOpacity(.1),
                value: c.ticker_info['isOn'],
                onChanged: (state) async {
                  state = !c.ticker_info['isOn'];
                  print(state);
                  await c.set_ticker_status(c.ticker_info['ticker'], state);
                  setState(() {});
                })
          ],
        ),
      );
    }
    return FutureBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            //TODO error view
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            final ticker = snapshot.data as Map;
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: ticker['name'],
                    color: light,
                    size: 20,
                  ),
                  Switch(
                      hoverColor: light.withOpacity(.1),
                      value: ticker['isOn'],
                      onChanged: (state) async {
                        state = !ticker['isOn'];
                        print(state);
                        await c.set_ticker_status(ticker['ticker'], state);
                        setState(() {});
                      })
                ],
              ),
            );
          }
        }
        // Displaying LoadingSpinner to indicate waiting state
        return Container(
            child: Shimmer.fromColors(
                baseColor: light.withOpacity(.2),
                highlightColor: light_grey.withOpacity(.2),
                child: Container()));
      },
      future: c.load_ticker_info(widget.ticker),
    );
  }
}

class TickerData {
  TickerData(this.date, this.a, this.k, this.d);
  final DateTime date;
  final double a;
  final double k;
  final double d;
}

class _TickerHistory extends StatelessWidget {
  final String ticker;
  _TickerHistory({Key? key, required this.ticker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DataLoadController c = Get.find();

    if (c.ticker_history.isEmpty || c.ticker_info['ticker'] != ticker) {
      return FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(
              //TODO error view
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );
          } else if (snapshot.hasData) {
            final ticker_history = snapshot.data as List;
            var ticker_data = ticker_history
                .map((e) => TickerData(e['date'], e['a'], e['k'], e['d']))
                .toList();
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: dark, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 16, left: 8),
                        child: CustomText(
                          text: 'Ticker history',
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
                        child: CustomText(
                          text: 'Profit: ' +
                              c.ticker_info['profit'].toString() +
                              '\$',
                          color: active,
                          size: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: ResponsiveWidget.is_small_screen(context)
                              ? 600
                              : 660,
                          width: double.maxFinite,
                          child: Column(
                            children: [
                              SfCartesianChart(
                                  tooltipBehavior: TooltipBehavior(
                                      enable: true, format: 'point.y\$'),
                                  zoomPanBehavior: ZoomPanBehavior(
                                      enableSelectionZooming: true,
                                      enableMouseWheelZooming: true),
                                  primaryXAxis: DateTimeAxis(
                                      intervalType: DateTimeIntervalType.auto,
                                      dateFormat: DateFormat.yMd()),
                                  series: <
                                      SplineAreaSeries<TickerData, DateTime>>[
                                    SplineAreaSeries<TickerData, DateTime>(
                                        name: 'Price',
                                        splineType: SplineType.monotonic,
                                        color: active.withOpacity(.2),
                                        borderWidth: 4,
                                        markerSettings: const MarkerSettings(
                                            isVisible: true,
                                            // Marker shape is set to diamond
                                            shape: DataMarkerType.diamond),
                                        borderGradient: const LinearGradient(
                                            colors: <Color>[
                                              Color.fromRGBO(50, 40, 200, 1),
                                              Color.fromRGBO(50, 100, 240, 1)
                                            ],
                                            stops: <double>[
                                              0.2,
                                              0.9
                                            ]),
                                        dataSource: ticker_data,
                                        xValueMapper: (TickerData action, _) =>
                                            action.date,
                                        yValueMapper: (TickerData action, _) =>
                                            action.a)
                                  ]),
                              SfCartesianChart(
                                  tooltipBehavior: TooltipBehavior(
                                      enable: true, format: 'point.y%'),
                                  zoomPanBehavior: ZoomPanBehavior(
                                      enableSelectionZooming: true,
                                      enableMouseWheelZooming: true),
                                  primaryXAxis: DateTimeAxis(
                                      intervalType: DateTimeIntervalType.auto,
                                      dateFormat: DateFormat.yMd()),
                                  series: <LineSeries<TickerData, DateTime>>[
                                    LineSeries<TickerData, DateTime>(
                                        name: '%K',
                                        color: Colors.orange.withOpacity(.4),
                                        markerSettings: const MarkerSettings(
                                            isVisible: true,
                                            // Marker shape is set to diamond
                                            shape: DataMarkerType.diamond),
                                        dataSource: ticker_data,
                                        xValueMapper: (TickerData action, _) =>
                                            action.date,
                                        yValueMapper: (TickerData action, _) =>
                                            action.k),
                                    LineSeries<TickerData, DateTime>(
                                        name: '%D',
                                        color: Colors.blue.withOpacity(.4),
                                        markerSettings: const MarkerSettings(
                                            isVisible: true,
                                            // Marker shape is set to diamond
                                            shape: DataMarkerType.diamond),
                                        dataSource: ticker_data,
                                        xValueMapper: (TickerData action, _) =>
                                            action.date,
                                        yValueMapper: (TickerData action, _) =>
                                            action.d),
                                    LineSeries<TickerData, DateTime>(
                                        name: '90%',
                                        color: success.withOpacity(.4),
                                        dataSource: ticker_data,
                                        xValueMapper: (TickerData action, _) =>
                                            action.date,
                                        yValueMapper: (TickerData action, _) =>
                                            90),
                                    LineSeries<TickerData, DateTime>(
                                        name: '10%',
                                        color: success.withOpacity(.4),
                                        dataSource: ticker_data,
                                        xValueMapper: (TickerData action, _) =>
                                            action.date,
                                        yValueMapper: (TickerData action, _) =>
                                            10),
                                  ])
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const _TickerHistoryShimmer();
        },
        future: c.load_ticker_history(ticker, 1),
      );
    }

    // print(walletData.toString());
    //TODO don't calculate wallet_data while build
    var ticker_data = c.ticker_history
        .map((e) => TickerData(e['date'], e['a'], e['k'], e['d']))
        .toList();
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        width: double.maxFinite,
        decoration:
            BoxDecoration(color: dark, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16, left: 8),
                child: CustomText(
                  text: 'Ticker history',
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
                child: CustomText(
                  text: 'Profit: ' + c.ticker_info['profit'].toString() + '\$',
                  color: active,
                  size: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: ResponsiveWidget.is_small_screen(context) ? 600 : 660,
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      SfCartesianChart(
                          tooltipBehavior: TooltipBehavior(
                              enable: true, format: 'point.y\$'),
                          zoomPanBehavior: ZoomPanBehavior(
                              enableSelectionZooming: true,
                              enableMouseWheelZooming: true),
                          primaryXAxis: DateTimeAxis(
                              intervalType: DateTimeIntervalType.auto,
                              dateFormat: DateFormat.yMd()),
                          series: <SplineAreaSeries<TickerData, DateTime>>[
                            SplineAreaSeries<TickerData, DateTime>(
                                name: 'Price',
                                splineType: SplineType.monotonic,
                                color: active.withOpacity(.2),
                                borderWidth: 4,
                                markerSettings: const MarkerSettings(
                                    isVisible: true,
                                    // Marker shape is set to diamond
                                    shape: DataMarkerType.diamond),
                                borderGradient: const LinearGradient(
                                    colors: <Color>[
                                      Color.fromRGBO(50, 40, 200, 1),
                                      Color.fromRGBO(50, 100, 240, 1)
                                    ],
                                    stops: <double>[
                                      0.2,
                                      0.9
                                    ]),
                                dataSource: ticker_data,
                                xValueMapper: (TickerData action, _) =>
                                    action.date,
                                yValueMapper: (TickerData action, _) =>
                                    action.a)
                          ]),
                      SfCartesianChart(
                          tooltipBehavior:
                              TooltipBehavior(enable: true, format: 'point.y%'),
                          zoomPanBehavior: ZoomPanBehavior(
                              enableSelectionZooming: true,
                              enableMouseWheelZooming: true),
                          primaryXAxis: DateTimeAxis(
                              intervalType: DateTimeIntervalType.auto,
                              dateFormat: DateFormat.yMd()),
                          series: <LineSeries<TickerData, DateTime>>[
                            LineSeries<TickerData, DateTime>(
                                name: '%K',
                                color: Colors.orange.withOpacity(.4),
                                markerSettings: const MarkerSettings(
                                    isVisible: true,
                                    // Marker shape is set to diamond
                                    shape: DataMarkerType.diamond),
                                dataSource: ticker_data,
                                xValueMapper: (TickerData action, _) =>
                                    action.date,
                                yValueMapper: (TickerData action, _) =>
                                    action.k),
                            LineSeries<TickerData, DateTime>(
                                name: '%D',
                                color: Colors.blue.withOpacity(.4),
                                markerSettings: const MarkerSettings(
                                    isVisible: true,
                                    // Marker shape is set to diamond
                                    shape: DataMarkerType.diamond),
                                dataSource: ticker_data,
                                xValueMapper: (TickerData action, _) =>
                                    action.date,
                                yValueMapper: (TickerData action, _) =>
                                    action.d),
                            LineSeries<TickerData, DateTime>(
                                name: '90%',
                                color: success.withOpacity(.4),
                                dataSource: ticker_data,
                                xValueMapper: (TickerData action, _) =>
                                    action.date,
                                yValueMapper: (TickerData action, _) => 90),
                            LineSeries<TickerData, DateTime>(
                                name: '10%',
                                color: success.withOpacity(.4),
                                dataSource: ticker_data,
                                xValueMapper: (TickerData action, _) =>
                                    action.date,
                                yValueMapper: (TickerData action, _) => 10),
                          ])
                    ],
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

class _TickerHistoryShimmer extends StatelessWidget {
  const _TickerHistoryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        width: double.maxFinite,
        decoration:
            BoxDecoration(color: dark, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16, left: 8),
                child: CustomText(
                  text: 'Wallet history',
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
                    height:
                        ResponsiveWidget.is_small_screen(context) ? 640 : 740,
                    width: double.maxFinite,
                    child: Shimmer.fromColors(
                        baseColor: light.withOpacity(.2),
                        highlightColor: light_grey.withOpacity(.2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: active,
                                    borderRadius: BorderRadius.circular(20)),
                                height: 20,
                                width: 100,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: active,
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ],
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TickerActions extends StatelessWidget {
  final String ticker;
  _TickerActions({Key? key, required this.ticker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DataLoadController c = Get.find();
    if (c.ticker_actions.isEmpty || c.ticker_info['ticker'] != ticker) {
      return FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            //TODO error view
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );
          } else if (snapshot.hasData) {
            final ticker_actions = snapshot.data as List;
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height:
                        ResponsiveWidget.is_small_screen(context) ? 300 : 787,
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
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
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
                                      MaterialStateColor.resolveWith(
                                          (states) => dark),
                                  dataRowColor: MaterialStateColor.resolveWith(
                                      (states) => dark),
                                  headingTextStyle:
                                      const TextStyle(color: light),
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
                                  rows: ticker_actions
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
                                          DataCell(Text(
                                              data['price'].toString() + '\$')),
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
          return const _ActionsShimmer();
        },
        future: c.load_ticker_actions(ticker, 1),
      );
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: ResponsiveWidget.is_small_screen(context) ? 340 : 787,
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
                          rows: c.ticker_actions
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

class _ActionsShimmer extends StatelessWidget {
  const _ActionsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
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
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: light.withOpacity(.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 744,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Shimmer.fromColors(
                                baseColor: light.withOpacity(.2),
                                highlightColor: light_grey.withOpacity(.2),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: active,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: active,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: active,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: active,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: active,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: active,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: active,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: active,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: active,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: active,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: active,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: active,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                    Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: active,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
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
