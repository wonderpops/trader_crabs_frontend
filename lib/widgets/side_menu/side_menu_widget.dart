import 'package:crabs_trade/constants/style.dart';
import 'package:crabs_trade/helpers/custom_text.dart';
import 'package:crabs_trade/helpers/responsiveness.dart';
import 'package:flutter/material.dart';

class SideMenuWidget extends StatefulWidget {
  final String route;
  SideMenuWidget({Key? key, required this.route}) : super(key: key);

  @override
  _SideMenuWidgetState createState() => _SideMenuWidgetState();
}

class MenuItem {
  final String title;
  final IconData icon;
  final String route;

  const MenuItem(
    this.title,
    this.icon,
    this.route,
  );
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  final List<MenuItem> _menuItems = [
    const MenuItem(
      'Dashboard',
      Icons.space_dashboard_outlined,
      '/dashboard',
    ),
    const MenuItem(
      'Tickers',
      Icons.trending_up,
      '/tickers',
    ),
    const MenuItem(
      'Wallet',
      Icons.account_balance_wallet_outlined,
      '/wallet',
    ),
    const MenuItem(
      'Signout',
      Icons.exit_to_app,
      '/auth',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var route = widget.route;
    var _width = MediaQuery.of(context).size.width;
    return Container(
        padding: const EdgeInsets.only(top: 6),
        color: dark,
        child: ListView(
          children: [
            if (ResponsiveWidget.is_small_screen(context))
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: _width / 48,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.paid,
                          color: active,
                        ),
                      ),
                      const Flexible(
                          child: CustomText(
                        text: 'Crabs Trade',
                        size: 20,
                        weight: FontWeight.bold,
                        color: light,
                      )),
                      SizedBox(
                        width: _width / 48,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Divider(
                    color: active.withOpacity(.1),
                  ),
                ],
              ),
            _SideMenuItems(menuItems: _menuItems, activeRoute: route)
          ],
        ));
  }
}

class _SideMenuItems extends StatelessWidget {
  final List<MenuItem> menuItems;
  final String activeRoute;
  const _SideMenuItems(
      {Key? key, required this.menuItems, required this.activeRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: menuItems
          .map((data) => _SideMenuItem(
                data: data,
                activeRoute: activeRoute,
              ))
          .toList(),
    );
  }
}

class _SideMenuItem extends StatelessWidget {
  final MenuItem data;
  final String activeRoute;
  const _SideMenuItem({Key? key, required this.data, required this.activeRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Container(
        height: 60,
        child: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: (activeRoute == data.route)
                        ? dark_light
                        : Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: (activeRoute == data.route)
                            ? active.withOpacity(0.3)
                            : Colors.transparent,
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                      ),
                    ]),
                alignment: Alignment.center,
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(data.icon,
                          color: (activeRoute == data.route) ? active : light),
                      const SizedBox(width: 5),
                      CustomText(
                          text: data.title,
                          size: (activeRoute == data.route) ? 20 : 16,
                          color: (activeRoute == data.route) ? active : light),
                    ],
                  ),
                )),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(data.route);
                },
                splashColor: (activeRoute == data.route)
                    ? Colors.transparent
                    : active.withOpacity(.3),
                hoverColor: (activeRoute == data.route)
                    ? Colors.transparent
                    : active.withOpacity(.3),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
