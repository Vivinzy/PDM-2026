import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores dos campos de texto (corrigem os erros de undefined)
  final TextEditingController _rnController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void _executarLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Guardamos o messenger antes para evitar problemas com o ciclo de vida do context
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    String rn = _rnController.text.trim();
    String senha = _senhaController.text.trim();

    if (rn.isEmpty || senha.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    bool sucesso = await authProvider.realizarLogin(rn, senha);

    // Se o widget foi desmontado da tela durante o await da API, paramos aqui
    if (!mounted) return;

    if (sucesso) {
      final cargo = authProvider.usuarioAtual?.cargo;
      
      // Redirecionamento baseado no perfil do usuário do SENAI
      if (cargo == 'professor') {
        Navigator.pushReplacementNamed(context, '/home_professor');
      } else if (cargo == 'secretaria') {
        Navigator.pushReplacementNamed(context, '/home_secretaria');
      } else if (cargo == 'almoxarifado') {
        Navigator.pushReplacementNamed(context, '/home_almoxarifado');
      } else if (cargo == 'coordenador') {
        Navigator.pushReplacementNamed(context, '/home_coordenador');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('RN ou Senha incorretos. Tente novamente!')),
      );
    }
  }

  @override
  void dispose() {
    _rnController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'SENAI Mobile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _rnController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de Registro (RN)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              authProvider.isLoading
                  ? const CircularProgressIndicator(color: AppColors.primary)
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: _executarLogin,
                      child: const Text(
                        'Entrar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}