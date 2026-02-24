import 'package:flutter/material.dart';

void main() {
  runApp(meuapp()); 
}

class meuapp extends StatelessWidget {

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 231, 231, 231),
        appBar: AppBar(title: Text('Lista de Tarefas'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: Colors.black,
        ),
        

        body: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.radio_button_unchecked),
              title: Text('Estudar Flutter'),
              trailing: Icon(Icons.delete)),

            ListTile(
              leading: Icon(Icons.radio_button_unchecked),
              title: Text('Praticar Dart'),
              trailing: Icon(Icons.delete)),

            ListTile(
              leading: Icon(Icons.radio_button_unchecked),
              title: Text('Criar um App'),
              trailing: Icon(Icons.delete)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Add Task',
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}