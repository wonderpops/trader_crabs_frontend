import 'package:crabs_trade/constants/style.dart';
import 'package:crabs_trade/helpers/main_navigation.dart';
import 'package:crabs_trade/widgets/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class localNavigator extends StatelessWidget {
  final String route;
  const localNavigator({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (route) {
      case MainNavigationRoutesNames.dashboard:
        return const DashboardWidget();
      case MainNavigationRoutesNames.tickers:
        return Container(
            child: CustomText(
          text: route,
          color: active,
          size: 20,
        ));
      case MainNavigationRoutesNames.wallet:
        return Container(
            child: CustomText(
          text: route,
          color: active,
          size: 20,
        ));
      default:
        return Container(
            child: const CustomText(
          text: 'Unknown route',
          color: active,
          size: 20,
        ));
    }
  }
}
