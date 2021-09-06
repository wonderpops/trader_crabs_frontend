import 'package:crabs_trade/helpers/api_controller.dart';
import 'package:get/get.dart';

class DataLoadController extends GetxController {
  var api = ApiModel();
  var count = 0.obs;
  List tickers = [].obs;
  List actions = [].obs;
  List wallet_history = [].obs;
  Map wallet = {}.obs;

  Future<List> load_tickers() async {
    tickers = await api.getTickers();
    print('tickers loaded');
    return tickers;
  }

  Future<List> load_actions() async {
    actions = await api.getAllActions(1);
    print('actions loaded');
    return actions;
  }

  Future<List> load_wallet_history() async {
    wallet = await api.getWallet();
    actions = await api.getAllActions(1);

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
}
