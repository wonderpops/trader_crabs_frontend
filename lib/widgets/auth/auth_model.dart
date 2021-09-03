import 'package:crabs_trade/domain/api_client/api_client.dart';
import 'package:crabs_trade/domain/domain_providers/session_data_provider.dart';
import 'package:crabs_trade/helpers/main_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class AuthModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  bool _isAuthInProcess = false;
  bool get canStartAuth => !_isAuthInProcess;
  bool get isAuthInProgress => _isAuthInProcess;
  String get accessToken => _sessionDataProvider.getAccessToken();
  String get refreshToken => _sessionDataProvider.getRefreshToken();
  int? get expiresAt => _sessionDataProvider.getExpiresAt();
  bool _isAuth = false;
  bool get isAuth => _isAuth;
  bool _isAuthChecked = false;
  bool get isAuthChecked => _isAuthChecked;

  // ignore: avoid_init_to_null
  String? _errorMessage = null;
  String? get errorMessage => _errorMessage;
  Future<void> auth(BuildContext context) async {
    final username = usernameTextController.text;
    final password = passwordTextController.text;

    if (username.isEmpty || password.isEmpty) {
      _errorMessage = 'Incorrect username or password';
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isAuthInProcess = true;
    notifyListeners();
    final sessionKeys =
        await _apiClient.signIn(username: username, password: password);
    if (sessionKeys.containsKey('error')) {
      _errorMessage = sessionKeys['error']['detail'];
      _isAuthInProcess = false;
      notifyListeners();
      return;
    }
    if (sessionKeys.containsKey('access_token')) {
      _isAuthInProcess = false;
      _sessionDataProvider.setAccessToken = sessionKeys['access_token'];
      _sessionDataProvider.setRefreshToken = sessionKeys['refresh_token'];
      _sessionDataProvider.setExpiresAt = sessionKeys['expires_at'].toString();
      Navigator.of(context)
          .pushReplacementNamed(MainNavigationRoutesNames.dashboard);
    } else {
      _errorMessage = 'Unkown error, please try again :c';
      print(sessionKeys);
      _isAuthInProcess = false;
      notifyListeners();
      return;
    }
    _isAuthInProcess = false;
    notifyListeners();
  }

  bool checkAuth() {
    print('auth_cheked');
    _isAuthChecked = true;
    final now =
        DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;
    final expiresAt = _sessionDataProvider.getExpiresAt();
    if (expiresAt != null) {
      if (now < expiresAt) {
        print("didn't need refresh");
        _isAuth = true;
        notifyListeners();
        return true;
      } else {
        print('refreshing_tokens...');
        final response = _apiClient.refreshTokens(
            refreshToken: _sessionDataProvider.getRefreshToken());
        response.then((value) {
          print('refreshing_tokens2...');
          if (value.containsKey('access_token')) {
            _sessionDataProvider.setAccessToken = value['access_token'];
            _sessionDataProvider.setExpiresAt = value['expires_at'].toString();
            _isAuth = true;
            notifyListeners();
            return true;
          } else {
            _isAuth = false;
            notifyListeners();
            return false;
          }
        });
        _isAuth = false;
        notifyListeners();
        return false;
      }
    } else {
      _isAuth = false;
      notifyListeners();
      return false;
    }
  }
}

class AuthProvider extends InheritedNotifier {
  final AuthModel model;

  const AuthProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(key: key, notifier: model, child: child);

  static AuthProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
  }

  static AuthProvider? read(BuildContext context) {
    final widget =
        context.getElementForInheritedWidgetOfExactType<AuthProvider>()?.widget;
    return widget is AuthProvider ? widget : null;
  }
}
