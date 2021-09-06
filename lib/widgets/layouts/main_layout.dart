import 'package:crabs_trade/constants/style.dart';
import 'package:crabs_trade/widgets/layouts/small_screen_layout.dart';
import 'package:crabs_trade/widgets/nav_bar/top_nav.dart';
import 'package:crabs_trade/widgets/side_menu/side_menu_widget.dart';
import 'package:flutter/material.dart';
import '../../helpers/responsiveness.dart';
import 'large_screen_layout.dart';

class MainLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final String route;

  MainLayout({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: dark,
      appBar: topNavBar(context, _scaffoldKey),
      drawer: Drawer(
        child: SideMenuWidget(
          route: route,
        ),
      ),
      body: ResponsiveWidget(
          largeScreen: LargeScreenLayout(
            route: route,
          ),
          mediumScreen: LargeScreenLayout(
            route: route,
          ),
          smallScreen: const SmallScreenLayout()),
    );
  }
}
