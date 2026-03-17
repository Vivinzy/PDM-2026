import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SemaforoApp(),
  ));
}

class SemaforoApp extends StatefulWidget {
  @override
  _SemaforoAppState createState() => _SemaforoAppState();
}

class _SemaforoAppState extends State<SemaforoApp> {
  int estado = 0;

  void mudarSemaforo() {
    setState(() {
      estado++;
      if (estado > 2) {
        estado = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Semáforo Inteligente"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Column(
                children: [
                  _criarLuz(estado == 2 ? Colors.red : Colors.grey[800]!),
                  SizedBox(height: 10),
                  _criarLuz(estado == 1 ? Colors.yellow : Colors.grey[800]!),
                  SizedBox(height: 10),
                  _criarLuz(estado == 0 ? Colors.green : Colors.grey[800]!),
                ],
              ),
            ),

            SizedBox(height: 50),
            Column(
              children: [
                Icon(
                  estado == 2 ? Icons.directions_walk : Icons.pan_tool,
                  size: 100,
                  color: estado == 2 ? Colors.green : Colors.red,
                ),
                Text(
                  estado == 2 ? "PODE ATRAVESSAR" : "AGUARDE",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: estado == 2 ? Colors.green : const Color.fromARGB(255, 255, 5, 5),
                  ),
                ),
              ],
            ),

            SizedBox(height: 50),
            ElevatedButton(
              onPressed: mudarSemaforo,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.blueGrey,
              ),
              child: Text(
                "MUDAR SINAL",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _criarLuz(Color cor) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: cor,
        shape: BoxShape.circle,
        boxShadow: [
          if (cor != Colors.grey[800])
            BoxShadow(color: cor.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)
        ],
      ),
    );
  }
}