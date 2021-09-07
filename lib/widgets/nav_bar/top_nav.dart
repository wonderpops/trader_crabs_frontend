import 'package:crabs_trade/constants/style.dart';
import 'package:crabs_trade/helpers/custom_text.dart';
import 'package:crabs_trade/helpers/responsiveness.dart';
import 'package:flutter/material.dart';

AppBar topNavBar(BuildContext context, GlobalKey<ScaffoldState> key) => AppBar(
      leading: !ResponsiveWidget.is_small_screen(context)
          ? Container(
              padding: const EdgeInsets.only(left: 14),
              child: const Icon(
                Icons.paid_rounded,
                color: active,
              ),
            )
          : IconButton(
              onPressed: () {
                key.currentState!.openDrawer();
              },
              icon: const Icon(Icons.menu),
              color: active,
            ),
      elevation: 0,
      backgroundColor: dark,
      title: Row(
        children: [
          const Visibility(
              child: CustomText(
            text: 'Trader Crabs',
            color: light,
            size: 20,
            weight: FontWeight.bold,
          )),
          Expanded(
            child: Container(),
          ),
          Stack(children: [
            Container(
              decoration: BoxDecoration(
                  color: dark_light,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: light_grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 0),
                    )
                  ]),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_outlined,
                  color: light.withOpacity(.7),
                ),
              ),
            ),
            Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 9,
                  height: 9,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: active.withAlpha(200),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: active.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 0),
                        ),
                      ]),
                ))
          ]),
          const SizedBox(
            width: 20,
          ),
          Container(
            decoration: BoxDecoration(
                color: dark_light,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: light_grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                  )
                ]),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings_outlined,
                color: light.withOpacity(.7),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          if (!ResponsiveWidget.is_small_screen(context))
            Row(
              children: [
                Container(
                  width: 1,
                  height: 22,
                  color: light,
                ),
                const SizedBox(
                  width: 20,
                ),
                const CustomText(
                  text: 'wonderpop',
                  color: light_grey,
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: dark_light, borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.all(2),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person_outline,
                  color: dark,
                ),
              ),
            ),
          )
        ],
      ),
      iconTheme: const IconThemeData(color: dark),
    );
