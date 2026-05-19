class Livro {
  final int? id;
  final String titulo;
  final String isbn;
  final String materia;
  final int saldo;
  final int estoqueMinimo;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Livro({
    this.id,
    required this.titulo,
    required this.isbn,
    required this.materia,
    this.saldo = 0,
    this.estoqueMinimo = 10,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'isbn': isbn,
      'materia': materia,
      'saldo': saldo,
      'estoque_minimo': estoqueMinimo,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(
      id: map['id'],
      titulo: map['titulo'],
      isbn: map['isbn'],
      materia: map['materia'],
      saldo: map['saldo'],
      estoqueMinimo: map['estoque_minimo'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      deletedAt: map['deleted_at'],
    );
  }
}