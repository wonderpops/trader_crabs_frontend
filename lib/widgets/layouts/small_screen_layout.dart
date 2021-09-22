import 'package:crabs_trade/helpers/local_navigator.dart';
import 'package:flutter/material.dart';

class SmallScreenLayout extends StatelessWidget {
  final String route;
  final String ticker;
  const SmallScreenLayout({Key? key, required this.route, this.ticker = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return localNavigator(
      route: route,
      ticker: ticker,
    );
  }
}
