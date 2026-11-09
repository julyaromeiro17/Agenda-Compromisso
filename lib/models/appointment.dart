import 'package:mongo_dart/mongo_dart.dart';

// Classe que representa o compromisso agendado
class Appointment {
  final ObjectId? id; // ID do compromisso no MongoDB
  final String userId; // ID do usuário dono desse compromisso (vínculo)
  final String title; // Título do compromisso
  final String description; // Descrição detalhada
  final DateTime date; // Data e hora agendadas

  Appointment({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.date,
  });

  // Converte o objeto em Map para gravar no banco
  Map<String, dynamic> toMap() {
    return {
      if (id != null) '_id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(), // Salva a data como String no formato ISO
    };
  }

  // Converte o Map retornado do banco de volta para a classe Appointment
  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['_id'] as ObjectId?,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }
}