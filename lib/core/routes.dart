import 'package:flutter/material.dart';

import '../views/login_view.dart';
import '../views/register_view.dart';
import '../views/home_view.dart'; 
import '../views/appointment_form_view.dart';

class Routes {
  // Nomes estáticos para evitar erros de digitação de strings no código
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String appointmentForm = '/appointment_form';

  // Mapeia os caminhos (strings) para as telas (Widgets) correspondentes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginView(),
      register: (context) => const RegisterView(),
      home: (context) => const HomeView(),
      appointmentForm: (context) => const AppointmentFormView(),
    };
  }
}