import 'package:crabs_trade/helpers/session_model.dart';
import 'package:crabs_trade/widgets/auth/auth_model.dart';
import 'package:crabs_trade/widgets/auth/auth_widget.dart';
import 'package:crabs_trade/widgets/layouts/main_layout.dart';
import 'package:flutter/material.dart';

abstract class MainNavigationRoutesNames {
  static const auth = '/auth';
  static const dashboard = '/dashboard';
  static const tickers = '/tickers';
  static const wallet = '/wallet';
}

class MainNavigation {
  String initialRoute(bool isAuth) => isAuth
      ? MainNavigationRoutesNames.dashboard
      : MainNavigationRoutesNames.auth;
}
