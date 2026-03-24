import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: TelaInicial()),
  );
}

// ------------ TELA 1 ----------
class TelaInicial extends StatelessWidget {
  const TelaInicial({Key? key}) : super(key: key);
  final String nome = "Vitoria";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela Inicial"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Ir para Segunda Tela"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SegundaTela(nome: nome)),
            );
          },
        ),
      ),
    );
  }
}

// ------------ TELA 2 ----------
class SegundaTela extends StatelessWidget {
  final String nome;

  SegundaTela({required this.nome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Segunda Tela"),
        backgroundColor: Colors.purple,
      ),
      body: Center(child: Text("Olá, $nome!", style: TextStyle(fontSize: 28))),
    );
  }
}
