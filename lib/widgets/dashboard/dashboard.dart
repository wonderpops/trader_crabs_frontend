import 'package:crabs_trade/constants/style.dart';
import 'package:crabs_trade/controllers/data_load_controller.dart';
import 'package:crabs_trade/helpers/custom_text.dart';
import 'package:crabs_trade/helpers/responsiveness.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DashboardWidget extends StatefulWidget {
  DashboardWidget({Key? key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  final DataLoadController c = Get.find();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await c.load_tickers();
    await c.load_actions();
    await c.load_wallet_history();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ResponsiveWidget.is_small_screen(context)
          ? SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_Tickers(), _WalletHistory(), _AllActions()],
            ))
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Tickers(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Container(
                                    // height: double.infinity,
                                    // color: Colors.red,
                                    child: _WalletHistory(),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Container(
                                    // height: 100,
                                    // color: Colors.blue,
                                    child: _AllActions(),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _Tickers extends StatelessWidget {
  _Tickers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DataLoadController c = Get.find();
    if (c.tickers.isEmpty) {
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
              final tickers = snapshot.data as List;
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                                (data) => _Ticker(
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
          // Displaying LoadingSpinner to indicate waiting state
          return Column(
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
                    children: const [
                      _TickerShimmer(),
                      _TickerShimmer(),
                      _TickerShimmer(),
                      _TickerShimmer(),
                      _TickerShimmer(),
                      _TickerShimmer(),
                      _TickerShimmer(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        future: c.load_tickers(),
      );
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                children: c.tickers
                    .map(
                      (data) => _Ticker(
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

class _Ticker extends StatelessWidget {
  final Map data;
  const _Ticker({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FluroRouter router = Get.find();
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: IntrinsicWidth(
        child: Container(
          height: 80,
          child: Stack(
            children: [
              Container(
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
                            color: data['status'] == 'Selling' ||
                                    data['status'] == 'Buying'
                                ? success
                                : light_grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    router.navigateTo(context, '/tickers/' + data['ticker'],
                        transition: TransitionType.fadeIn);
                  },
                  splashColor: light.withOpacity(.2),
                  hoverColor: light.withOpacity(.2),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    alignment: Alignment.center,
                    height: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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

class _TickerShimmer extends StatelessWidget {
  const _TickerShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: 200.0,
        height: 80,
        child: Container(
          width: 200.0,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: light.withOpacity(.2),
          ),
          child: Shimmer.fromColors(
            baseColor: light.withOpacity(.2),
            highlightColor: light_grey.withOpacity(.2),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: danger,
                    ),
                    width: 60,
                    height: 60,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Container(
                          decoration: BoxDecoration(
                              color: active,
                              borderRadius: BorderRadius.circular(20)),
                          height: 10,
                          width: 90,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Container(
                          decoration: BoxDecoration(
                              color: active,
                              borderRadius: BorderRadius.circular(20)),
                          height: 10,
                          width: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Container(
                          decoration: BoxDecoration(
                              color: active,
                              borderRadius: BorderRadius.circular(20)),
                          height: 10,
                          width: 60,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WalletData {
  WalletData(this.date, this.action);
  final DateTime date;
  final double action;
}

class _WalletHistory extends StatelessWidget {
  _WalletHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DataLoadController c = Get.find();

    if (c.wallet_history.isEmpty) {
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
            final wallet_history = snapshot.data as List;
            var wallet_data = wallet_history
                .map((e) => WalletData(e['date'], e['value']))
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
                    crossAxisAlignment:
                        ResponsiveWidget.is_small_screen(context)
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.stretch,
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
                        child: CustomText(
                          text: c.wallet['money'] != null
                              ? 'Total: ' + c.wallet['money'].toString() + '\$'
                              : '',
                          color: active,
                          size: 20,
                        ),
                      ),
                      ResponsiveWidget.is_small_screen(context)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 300,
                                width: double.maxFinite,
                                child: SfCartesianChart(
                                    tooltipBehavior: TooltipBehavior(
                                        enable: true, format: 'point.y\$'),
                                    zoomPanBehavior: ZoomPanBehavior(
                                        enableSelectionZooming: true,
                                        enableMouseWheelZooming: true),
                                    primaryXAxis: DateTimeAxis(
                                        intervalType: DateTimeIntervalType.auto,
                                        dateFormat: DateFormat.yMd()),
                                    series: <
                                        SplineAreaSeries<WalletData, DateTime>>[
                                      SplineAreaSeries<WalletData, DateTime>(
                                          name: 'Money',
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
                                          dataSource: wallet_data,
                                          xValueMapper:
                                              (WalletData action, _) =>
                                                  action.date,
                                          yValueMapper:
                                              (WalletData action, _) =>
                                                  action.action)
                                    ]),
                              ),
                            )
                          : Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.maxFinite,
                                  child: SfCartesianChart(
                                      tooltipBehavior: TooltipBehavior(
                                          enable: true, format: 'point.y\$'),
                                      zoomPanBehavior: ZoomPanBehavior(
                                          enableSelectionZooming: true,
                                          enableMouseWheelZooming: true),
                                      primaryXAxis: DateTimeAxis(
                                          intervalType:
                                              DateTimeIntervalType.auto,
                                          dateFormat: DateFormat.yMd()),
                                      series: <
                                          SplineAreaSeries<WalletData,
                                              DateTime>>[
                                        SplineAreaSeries<WalletData, DateTime>(
                                            name: 'Money',
                                            splineType: SplineType.monotonic,
                                            color: active.withOpacity(.2),
                                            borderWidth: 4,
                                            markerSettings:
                                                const MarkerSettings(
                                                    isVisible: true,
                                                    // Marker shape is set to diamond
                                                    shape:
                                                        DataMarkerType.diamond),
                                            borderGradient:
                                                const LinearGradient(colors: <
                                                    Color>[
                                              Color.fromRGBO(50, 40, 200, 1),
                                              Color.fromRGBO(50, 100, 240, 1)
                                            ], stops: <double>[
                                              0.2,
                                              0.9
                                            ]),
                                            dataSource: wallet_data,
                                            xValueMapper:
                                                (WalletData action, _) =>
                                                    action.date,
                                            yValueMapper:
                                                (WalletData action, _) =>
                                                    action.action)
                                      ]),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const _WalletHistoryShimmer();
        },
        future: c.load_wallet_history(),
      );
    }

    // print(walletData.toString());
    //TODO don't calculate wallet_data while build
    var wallet_data =
        c.wallet_history.map((e) => WalletData(e['date'], e['value'])).toList();
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        width: double.maxFinite,
        decoration:
            BoxDecoration(color: dark, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: ResponsiveWidget.is_small_screen(context)
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.stretch,
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
                child: CustomText(
                  text: c.wallet['money'] != null
                      ? 'Total: ' + c.wallet['money'].toString() + '\$'
                      : '',
                  color: active,
                  size: 20,
                ),
              ),
              ResponsiveWidget.is_small_screen(context)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 300,
                        width: double.maxFinite,
                        child: SfCartesianChart(
                            tooltipBehavior: TooltipBehavior(
                                enable: true, format: 'point.y\$'),
                            zoomPanBehavior: ZoomPanBehavior(
                                enableSelectionZooming: true,
                                enableMouseWheelZooming: true),
                            primaryXAxis: DateTimeAxis(
                                intervalType: DateTimeIntervalType.auto,
                                dateFormat: DateFormat.yMd()),
                            series: <SplineAreaSeries<WalletData, DateTime>>[
                              SplineAreaSeries<WalletData, DateTime>(
                                  name: 'Money',
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
                                  dataSource: wallet_data,
                                  xValueMapper: (WalletData action, _) =>
                                      action.date,
                                  yValueMapper: (WalletData action, _) =>
                                      action.action)
                            ]),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.maxFinite,
                          child: SfCartesianChart(
                              tooltipBehavior: TooltipBehavior(
                                  enable: true, format: 'point.y\$'),
                              zoomPanBehavior: ZoomPanBehavior(
                                  enableSelectionZooming: true,
                                  enableMouseWheelZooming: true),
                              primaryXAxis: DateTimeAxis(
                                  intervalType: DateTimeIntervalType.auto,
                                  dateFormat: DateFormat.yMd()),
                              series: <SplineAreaSeries<WalletData, DateTime>>[
                                SplineAreaSeries<WalletData, DateTime>(
                                    name: 'Money',
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
                                    dataSource: wallet_data,
                                    xValueMapper: (WalletData action, _) =>
                                        action.date,
                                    yValueMapper: (WalletData action, _) =>
                                        action.action)
                              ]),
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

class _WalletHistoryShimmer extends StatelessWidget {
  const _WalletHistoryShimmer({Key? key}) : super(key: key);

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
            crossAxisAlignment: ResponsiveWidget.is_small_screen(context)
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.stretch,
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
              ResponsiveWidget.is_small_screen(context)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 338,
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
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      height: 20,
                                      width: 100,
                                    ),
                                  ),
                                  Container(
                                    height: 310,
                                    decoration: BoxDecoration(
                                        color: active,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                ],
                              ))),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
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
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        height: 20,
                                        width: 100,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: active,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    ),
                                  ],
                                ))),
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
  _AllActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DataLoadController c = Get.find();
    if (c.actions.isEmpty || c.ticker_info != {}) {
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
            final actions = snapshot.data as List;
            return Container(
              child: Column(
                crossAxisAlignment: ResponsiveWidget.is_small_screen(context)
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.stretch,
                children: [
                  ResponsiveWidget.is_small_screen(context)
                      ? Container(
                          height: 400,
                          decoration: BoxDecoration(
                              color: dark,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        dataRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => dark),
                                        headingTextStyle:
                                            const TextStyle(color: light),
                                        dataTextStyle:
                                            const TextStyle(color: light),
                                        columnSpacing: 12,
                                        horizontalMargin: 12,
                                        minWidth: 300,
                                        columns: [
                                          const DataColumn2(
                                            label: Text('Ticker',
                                                style:
                                                    TextStyle(color: active)),
                                            size: ColumnSize.L,
                                          ),
                                          const DataColumn2(
                                            label: Text('Action',
                                                style:
                                                    TextStyle(color: active)),
                                            size: ColumnSize.L,
                                          ),
                                          const DataColumn2(
                                            label: Text('Price',
                                                style:
                                                    TextStyle(color: active)),
                                            size: ColumnSize.L,
                                          ),
                                          const DataColumn2(
                                            label: Text('Profit',
                                                style:
                                                    TextStyle(color: active)),
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
                                                      color: data['action'] ==
                                                              'Sell'
                                                          ? success
                                                          : danger),
                                                )),
                                                DataCell(Text(
                                                    data['price'].toString() +
                                                        '\$')),
                                                DataCell(Text(
                                                  data['profit'].toString() +
                                                      '\$',
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
                        )
                      : Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: dark,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          dataRowColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) => dark),
                                          headingTextStyle:
                                              const TextStyle(color: light),
                                          dataTextStyle:
                                              const TextStyle(color: light),
                                          columnSpacing: 12,
                                          horizontalMargin: 12,
                                          minWidth: 300,
                                          columns: [
                                            const DataColumn2(
                                              label: Text('Ticker',
                                                  style:
                                                      TextStyle(color: active)),
                                              size: ColumnSize.L,
                                            ),
                                            const DataColumn2(
                                              label: Text('Action',
                                                  style:
                                                      TextStyle(color: active)),
                                              size: ColumnSize.L,
                                            ),
                                            const DataColumn2(
                                              label: Text('Price',
                                                  style:
                                                      TextStyle(color: active)),
                                              size: ColumnSize.L,
                                            ),
                                            const DataColumn2(
                                              label: Text('Profit',
                                                  style:
                                                      TextStyle(color: active)),
                                              size: ColumnSize.S,
                                            ),
                                          ],
                                          rows: actions
                                              .map(
                                                (data) => DataRow(cells: [
                                                  DataCell(
                                                      Text(data['ticker'])),
                                                  DataCell(Text(
                                                    data['action'],
                                                    style: TextStyle(
                                                        color: data['action'] ==
                                                                'Sell'
                                                            ? success
                                                            : danger),
                                                  )),
                                                  DataCell(Text(
                                                      data['price'].toString() +
                                                          '\$')),
                                                  DataCell(Text(
                                                    data['profit'].toString() +
                                                        '\$',
                                                    style: TextStyle(
                                                        color: data['profit'] >
                                                                0
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
                        ),
                ],
              ),
            );
          }
          return const _ActionsShimmer();
        },
        future: c.load_actions(),
      );
    }
    return Container(
      child: Column(
        crossAxisAlignment: ResponsiveWidget.is_small_screen(context)
            ? CrossAxisAlignment.stretch
            : CrossAxisAlignment.start,
        children: [
          ResponsiveWidget.is_small_screen(context)
              ? Container(
                  height: 400,
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
                                headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => dark),
                                dataRowColor: MaterialStateColor.resolveWith(
                                    (states) => dark),
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
                                rows: c.actions
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
                )
              : Expanded(
                  child: Container(
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
                                  rows: c.actions
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
        crossAxisAlignment: ResponsiveWidget.is_small_screen(context)
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.stretch,
        children: [
          ResponsiveWidget.is_small_screen(context)
              ? Container(
                  decoration: BoxDecoration(
                      color: dark, borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              height: 300,
                              decoration: BoxDecoration(
                                color: light.withOpacity(.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
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
                    ),
                  ),
                )
              : Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: dark, borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: light.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Shimmer.fromColors(
                                      baseColor: light.withOpacity(.2),
                                      highlightColor:
                                          light_grey.withOpacity(.2),
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
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

// class _Tickers extends StatelessWidget {
//   _Tickers({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final Controller c = Get.find();
//     if (c.tickers.value.isEmpty) {
//       c.load_tickers();
//     }
//     return ValueListenableBuilder(
//       valueListenable: c.tickers,
//       builder: (context, List value, widget) {
//         return Container(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 child: const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 8),
//                   child: CustomText(
//                     text: 'Tickers',
//                     color: light,
//                     size: 22,
//                   ),
//                 ),
//               ),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: value
//                         .map(
//                           (data) => _Ticker(
//                             data: data,
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }