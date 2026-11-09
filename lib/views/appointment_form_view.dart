import 'package:flutter/material.dart';
import '../components/custom_text_field.dart';
import '../models/appointment.dart';
import '../services/mongo_service.dart';

// Tela do formulário para adicionar ou editar um compromisso (CRUD - Create/Update)
class AppointmentFormView extends StatefulWidget {
  const AppointmentFormView({super.key});

  @override
  State<AppointmentFormView> createState() => _AppointmentFormViewState();
}

class _AppointmentFormViewState extends State<AppointmentFormView> {
  // Chave global do formulário
  final _formKey = GlobalKey<FormState>();
  
  // Controladores dos campos de texto
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  
  // Guarda a data selecionada no DatePicker
  DateTime _selectedDate = DateTime.now();

  String? userId;
  Appointment? _editingAppointment;
  bool _isInit = false;

  // Método executado quando os argumentos da rota são recebidos
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      // Recebe os parâmetros passados ao navegar para esta tela
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      userId = args['userId'];
      _editingAppointment = args['appointment'];

      // Se passou um compromisso existente, preenche os campos para Edição
      if (_editingAppointment != null) {
        _titleController.text = _editingAppointment!.title;
        _descController.text = _editingAppointment!.description;
        _selectedDate = _editingAppointment!.date;
      }
      _isInit = true;
    }
  }

  // Salva no banco de dados (Cria novo ou Atualiza existente)
  void _save() async {
    if (_formKey.currentState!.validate()) {
      if (_editingAppointment == null) {
        // --- CRIAR (CREATE) ---
        await MongoService.createAppointment(
          Appointment(
            userId: userId!,
            title: _titleController.text.trim(),
            description: _descController.text.trim(),
            date: _selectedDate,
          ),
        );
      } else {
        // --- ATUALIZAR (UPDATE) ---
        await MongoService.updateAppointment(
          Appointment(
            id: _editingAppointment!.id,
            userId: userId!,
            title: _titleController.text.trim(),
            description: _descController.text.trim(),
            date: _selectedDate,
          ),
        );
      }
      
      // Fecha o formulário e retorna para a tela principal (Home)
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Altera o título dinamicamente se estiver editando ou criando
        title: Text(_editingAppointment == null ? 'Novo Compromisso' : 'Editar Compromisso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo Título
              CustomTextField(
                controller: _titleController,
                label: 'Título',
                validator: (val) => val!.isEmpty ? 'Informe o título' : null,
              ),
              // Campo Descrição
              CustomTextField(
                controller: _descController,
                label: 'Descrição',
                validator: (val) => val!.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 16),
              // Seleção de Data usando o DatePicker nativo do Flutter
              Row(
                children: [
                  Text('Data: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Botão de Ação (Salvar)
              ElevatedButton(
                onPressed: _save,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}