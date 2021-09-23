import 'package:crabs_trade/helpers/api_controller.dart';
import 'package:get/get.dart';

class DataLoadController extends GetxController {
  var api = ApiModel();
  var count = 0.obs;
  List tickers = [].obs;
  List actions = [].obs;
  List ticker_data = [].obs;
  List ticker_actions = [].obs;
  List ticker_actions_sell_history = [].obs;
  List ticker_actions_buy_history = [].obs;
  List wallet_history = [].obs;
  List ticker_history = [].obs;
  Map wallet = {}.obs;
  Map ticker_info = {}.obs;

  Future<List> load_tickers() async {
    tickers = await api.getTickers();
    print('tickers loaded');
    return tickers;
  }

  Future<Map> load_ticker_info(ticker) async {
    ticker_info = await api.getTickerInfo(ticker);
    return ticker_info;
  }

  Future<Map> set_ticker_status(ticker, bool state) async {
    ticker_info = await api.setTickerState(ticker, state);
    return ticker_info;
  }

  Future<List> load_actions() async {
    actions = await api.getAllActions(1);
    print('actions loaded');
    return actions;
  }

  Future<List> load_ticker_actions(ticker, page) async {
    ticker_actions = await api.getTickerActions(ticker, page);
    print('ticker actions loaded');
    return ticker_actions;
  }

  Future<List> load_wallet_history() async {
    wallet = await api.getWallet();
    actions = await api.getAllActions(1);
    wallet_history = [];

    var m_value = 0.0;

    if (actions.isNotEmpty) {
      actions.reversed.forEach((element) {
        m_value += element['profit'];
        var date = DateTime.parse(element['date']);
        wallet_history.add({'date': date, 'value': m_value});
      });
    }

    print('wallet history loaded');
    return wallet_history;
  }

  Future<List> load_ticker_actions_history(ticker, page) async {
    ticker_actions_sell_history = [];
    ticker_actions_buy_history = [];
    actions = await api.getTickerActions(ticker, page);
    print('ticker actions loaded');
    if (actions.isNotEmpty) {
      actions.reversed.forEach((element) {
        var date = DateTime.parse(element['date']);
        if (element['action'] == 'Sell') {
          ticker_actions_sell_history
              .add({'date': date, 'value': element['price']});
        } else {
          ticker_actions_buy_history
              .add({'date': date, 'value': element['price']});
        }
      });
    }
    return actions;
  }

  Future<List> load_ticker_history(ticker, page) async {
    ticker_history = [];

    ticker_data = await api.getTickerData(ticker, page);

    if (ticker_data.isNotEmpty) {
      ticker_data.reversed.forEach((element) {
        var date = DateTime.parse(element['date']);
        ticker_history.add({
          'date': date,
          'a': element['a'],
          'k': element['k'],
          'd': element['d'],
        });
      });
    }

    print('ticker history loaded');
    await load_ticker_actions_history(ticker, page);
    return ticker_history;
  }
}
