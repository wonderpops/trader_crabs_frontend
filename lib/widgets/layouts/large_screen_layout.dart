import 'package:crabs_trade/constants/style.dart';
import 'package:crabs_trade/helpers/local_navigator.dart';
import 'package:crabs_trade/widgets/side_menu/side_menu_widget.dart';
import 'package:flutter/material.dart';

class LargeScreenLayout extends StatelessWidget {
  final String route;
  const LargeScreenLayout({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SideMenuWidget(
            route: route,
          ),
        ),
        Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: dark_light,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: localNavigator(route: route),
                ),
              ),
            ))
      ],
    );
  }
}
