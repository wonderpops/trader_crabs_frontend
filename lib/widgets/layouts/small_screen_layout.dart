import 'package:crabs_trade/helpers/local_navigator.dart';
import 'package:flutter/material.dart';

class SmallScreenLayout extends StatelessWidget {
  final route;
  const SmallScreenLayout({Key? key, this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return localNavigator(route: route);
  }
}
