class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String? unidade;
  final String? rememberToken;
  final String? createdAt;
  final String? updatedAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.role = 'almoxarife',
    this.unidade,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'unidade': unidade,
      'remember_token': rememberToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      unidade: map['unidade'],
      rememberToken: map['remember_token'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}