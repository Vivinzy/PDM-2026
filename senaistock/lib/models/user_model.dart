class UserModel {
  final String id;
  final String name;
  final String rn;
  final String cargo; // 'professor', 'secretaria', 'almoxarifado', 'coordenador'

  UserModel({
    required this.id,
    required this.name,
    required this.rn,
    required this.cargo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'],
      rn: json['rn'],
      cargo: json['cargo'].toString().toLowerCase(),
    );
  }
}