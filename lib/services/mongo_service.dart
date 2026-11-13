import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appointment.dart';
import '../models/user.dart' as model;

class MongoService {
  // Transformei em static para poder ser usado nos métodos estáticos abaixo
  static final _supabase = Supabase.instance.client;
  
  // Nome das coleções (tabelas no NoSQL)
  static const String USER_COLLECTION = "users";
  static const String APPOINTMENT_COLLECTION = "appointments";

  // --- AUTENTICAÇÃO ---

  // Cadastra um novo usuário caso o e-mail não exista
  static Future<bool> registerUser(model.User user) async {
    try {
      final response = await _supabase.auth.signUp(
        email: user.email,
        password: user.password,
      );
      
      // Salva os dados complementares do usuário
      if (response.user != null) {
        await _supabase.from(USER_COLLECTION).insert({
          'id': response.user!.id,
          'name': user.name,
          'email': user.email.trim(),
        });
        return true;
      }
      return false;
    } on AuthException catch (e) {
      print('ERRO DE AUTENTICAÇÃO: ${e.message}');
      return false;

    } catch (e) {
      print('ERRO INESPERADO: $e');
      return false;
    }
  }

  // Realiza login utilizando o Supabase Auth
  static Future<model.User?> loginUser(String email, String password) async {
    try{
      final response = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      
      final authUser = response.user;

      if (authUser == null) return null;

      // Busca os dados complementares do usuário
      final userData = await _supabase
          .from(USER_COLLECTION)
          .select()
          .eq('id', authUser.id)
          .maybeSingle();

      if (userData == null) return null;

      return model.User.fromMap(userData);

    } on AuthException catch (e) {
      print('ERRO DE LOGIN: ${e.message}');
      return null;

    } catch (e) {
      print('ERRO INESPERADO: $e');
      return null;
    }
  }

  // --- CRUD DE COMPROMISSOS ---

  // READ: Busca os compromissos do usuário logado
  static Future<List<Appointment>> getAppointments(String userId) async {
    try {
      final list = await _supabase
          .from(APPOINTMENT_COLLECTION)
          .select()
          .eq('userId', userId);

      return list
          .map((map) => Appointment.fromMap(map))
          .toList();

    } catch (e) {
      print('ERRO AO BUSCAR COMPROMISSOS: $e');
      return [];
    }
  }

  // CREATE: Cria um novo compromisso
  static Future<void> createAppointment(Appointment appointment) async {
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('Usuário não autenticado.');
    }

    final data = appointment.toMap();

    // Associa o compromisso ao usuário logado
    data['userId'] = userId;

    await _supabase
        .from(APPOINTMENT_COLLECTION)
        .insert(data);
  }

  // UPDATE: Atualiza um compromisso
  static Future<void> updateAppointment(Appointment appointment) async {
    final id = appointment.id;

    if (id == null) {
      throw Exception('ID do compromisso não informado.');
    }

    await _supabase
        .from(APPOINTMENT_COLLECTION)
        .update(appointment.toMap())
        .eq('id', id);
  }

  // DELETE: Exclui um compromisso
  static Future<void> deleteAppointment(String id) async {
    await _supabase
        .from(APPOINTMENT_COLLECTION)
        .delete()
        .eq('id', id);
  }

  // LOGOUT: Encerra a sessão
  static Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}