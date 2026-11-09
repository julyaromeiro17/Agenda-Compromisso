import 'package:flutter/material.dart';
import 'core/routes.dart';
import 'services/mongo_service.dart';

void main() async {
  // Garante a inicialização correta dos bindings do Flutter antes do código assíncrono
  WidgetsFlutterBinding.ensureInitialized();
  
  // Conecta ao MongoDB antes de subir a interface visual
  await MongoService.connect();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda de Compromissos',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: Routes.login, // Tela inicial da aplicação
      routes: Routes.getRoutes(), // Rotas centralizadas
      debugShowCheckedModeBanner: false,
    );
  }
}