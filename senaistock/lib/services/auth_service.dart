import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart'; // Caminho corrigido!

class AuthService {
  static String? _token;

  Future<Map<String, dynamic>?> login(String rn, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'rn': rn, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        return data;
      }
      return null;
    } catch (e) {
      // Usando o debugPrint ou apenas silenciando para evitar erro em produção
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPerfil() async {
    if (_token == null) return null;

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.me),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
