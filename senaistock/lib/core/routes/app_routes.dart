import 'package:flutter/material.dart';
import 'package:senaistock/screens/auth/login_screen.dart';
import 'package:senaistock/screens/splash/splash_screen.dart';
import 'package:senaistock/screens/home/home_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String homeProfessor = '/home_professor';
  static const String homeSecretaria = '/home_secretaria';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      homeProfessor: (context) => const ProfessorScreen(),
      homeSecretaria: (context) => const SecretariaScreen(),
    };
  }
}
