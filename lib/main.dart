import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/routes.dart';

void main() async {
  // Garante a inicialização correta dos bindings do Flutter antes do código assíncrono
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://momavjswtmqougstkutc.supabase.co',
    publishableKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1vbWF2anN3dG1xb3Vnc3RrdXRjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTQ1MjUyNTcsImV4cCI6MjExMDEwMTI1N30.FqXv9DvH1OMp5okcQQpT1WqWI9ci2ySsSwhzSKpltRY',
  );
  
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