import 'package:crabs_trade/widgets/auth/auth_model.dart';
import 'package:crabs_trade/widgets/auth/auth_widget.dart';
import 'package:crabs_trade/widgets/layouts/main_layout.dart';
import 'package:flutter/painting.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

var signinHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return AuthProvider(model: AuthModel(), child: AuthWidget());
});

var dashboardHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return MainLayout(route: '/dashboard');
});

var tickersHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return MainLayout(route: '/tickers');
});

var tickerHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  print(params);
  String? message = params['message']?.first;
  String? colorHex = params['color_hex']?.first;
  String? result = params['result']?.first;
  Color color = Color(0xFFFFFFFF);
  return MainLayout(route: '/tickers');
});

var walletHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return MainLayout(route: '/wallet');
});

// var demoFunctionHandler = Handler(
//     type: HandlerType.function,
//     handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//       String? message = params['message']?.first;
//       showDialog(
//         context: context!,
//         builder: (context) {
//           return AlertDialog(
//             title: Text(
//               'Hey Hey!',
//               style: TextStyle(
//                 color: const Color(0xFF00D6F7),
//                 fontFamily: 'Lazer84',
//                 fontSize: 22.0,
//               ),
//             ),
//             content: Text('$message'),
//             actions: <Widget>[
//               Padding(
//                 padding: EdgeInsets.only(bottom: 8.0, right: 8.0),
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(true);
//                   },
//                   child: Text('OK'),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     });

/// Handles deep links into the app
/// To test on Android:
///
/// `adb shell am start -W -a android.intent.action.VIEW -d "fluro://deeplink?path=/message&mesage=fluro%20rocks%21%21" com.theyakka.fluro`
// var deepLinkHandler = Handler(
//     handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//   String? colorHex = params['color_hex']?.first;
//   String? result = params['result']?.first;
//   Color color = Color(0xFFFFFFFF);
//   return MainLayout(route: '/dashboard');
// });
