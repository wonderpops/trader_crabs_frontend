import 'package:crabs_trade/domain/api_client/api_client.dart';
import 'package:crabs_trade/domain/domain_providers/session_data_provider.dart';
import 'package:crabs_trade/widgets/auth/auth_model.dart';
import 'package:flutter/material.dart';

class ApiModel extends ChangeNotifier {
  set authModel(BuildContext context) => AuthProvider.watch(context)?.model;
  final _apiClient = ApiClient();
  final _sessionData = SessionDataProvider();

  List<dynamic>? _tikers;
  List<dynamic>? get tikers => _tikers;

  int? _walletMoney;
  int? get walletMoney => _walletMoney;

  List<dynamic>? _allActions;
  List<dynamic>? get allActions => _allActions;

  Future<void> getTickers(BuildContext context) async {
    _tikers =
        await _apiClient.getTickers(accessToken: _sessionData.getAccessToken());
    notifyListeners();
  }

  Future<void> getWallet(BuildContext context) async {
    var wallet =
        await _apiClient.getWallet(accessToken: _sessionData.getAccessToken());
    if (wallet.containsKey('money')) {
      _walletMoney = wallet['money'];
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> getAllActions(BuildContext context, int page) async {
    _allActions = await _apiClient.getAllActions(
        accessToken: _sessionData.getAccessToken(), page: page);
    notifyListeners();
  }
}

class ApiProvider extends InheritedNotifier {
  final ApiModel model;

  const ApiProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(key: key, notifier: model, child: child);

  static ApiProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ApiProvider>();
  }

  static ApiProvider? read(BuildContext context) {
    final widget =
        context.getElementForInheritedWidgetOfExactType<ApiProvider>()?.widget;
    return widget is ApiProvider ? widget : null;
  }
}
