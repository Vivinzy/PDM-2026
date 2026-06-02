class ApiService {
  Future<Map<String, dynamic>> post(String endpoint, Map data) async {
    await Future.delayed(const Duration(seconds: 1));

    return {
      "status": true,
      "token": "123456"
    };
  }
}