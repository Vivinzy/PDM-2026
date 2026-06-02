class ApiConstants {
  // Se estiver testando no emulador Android, use '10.0.2.2'. Se for no celular físico, use o IP da sua máquina.
  static const String baseUrl = 'http://10.0.2.2:8000/api'; 
  
  static const String login = '$baseUrl/login';
  static const String me = '$baseUrl/me';
  static const String estoqueEntrada = '$baseUrl/estoque/entrada';
  static const String estoqueSaida = '$baseUrl/estoque/saida';
}