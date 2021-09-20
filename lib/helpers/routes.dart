import 'package:crabs_trade/widgets/errors/not_found_error_widget.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import './route_handlers.dart';

class Routes {
  static String root = '/';
  static String signin = '/signin';
  static String dashboard = '/dashboard';
  static String tickers = '/tickers';
  static String ticker = '/tickers/:name';
  static String wallet = '/wallet';

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      print('ROUTE WAS NOT FOUND !!!');
      return const PageNotFound();
    });
    //! root = dashboard???
    router.define(root, handler: dashboardHandler);
    router.define(signin, handler: signinHandler);
    router.define(dashboard, handler: dashboardHandler);
    router.define(tickers, handler: tickersHandler);
    router.define(ticker,
        handler: tickerHandler, transitionType: TransitionType.inFromLeft);
    router.define(wallet, handler: walletHandler);
  }
}
