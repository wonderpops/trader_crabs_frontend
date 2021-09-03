import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ApiClient {
  final _client = http.Client();
  static const _host = 'http://127.0.0.1:80';

  Future<Map<String, dynamic>> signIn({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$_host/login?username=$username&password=$password');
    try {
      final response =
          await _client.post(url, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
        return json;
      } else {
        final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
        return {'error': json};
      }
    } catch (error) {
      return {
        'error': {'detail': 'Server connection failed'}
      };
    }
  }

  Future<Map<String, dynamic>> refreshTokens({
    required String refreshToken,
  }) async {
    final url = Uri.parse('$_host/refresh');
    final response = await _client.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $refreshToken',
      },
    );
    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return json;
    } else {
      final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return {'error': json};
    }
  }

  Future<List<dynamic>> getTickers({
    required String accessToken,
  }) async {
    final url = Uri.parse('$_host/get_all_instruments');
    final response = await _client.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body) as List<dynamic>;
      return json;
    } else {
      final json = convert.jsonDecode(response.body) as List<dynamic>;
      return [
        {'error': json}
      ];
    }
  }

  Future<Map<String, dynamic>> getWallet({
    required String accessToken,
  }) async {
    final url = Uri.parse('$_host/get_wallet?id=1');
    final response = await _client.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return json;
    } else {
      final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return {'error': json};
    }
  }

  Future<List<dynamic>> getAllActions({
    required String accessToken,
    required int page,
  }) async {
    final url = Uri.parse('$_host/get_all_actions?page=$page');
    final response = await _client.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body) as List<dynamic>;
      return json;
    } else {
      final json = convert.jsonDecode(response.body) as List<dynamic>;
      return [
        {'error': json}
      ];
    }
  }
}