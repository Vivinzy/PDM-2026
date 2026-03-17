import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TemperaturaApp(),
  ));
}
class TemperaturaApp extends StatefulWidget {
  @override
  _TemperaturaAppState createState() => _TemperaturaAppState();
}

class _TemperaturaAppState extends State<TemperaturaApp> {
  int temperatura = 20;
  void aumentar() {
    setState(() {
      temperatura++;
    });
  }
  void diminuir() {
    setState(() {
      temperatura--;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color corFundo;
    IconData icone;
    String status;

    if (temperatura < 15) {
      corFundo = const Color.fromARGB(255, 0, 87, 158);
      icone = Icons.ac_unit;
      status = "Frio";
    } else if (temperatura < 30) {
      corFundo = const Color.fromARGB(255, 139, 255, 143);
      icone = Icons.wb_sunny;
      status = "Agradável";
    } else {
      corFundo = const Color.fromARGB(255, 255, 0, 25);
      icone = Icons.local_fire_department;
      status = "Quente";
    }

    return Scaffold(
      backgroundColor: corFundo, 
      appBar: AppBar(
        title: Text("Controle de Temperatura"),
        backgroundColor: Colors.white70,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 100, color: Colors.black54),
            Text(
              status,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "$temperatura °C",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: diminuir,
                  child: Icon(Icons.remove),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade300),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: aumentar,
                  child: Icon(Icons.add),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade300),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}