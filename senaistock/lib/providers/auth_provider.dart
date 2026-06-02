import 'package:flutter/material.dart';
import '../models/user_model.dart';
// Se o seu DatabaseHelper já tiver o método de buscar usuário, descomente a linha abaixo:
// import '../core/database/database_helper.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _usuarioAtual;
  bool _isLoading = false;

  UserModel? get usuarioAtual => _usuarioAtual;
  bool get isLoading => _isLoading;

  Future<bool> realizarLogin(String rn, String password) async {
    _isLoading = true;
    notifyListeners();

    // Aguarda um segundinho só para dar o efeito de carregamento na tela rosa
    await Future.delayed(const Duration(milliseconds: 800));

    // 🔑 USUÁRIOS LOCAL DE TESTE (Para você conseguir logar agora mesmo!)
    // Você pode testar com qualquer um desses 4 perfis abaixo:
    
    if (rn == '111' && password == 'senai123') {
      _usuarioAtual = UserModel(id: '1', name: 'Prof. Carlos', rn: '111', cargo: 'professor');
      _isLoading = false;
      notifyListeners();
      return true;
    } 
    
    else if (rn == '222' && password == 'senai123') {
      _usuarioAtual = UserModel(id: '2', name: 'Ana da Secretaria', rn: '222', cargo: 'secretaria');
      _isLoading = false;
      notifyListeners();
      return true;
    } 
    
    else if (rn == '333' && password == 'senai123') {
      _usuarioAtual = UserModel(id: '3', name: 'Marcos do Almoxarifado', rn: '333', cargo: 'almoxarifado');
      _isLoading = false;
      notifyListeners();
      return true;
    } 
    
    else if (rn == '444' && password == 'senai123') {
      _usuarioAtual = UserModel(id: '4', name: 'Coord. Roberto', rn: '444', cargo: 'coordenador');
      _isLoading = false;
      notifyListeners();
      return true;
    }

    /* --- FUTURO (Quando seu database_helper.dart estiver pronto) ---
    Aqui dentro você fará a consulta real no SQLite, algo tipo:
    final db = await DatabaseHelper.instance.database;
    final userMap = await db.query('usuarios', where: 'rn = ? AND senha = ?', whereArgs: [rn, password]);
    if (userMap.isNotEmpty) { ... }
    */

    _isLoading = false;
    notifyListeners();
    return false; // Se não for nenhum dos RNs acima, dá erro
  }

  void logout() {
    _usuarioAtual = null;
    notifyListeners();
  }
}