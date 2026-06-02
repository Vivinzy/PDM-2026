import 'package:flutter/material.dart';
import '../services/estoque_service.dart';

class EstoqueProvider extends ChangeNotifier {
  final service = EstoqueService();

  List<String> produtos = [];
  bool loading = false;

  Future fetch() async {
    loading = true;
    notifyListeners();

    produtos = await service.getProdutos();

    loading = false;
    notifyListeners();
  }
}