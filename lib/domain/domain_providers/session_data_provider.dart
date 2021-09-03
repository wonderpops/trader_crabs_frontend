import 'dart:html';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SessionDataProvider {
  final _secretkey = encrypt.Key.fromLength(32);
  final _iv = encrypt.IV.fromLength(16);

  Future<void> _setCookieWithEncryption(key, value) async {
    final encrypter = encrypt.Encrypter(encrypt.AES(_secretkey));
    final encrypted = encrypter.encrypt(value, iv: _iv).base64;
    document.cookie = '$key=$encrypted; Secure;';
  }

  String _getCookieWithEncryption(key) {
    String cookies = document.cookie!;
    List<String> listValues = cookies.isNotEmpty ? cookies.split(";") : [];
    String matchVal = "";
    for (int i = 0; i < listValues.length; i++) {
      List<String> map = listValues[i].split("=");
      String _key = map[0].trim();
      String _val = map[1].trim();
      if (key == _key) {
        matchVal = _val;
        break;
      }
    }
    final encrypter = encrypt.Encrypter(encrypt.AES(_secretkey));
    final decrypted =
        encrypter.decrypt(encrypt.Encrypted.fromBase64(matchVal), iv: _iv);
    return decrypted;
  }

  Future<void> _setCookie(key, value) async {
    document.cookie = '$key=$value; Secure;';
  }

  String? _getCookie(key) {
    String cookies = document.cookie!;
    List<String> listValues = cookies.isNotEmpty ? cookies.split(";") : [];
    String? matchVal = null;
    for (int i = 0; i < listValues.length; i++) {
      List<String> map = listValues[i].split("=");
      String _key = map[0].trim();
      String _val = map[1].trim();
      if (key == _key) {
        matchVal = _val;
        break;
      }
    }
    return matchVal;
  }

  String getAccessToken() => _getCookieWithEncryption('access_token');
  set setAccessToken(String value) =>
      _setCookieWithEncryption('access_token', value);
  String getRefreshToken() => _getCookieWithEncryption('refresh_token');
  set setRefreshToken(String value) =>
      _setCookieWithEncryption('refresh_token', value);
  int? getExpiresAt() => _getCookie('expires_at') != null
      ? int.parse(_getCookie('expires_at')!)
      : null;
  set setExpiresAt(String value) => _setCookie('expires_at', value);
}
