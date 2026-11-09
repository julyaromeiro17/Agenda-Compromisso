import 'package:flutter/material.dart';
import '../core/routes.dart';
import '../models/appointment.dart';
import '../services/mongo_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late String userId;
  bool _isInit = false;

  // Executado quando a tela carrega para capturar o ID do usuário enviado pela tela de Login
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      userId = ModalRoute.of(context)!.settings.arguments as String;
      _isInit = true;
    }
  }

  // Função para deletar um compromisso do banco
  void _deleteAppointment(Appointment item) async {
    await MongoService.deleteAppointment(item.id!);
    setState(() {}); // Recarrega a tela para atualizar a lista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Compromissos'),
        actions: [
          // Botão de Logout: Redireciona de volta para a tela de Login
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, Routes.login),
          ),
        ],
      ),
      // FutureBuilder resolve tarefas assíncronas do banco e renderiza a lista na tela
      body: FutureBuilder<List<Appointment>>(
        future: MongoService.getAppointments(userId), // Carrega os compromissos do usuário
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Carregando
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum compromisso cadastrado.'));
          }

          final appointments = snapshot.data!;
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final item = appointments[index];
              return ListTile(
                title: Text(item.title),
                subtitle: Text('${item.description}\nData: ${item.date.toLocal().toString().split(' ')[0]}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Botão para EDITAR
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        await Navigator.pushNamed(
                          context,
                          Routes.appointmentForm,
                          arguments: {'userId': userId, 'appointment': item},
                        );
                        setState(() {}); // Recarrega os dados alterados
                      },
                    ),
                    // Botão para DELETAR
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteAppointment(item),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      // Botão Flutuante para ADICIONAR novo compromisso
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            Routes.appointmentForm,
            arguments: {'userId': userId},
          );
          setState(() {}); // Recarrega a tela após adicionar novo registro
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}