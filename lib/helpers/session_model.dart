import 'package:crabs_trade/domain/api_client/api_client.dart';
import 'package:crabs_trade/domain/domain_providers/session_data_provider.dart';

class SessionModel {
  final _sessionDataProvider = SessionDataProvider();
  final _apiClient = ApiClient();
  var _isAuth = false;
  bool get isAuth => _isAuth;

  Future<bool> checkAuth() async {
    print('auth_cheked');
    final now =
        DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;
    final expiresAt = _sessionDataProvider.getExpiresAt();
    if (expiresAt != null) {
      if (now < expiresAt) {
        _isAuth = true;
        return _isAuth;
      } else {
        print('refreshing_tokens...');
        final acessToken = await _apiClient.refreshTokens(
            refreshToken: _sessionDataProvider.getRefreshToken());

        if (acessToken.containsKey('access_token')) {
          _sessionDataProvider.setAccessToken = acessToken['access_token'];
          _sessionDataProvider.setExpiresAt =
              acessToken['expires_at'].toString();
          _isAuth = true;
        } else {
          _isAuth = false;
        }
        return _isAuth;
      }
    } else {
      _isAuth = false;
      return _isAuth;
    }
  }
}
