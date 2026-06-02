class Livro {
  final int id;
  final String nome;

  Livro({required this.id, required this.nome});

  factory Livro.fromJson(Map<String, dynamic> json) {
    return Livro(
      id: json['id'],
      nome: json['nome'],
    );
  }
}