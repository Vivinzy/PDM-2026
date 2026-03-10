import 'package:flutter/material.dart';

void main() {
  runApp(const AppHumor());
}

class AppHumor extends StatelessWidget {
  const AppHumor({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TelaHumor(),
    );
  }
}

class TelaHumor extends StatefulWidget {
  const TelaHumor({super.key});

  @override
  State<TelaHumor> createState() => _TelaHumorState();
}

class _TelaHumorState extends State<TelaHumor> {
  String _status = "Neutro";
  Color _corFundo = const Color.fromARGB(255, 255, 203, 246);


  void _atualizarHumor(String novoStatus, Color novaCor) {
    setState(() {
      _status = novoStatus;
      _corFundo = novaCor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _corFundo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "ESTADO ATUAL:",
              style: TextStyle(color: Colors.white70, letterSpacing: 2),
            ),
            Text(
              _status.toUpperCase(),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 60),
            
            // Botões de Ação
            _botaoAcao("FELIZ", const Color.fromARGB(255, 243, 255, 7)),
            const SizedBox(height: 15),
            _botaoAcao("NEUTRO", const Color.fromARGB(255, 149, 149, 149)),
            const SizedBox(height: 15),
            _botaoAcao("BRAVO", const Color.fromARGB(255, 255, 0, 0)),
          ],
        ),
      ),
    );
  }

  Widget _botaoAcao(String rotulo, Color corBotao) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: const StadiumBorder(), 
        ),
        onPressed: () => _atualizarHumor(rotulo, corBotao),
        child: Text(rotulo),
      ),
    );
  }
}