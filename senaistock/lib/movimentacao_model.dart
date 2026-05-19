class Movimentacao {
  final int? id;
  final int livroId;
  final int userId;
  final String tipo;
  final int quantidade;
  final int saldoAnterior;
  final int saldoAtual;
  final String? turma;
  final String? remessa;
  final String? observacao;
  final String? createdAt;
  final String? updatedAt;

  Movimentacao({
    this.id,
    required this.livroId,
    required this.userId,
    required this.tipo,
    required this.quantidade,
    required this.saldoAnterior,
    required this.saldoAtual,
    this.turma,
    this.remessa,
    this.observacao,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'livro_id': livroId,
      'user_id': userId,
      'tipo': tipo,
      'quantidade': quantidade,
      'saldo_anterior': saldoAnterior,
      'saldo_atual': saldoAtual,
      'turma': turma,
      'remessa': remessa,
      'observacao': observacao,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Movimentacao.fromMap(Map<String, dynamic> map) {
    return Movimentacao(
      id: map['id'],
      livroId: map['livro_id'],
      userId: map['user_id'],
      tipo: map['tipo'],
      quantidade: map['quantidade'],
      saldoAnterior: map['saldo_anterior'],
      saldoAtual: map['saldo_atual'],
      turma: map['turma'],
      remessa: map['remessa'],
      observacao: map['observacao'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}