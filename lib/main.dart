import 'package:crabs_trade/constants/style.dart';
import 'package:crabs_trade/controllers/data_load_controller.dart';
import 'package:crabs_trade/helpers/main_navigation.dart';
import 'package:crabs_trade/helpers/session_model.dart';
import 'package:crabs_trade/widgets/errors/not_found_error_widget.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'helpers/routes.dart';

void main() async {
  final sessionModel = SessionModel();
  Get.put(DataLoadController());
  Get.put(FluroRouter());
  final FluroRouter router = Get.find();
  Routes.configureRoutes(router);
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
    final FluroRouter router = Get.find();
    return MaterialApp(
      initialRoute: mainNavigation.initialRoute(isAuth),
      title: 'Trader Crabs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: active,
        primaryColor: active,
        dividerColor: light.withOpacity(.2),
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderSide: BorderSide(color: light)),
          labelStyle: TextStyle(color: active),
        ),
      ),
      onGenerateRoute: router.generator,
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (context) => const PageNotFound()),
    );
  }
}
