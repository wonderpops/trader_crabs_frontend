import 'dart:html' as html;
import 'package:crabs_trade/constants/animations.dart';
import 'package:crabs_trade/constants/style.dart';
import 'package:crabs_trade/domain/domain_providers/session_data_provider.dart';
import 'package:crabs_trade/helpers/main_navigation.dart';
import 'package:crabs_trade/helpers/session_model.dart';
import 'package:crabs_trade/widgets/auth/auth_model.dart';
import 'package:crabs_trade/widgets/auth/auth_widget.dart';
import 'package:crabs_trade/widgets/errors/not_found_error_widget.dart';
import 'package:crabs_trade/widgets/layouts/main_layout.dart';
import 'package:flutter/material.dart';

void main() async {
  final sessionModel = SessionModel();
  bool isAuth = await sessionModel.checkAuth();
  final sessionDataProvider = SessionDataProvider();
  runApp(MyApp(
    sessionModel: sessionModel,
    isAuth: isAuth,
  ));
}

class MyApp extends StatelessWidget {
  final sessionModel;
  bool isAuth;
  static final mainNavigation = MainNavigation();
  MyApp({Key? key, required this.sessionModel, required this.isAuth})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: mainNavigation.initialRoute(isAuth),
      title: 'Crabs trade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: active,
        primaryColor: active,
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderSide: BorderSide(color: light)),
          labelStyle: TextStyle(color: active),
        ),
      ),
      onGenerateRoute: (settings) {
        if (settings.name == MainNavigationRoutesNames.auth) {
          return MaterialPageRoute(
              settings: RouteSettings(name: MainNavigationRoutesNames.auth),
              builder: (context) =>
                  AuthProvider(model: AuthModel(), child: const AuthWidget()));
        }
        if (settings.name == MainNavigationRoutesNames.dashboard) {
          return MaterialPageRoute(
              settings:
                  RouteSettings(name: MainNavigationRoutesNames.dashboard),
              builder: (context) =>
                  MainLayout(route: MainNavigationRoutesNames.dashboard));
        }
        if (settings.name == MainNavigationRoutesNames.tickers) {
          return MaterialPageRoute(
              settings: RouteSettings(name: MainNavigationRoutesNames.tickers),
              builder: (context) =>
                  MainLayout(route: MainNavigationRoutesNames.tickers));
        }
        if (settings.name == MainNavigationRoutesNames.wallet) {
          return MaterialPageRoute(
              settings: RouteSettings(name: MainNavigationRoutesNames.wallet),
              builder: (context) =>
                  MainLayout(route: MainNavigationRoutesNames.wallet));
        }

        // if (settings.name == "/auth") {
        //   return PageRouteBuilder(
        //     settings:
        //         settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
        //     pageBuilder: (
        //       BuildContext context,
        //       Animation<double> animation,
        //       Animation<double> secondaryAnimation,
        //     ) =>
        //         AuthWidget(),
        //     transitionsBuilder: (
        //       BuildContext context,
        //       Animation<double> animation,
        //       Animation<double> secondaryAnimation,
        //       Widget child,
        //     ) =>
        //         SlideTransition(
        //       position: Tween<Offset>(
        //         begin: const Offset(-1, 0),
        //         end: Offset.zero,
        //       ).animate(animation),
        //       child: child,
        //     ),
        //   );
        // }
      },
      onUnknownRoute: (settings) => sessionModel.checkAuth() == true
          ? MaterialPageRoute(builder: (context) => PageNotFound())
          : MaterialPageRoute(
              builder: (context) =>
                  AuthProvider(model: AuthModel(), child: const AuthWidget())),
    );
  }
}
