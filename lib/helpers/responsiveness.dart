import 'package:flutter/material.dart';

const int large_screen_size = 1366;
const int medium_screen_size = 768;
const int small_screen_size = 360;
const int custom_screen_size = 1100;

class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget mediumScreen;
  final Widget smallScreen;

  const ResponsiveWidget({
    Key? key,
    required this.largeScreen,
    required this.mediumScreen,
    required this.smallScreen,
  }) : super(key: key);

  static bool is_small_screen(BuildContext context) =>
      MediaQuery.of(context).size.width < medium_screen_size;

  static bool isMediumScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= medium_screen_size &&
      MediaQuery.of(context).size.width < large_screen_size;

  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= large_screen_size;

  static bool isCustomScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= medium_screen_size &&
      MediaQuery.of(context).size.width <= custom_screen_size;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var _width = constraints.maxWidth;

      if (_width >= large_screen_size) {
        return largeScreen;
      } else if (_width < large_screen_size && _width >= medium_screen_size) {
        return mediumScreen;
      } else {
        return smallScreen;
      }
    });
  }
}
