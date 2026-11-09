import 'package:flutter/material.dart';
import '../components/custom_text_field.dart';
import '../models/user.dart';
import '../services/mongo_service.dart';

// Tela de cadastro de novos usuários
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // Chave global para controlar e validar o formulário
  final _formKey = GlobalKey<FormState>();
  
  // Controladores dos campos de texto
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Variável para exibir o indicador de carregamento (spinner)
  bool _isLoading = false;

  // Função disparada ao clicar no botão de Cadastrar
  void _register() async {
    // 1. Executa as validações dos campos
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Ativa o carregando

      // 2. Cria a instância do modelo User
      final user = User(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 3. Tenta cadastrar no MongoDB via MongoService
      final success = await MongoService.registerUser(user);
      
      setState(() => _isLoading = false); // Desativa o carregando

      // 4. Se deu certo, exibe mensagem e volta para a tela de Login
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );
        Navigator.pop(context); // Fecha a tela atual e volta
      } else if (mounted) {
        // Exibe aviso caso o e-mail já exista no banco
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail já cadastrado.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo para o Nome Completo
              CustomTextField(
                controller: _nameController,
                label: 'Nome Completo',
                validator: (val) => val!.isEmpty ? 'Informe o nome' : null,
              ),
              // Campo para o E-mail
              CustomTextField(
                controller: _emailController,
                label: 'E-mail',
                validator: (val) => val!.isEmpty ? 'Informe o e-mail' : null,
              ),
              // Campo para a Senha
              CustomTextField(
                controller: _passwordController,
                label: 'Senha',
                isPassword: true,
                validator: (val) => val!.length < 6 ? 'Mínimo de 6 caracteres' : null,
              ),
              const SizedBox(height: 20),
              // Exibe o botão de cadastrar ou o ícone de carregando
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _register,
                      child: const Text('Cadastrar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}