class Movimentacao {
  final int id;
  final String tipo;
  final int quantidade;

  Movimentacao({
    required this.id,
    required this.tipo,
    required this.quantidade,
  });

  factory Movimentacao.fromJson(Map<String, dynamic> json) {
    return Movimentacao(
      id: json['id'],
      tipo: json['tipo'],
      quantidade: json['quantidade'],
    );
  }
}