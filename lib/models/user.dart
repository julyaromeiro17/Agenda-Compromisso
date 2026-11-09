import 'package:mongo_dart/mongo_dart.dart';

// Classe que representa a entidade Usuário no sistema
class User {
  final ObjectId? id; // Identificador único gerado pelo MongoDB (_id)
  final String name; // Nome completo do usuário
  final String email; // E-mail (usado como login)
  final String password; // Senha do usuário

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  // Converte o objeto User em um Map (JSON) para salvar no MongoDB
  Map<String, dynamic> toMap() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  // Cria um objeto User a partir de um Map retornado do MongoDB
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as ObjectId?,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
}