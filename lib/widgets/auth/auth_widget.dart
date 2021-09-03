import 'package:crabs_trade/constants/style.dart';
import 'package:crabs_trade/helpers/custom_text.dart';
import 'package:crabs_trade/widgets/auth/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return AuthForm();
  }
}

class AuthForm extends StatelessWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = AuthProvider.read(context)?.model;
    return Scaffold(
      backgroundColor: dark,
      body: Center(
          child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.paid_outlined,
                    color: active,
                  ),
                ),
                Expanded(child: Container())
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text('SignIn',
                    style: GoogleFonts.roboto(
                      color: light,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
            Row(
              children: [
                const CustomText(
                  text: 'Welcome back to crab trade!',
                  color: light_grey,
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: model?.usernameTextController,
              style: TextStyle(color: light),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: light),
                enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: light)),
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: active),
                ),
                labelText: 'username',
                hintText: 'my_username',
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: model?.passwordTextController,
              obscureText: true,
              style: TextStyle(color: light),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: light),
                fillColor: light,
                enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: light)),
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: active),
                ),
                counterStyle: TextStyle(color: light),
                labelText: 'Password',
                hintText: 'mypass1234',
                focusColor: active,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            _errorMessageWidget(),
            Row(children: [
              Checkbox(value: true, onChanged: (value) {}),
              const CustomText(text: 'Remember Me', color: light)
            ]),
            const SizedBox(
              height: 15,
            ),
            AuthButtonWidget(),
            // Container(
            //     height: 60,
            //     width: 100,
            //     color: Colors.red,
            //     child: InkWell(onTap: () {
            //       print(model?.accessToken);
            //       print(model?.refreshToken);
            //       print(model?.expiresAt);
            //     })),
          ],
        ),
      )),
    );
  }
}

class AuthButtonWidget extends StatelessWidget {
  const AuthButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = AuthProvider.watch(context)?.model;
    return Container(
      height: 60,
      child: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: active,
                  boxShadow: [
                    BoxShadow(
                      color: dark.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 20),
                    ),
                  ]),
              alignment: Alignment.center,
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: model?.isAuthInProgress == true
                  ? Container(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(color: Colors.white))
                  : CustomText(text: 'Sign In', color: Colors.white)),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: model?.canStartAuth == true
                  ? () => model?.auth(context)
                  : null,
              splashColor: Colors.white.withOpacity(.1),
              hoverColor: Colors.white.withOpacity(.1),
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
    );
  }
}

class _errorMessageWidget extends StatelessWidget {
  const _errorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage = AuthProvider.watch(context)?.model.errorMessage;
    if (errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        errorMessage.toString(),
        style: TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
