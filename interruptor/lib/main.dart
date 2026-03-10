import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Interruptor(),
  ));
}

class Interruptor extends StatefulWidget {
  const Interruptor({super.key});

  @override
  _InterruptorAppState createState() => _InterruptorAppState();
}

class _InterruptorAppState extends State<Interruptor> {
  bool estaAceso = false;

  void alternaLuz() {
    setState(() {
      estaAceso = !estaAceso;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: estaAceso ? const Color.fromARGB(255, 200, 0, 255) : Colors.grey[900],
      appBar: AppBar(
        title: const Text('Interruptor'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              estaAceso ? Icons.lightbulb : Icons.lightbulb_outline,
              size: 100,
              color: estaAceso ? const Color.fromARGB(255, 255, 255, 255) : Colors.black,
            ),
            const SizedBox(height: 20), 
            ElevatedButton(
              onPressed: alternaLuz, 
              style: ElevatedButton.styleFrom(
                backgroundColor: estaAceso ? Colors.black : const Color.fromARGB(255, 200, 0, 255),
              ),
              child: Text(
                "Interruptor",
                style: TextStyle(
                  color: estaAceso ? const Color.fromARGB(255, 200, 0, 255) : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}