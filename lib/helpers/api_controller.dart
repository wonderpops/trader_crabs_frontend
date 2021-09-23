import 'package:crabs_trade/domain/api_client/api_client.dart';
import 'package:crabs_trade/domain/domain_providers/session_data_provider.dart';
import 'package:crabs_trade/widgets/auth/auth_model.dart';
import 'package:flutter/material.dart';

class ApiModel extends ChangeNotifier {
  set authModel(BuildContext context) => AuthProvider.watch(context)?.model;
  final _apiClient = ApiClient();
  final _sessionData = SessionDataProvider();

  List<dynamic>? _tickers;
  List<dynamic>? get tickers => _tickers;

  int? _walletMoney;
  int? get walletMoney => _walletMoney;

  List<dynamic>? _allActions;
  List<dynamic>? get allActions => _allActions;

  Future<List> getTickers() async {
    _tickers =
        await _apiClient.getTickers(accessToken: _sessionData.getAccessToken());
    notifyListeners();
    return _tickers ?? [];
  }

  Future<Map> getTickerInfo(ticker) async {
    var _ticker = await _apiClient.getTickerInfo(
        accessToken: _sessionData.getAccessToken(), ticker: ticker);
    notifyListeners();
    return _ticker;
  }

  Future<Map> setTickerState(ticker, bool state) async {
    var _ticker = await _apiClient.setTickerState(
        accessToken: _sessionData.getAccessToken(),
        ticker: ticker,
        state: state);
    notifyListeners();
    return _ticker;
  }

  Future<List> getTickerData(ticker, start_date, end_date) async {
    var _tickerData = await _apiClient.getTickersData(
        accessToken: _sessionData.getAccessToken(),
        ticker: ticker,
        start_date: start_date,
        end_date: end_date);
    notifyListeners();
    return _tickerData;
  }

  Future<List> getAllActions(int page) async {
    _allActions = await _apiClient.getAllActions(
        accessToken: _sessionData.getAccessToken(), page: page);
    notifyListeners();
    return _allActions ?? [];
  }

  Future<List> getTickerActions(ticker, start_date, end_date) async {
    var _actions = await _apiClient.getTickerActions(
        accessToken: _sessionData.getAccessToken(),
        ticker: ticker,
        start_date: start_date,
        end_date: end_date);
    notifyListeners();
    return _actions;
  }

  Future<Map> getWallet() async {
    var wallet =
        await _apiClient.getWallet(accessToken: _sessionData.getAccessToken());
    if (wallet.containsKey('money')) {
      _walletMoney = wallet['money'];
      notifyListeners();
      return wallet;
    }
    notifyListeners();
    return {};
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
