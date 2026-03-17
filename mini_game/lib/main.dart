import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: JogoApp(),
  ));
}

class JogoApp extends StatefulWidget {
  @override
  _JogoAppState createState() => _JogoAppState();
}

class _JogoAppState extends State<JogoApp> {
  
  IconData iconeComputador = Icons.help_outline;
  String resultado = "Escolha uma opção";
  int pontosJogador = 0;
  int pontosComputador = 0;
  List<String> opcoes = ["pedra", "papel", "tesoura"];

  void jogar(String escolhaUsuario) {
    var numero = Random().nextInt(3);
    var escolhaComputador = opcoes[numero];

    setState(() {

      if (escolhaComputador == "pedra") {
        iconeComputador = Icons.landscape;
      } else if (escolhaComputador == "papel") {
        iconeComputador = Icons.pan_tool;
      } else {
        iconeComputador = Icons.content_cut;
      }

      if (escolhaUsuario == escolhaComputador) {
        resultado = "Empate!";
      } else if (
        (escolhaUsuario == "pedra" && escolhaComputador == "tesoura") ||
        (escolhaUsuario == "papel" && escolhaComputador == "pedra") ||
        (escolhaUsuario == "tesoura" && escolhaComputador == "papel")
      ) {
        pontosJogador++;
        resultado = "Você venceu!";
      } else {
        pontosComputador++;
        resultado = "Computador venceu!";
      }

      if (pontosJogador == 5) {
        resultado = "🏆 Você é o Campeão!";
        _resetarPlacarAutomatico();
      } else if (pontosComputador == 5) {
        resultado = "🤖 O PC é o Campeão!";
        _resetarPlacarAutomatico();
      }
    });
  }

  void _resetarPlacarAutomatico() {
    pontosJogador = 0;
    pontosComputador = 0;
  }

  void resetarPlacarManual() {
    setState(() {
      pontosJogador = 0;
      pontosComputador = 0;
      resultado = "Placar zerado!";
      iconeComputador = Icons.help_outline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedra Papel Tesoura"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Escolha do Computador:", style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Icon(iconeComputador, size: 100, color: Colors.blue),
            ),
            Text(
              resultado,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            SizedBox(height: 20),
            Text(
              "Você: $pontosJogador  |  PC: $pontosComputador",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _botaoEscolha("pedra", Icons.landscape),
                _botaoEscolha("papel", Icons.pan_tool),
                _botaoEscolha("tesoura", Icons.content_cut),
              ],
            ),
            SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: resetarPlacarManual,
              icon: Icon(Icons.refresh),
              label: Text("Resetar Jogo"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
            )
          ],
        ),
      ),
    );
  }

  Widget _botaoEscolha(String escolha, IconData icone) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icone),
          iconSize: 50,
          color: Colors.blueGrey,
          onPressed: () => jogar(escolha),
        ),
        Text(escolha.toUpperCase(), style: TextStyle(fontSize: 10)),
      ],
    );
  }
}