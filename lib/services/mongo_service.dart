import 'package:mongo_dart/mongo_dart.dart';
import '../models/appointment.dart';
import '../models/user.dart';

class MongoService {
  // String de conexão com o MongoDB Atlas ou Local
  static const String MONGO_URL = "mongodb+srv://julyaromeiro17_db_user:cZTbYxiLy1DRABmK@cluster0.mb2db9a.mongodb.net/";
  
  // Nome das coleções (tabelas no NoSQL)
  static const String USER_COLLECTION = "users";
  static const String APPOINTMENT_COLLECTION = "appointments";

  static late Db db; // Instância estática do banco de dados

  // Inicializa a conexão com o MongoDB
  static Future<void> connect() async {
    db = await Db.create(MONGO_URL);
    await db.open(); // Abre o socket de conexão
  }

  // --- AUTENTICAÇÃO ---

  // Cadastra um novo usuário caso o e-mail não exista
  static Future<bool> registerUser(User user) async {
    final collection = db.collection(USER_COLLECTION);
    // Verifica se já existe um usuário com esse e-mail no banco
    final existingUser = await collection.findOne(where.eq('email', user.email));
    
    if (existingUser != null) {
      return false; // Retorna falso se o e-mail já estiver cadastrado
    }

    await collection.insertOne(user.toMap()); // Insere a foto do documento
    return true;
  }

  // Realiza o login comparando e-mail e senha
  static Future<User?> loginUser(String email, String password) async {
    final collection = db.collection(USER_COLLECTION);
    // Busca um registro que combine e-mail E senha
    final userData = await collection.findOne(
      where.eq('email', email).eq('password', password),
    );
    
    if (userData == null) return null; // Retorna null se não achar nada
    return User.fromMap(userData); // Retorna a instância do usuário logado
  }

  // --- CRUD DE COMPROMISSOS ---

  // READ (Ler): Busca apenas os compromissos pertencentes ao usuário logado
  static Future<List<Appointment>> getAppointments(String userId) async {
    final collection = db.collection(APPOINTMENT_COLLECTION);
    final list = await collection.find(where.eq('userId', userId)).toList();
    return list.map((map) => Appointment.fromMap(map)).toList();
  }

  // CREATE (Criar): Salva um novo compromisso no banco
  static Future<void> createAppointment(Appointment appointment) async {
    final collection = db.collection(APPOINTMENT_COLLECTION);
    await collection.insertOne(appointment.toMap());
  }

  // UPDATE (Atualizar): Atualiza os dados de um compromisso por seu ID
  static Future<void> updateAppointment(Appointment appointment) async {
    final collection = db.collection(APPOINTMENT_COLLECTION);
    await collection.replaceOne(where.id(appointment.id!), appointment.toMap());
  }

  // DELETE (Deletar): Remove um compromisso do banco pelo ID
  static Future<void> deleteAppointment(ObjectId id) async {
    final collection = db.collection(APPOINTMENT_COLLECTION);
    await collection.remove(where.id(id));
  }
}