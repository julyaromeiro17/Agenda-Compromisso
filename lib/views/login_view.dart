import 'package:flutter/material.dart';
import '../components/custom_text_field.dart';
import '../core/routes.dart';
import '../services/mongo_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Chave identificadora do formulário para disparar validações
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // Controla o indicador de carregamento

  // Executa o fluxo de autenticação
  void _login() async {
    // 1. Valida se os campos não estão vazios
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Exibe o spinner

      // 2. Consulta o banco de dados via MongoService
      final user = await MongoService.loginUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() => _isLoading = false); // Oculta o spinner

      // 3. Se autenticado, redireciona para a Home passando o ID do usuário
      if (user != null && mounted) {
        Navigator.pushReplacementNamed(
          context,
          Routes.home,
          arguments: user.id.toString(),
        );
      } else if (mounted) {
        // Exibe mensagem caso o login falhe
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail ou senha inválidos.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _emailController,
                label: 'E-mail',
                validator: (val) => val!.isEmpty ? 'Informe o e-mail' : null,
              ),
              CustomTextField(
                controller: _passwordController,
                label: 'Senha',
                isPassword: true,
                validator: (val) => val!.isEmpty ? 'Informe a senha' : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Entrar'),
                    ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, Routes.register),
                child: const Text('Não tem uma conta? Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}