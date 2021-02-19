import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _urlAwal = 'http://laravel-vue-flutter.test/api/';
  var token;
  postData(data, apiUrl) async {
    var url = _urlAwal + apiUrl + await _getToken();
    return http.post(
      url,
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  getData(apiUrl) async {
    var url = _urlAwal + apiUrl + await _getToken();
    return http.get(
      url,
      headers: _setHeaders(),
    );
  }

  putData(data, apiUrl) async {
    var url = _urlAwal + apiUrl + await _getToken();
    return http.put(
      url,
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  deleteData(apiUrl) async {
    var url = _urlAwal + apiUrl + await _getToken();
    return http.delete(
      url,
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token');
    return '?token=$token';
  }
}
