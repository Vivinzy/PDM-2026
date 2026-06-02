class EstoqueService {
  Future<List<String>> getProdutos() async {
    await Future.delayed(const Duration(seconds: 1));
    return ["Produto A", "Produto B"];
  }
}