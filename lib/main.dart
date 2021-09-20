import 'package:crabs_trade/constants/style.dart';
import 'package:crabs_trade/controllers/data_load_controller.dart';
import 'package:crabs_trade/helpers/main_navigation.dart';
import 'package:crabs_trade/helpers/session_model.dart';
import 'package:crabs_trade/widgets/auth/auth_model.dart';
import 'package:crabs_trade/widgets/auth/auth_widget.dart';
import 'package:crabs_trade/widgets/errors/not_found_error_widget.dart';
import 'package:crabs_trade/widgets/layouts/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  final sessionModel = SessionModel();
  Get.put(DataLoadController());
  var isAuth = await sessionModel.checkAuth();
  runApp(MyApp(
    sessionModel: sessionModel,
    isAuth: isAuth,
  ));
}

class MyApp extends StatelessWidget {
  final sessionModel;
  final bool isAuth;
  static final mainNavigation = MainNavigation();
  MyApp({Key? key, required this.sessionModel, required this.isAuth})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: mainNavigation.initialRoute(isAuth),
      title: 'Trader Crabs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: active,
        primaryColor: active,
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderSide: BorderSide(color: light)),
          labelStyle: TextStyle(color: active),
        ),
      ),
      onGenerateRoute: (settings) {
        if (settings.name == MainNavigationRoutesNames.auth) {
          return MaterialPageRoute(
              settings:
                  const RouteSettings(name: MainNavigationRoutesNames.auth),
              builder: (context) =>
                  AuthProvider(model: AuthModel(), child: const AuthWidget()));
        }
        if (settings.name == MainNavigationRoutesNames.dashboard) {
          return MaterialPageRoute(
              settings: const RouteSettings(
                  name: MainNavigationRoutesNames.dashboard),
              builder: (context) =>
                  MainLayout(route: MainNavigationRoutesNames.dashboard));
        }
        if (settings.name == MainNavigationRoutesNames.tickers) {
          return MaterialPageRoute(
              settings:
                  const RouteSettings(name: MainNavigationRoutesNames.tickers),
              builder: (context) =>
                  MainLayout(route: MainNavigationRoutesNames.tickers));
        }
        if (settings.name == MainNavigationRoutesNames.wallet) {
          return MaterialPageRoute(
              settings:
                  const RouteSettings(name: MainNavigationRoutesNames.wallet),
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
          ? MaterialPageRoute(builder: (context) => const PageNotFound())
          : MaterialPageRoute(
              builder: (context) =>
                  AuthProvider(model: AuthModel(), child: const AuthWidget())),
    );
  }
}
