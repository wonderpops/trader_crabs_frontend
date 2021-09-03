import 'package:crabs_trade/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              'Error 404 page not found',
              style: GoogleFonts.almendraDisplay(
                  fontWeight: FontWeight.bold, color: active, fontSize: 50),
            ),
          )
        ],
      ),
    );
  }
}
