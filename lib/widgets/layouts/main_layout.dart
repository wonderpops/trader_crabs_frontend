import 'package:crabs_trade/constants/style.dart';
import 'package:crabs_trade/helpers/session_model.dart';
import 'package:crabs_trade/widgets/auth/auth_model.dart';
import 'package:crabs_trade/widgets/auth/auth_widget.dart';
import 'package:crabs_trade/widgets/layouts/small_screen_layout.dart';
import 'package:crabs_trade/widgets/nav_bar/top_nav.dart';
import 'package:crabs_trade/widgets/side_menu/side_menu_widget.dart';
import 'package:flutter/material.dart';
import '../../helpers/responsiveness.dart';
import 'large_screen_layout.dart';

class MainLayout extends StatelessWidget {
  final sessionModel = SessionModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final String route;

  MainLayout({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occured',
                style: const TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            final isAuth = snapshot.data as bool;
            if (isAuth == true) {
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
            } else {
              return AuthProvider(
                  model: AuthModel(), child: const AuthWidget());
            }
          }
        }
        // Displaying LoadingSpinner to indicate waiting state
        return Container(
          color: dark,
          child: const Center(
            child: CircularProgressIndicator(
              backgroundColor: light,
              color: active,
            ),
          ),
        );
      },

      // Future that needs to be resolved
      // inorder to display something on the Canvas
      future: sessionModel.checkAuth(),
    );
  }
}
