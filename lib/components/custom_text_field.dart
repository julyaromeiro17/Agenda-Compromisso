import 'package:flutter/material.dart';

// Componente genérico para campos de texto para evitar código repetido nos formulários
class CustomTextField extends StatelessWidget {
  final TextEditingController controller; // Controlador do valor digitado
  final String label; // Rótulo do campo
  final bool isPassword; // Se true, esconde os caracteres da senha
  final String? Function(String?)? validator; // Função para validação de erros

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(), // Borda padrão em volta do input
        ),
      ),
    );
  }
}