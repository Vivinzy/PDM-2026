import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: PaginaNumero()));
}

class PaginaNumero extends StatefulWidget{
  @override
  _PaginaNumeroState createState() => _PaginaNumeroState();
}

class _PaginaNumeroState extends State<PaginaNumero>{
 int numero = 0; 

 void sortear(){
  setState(() {
    numero = (DateTime.now().millisecondsSinceEpoch % 10) + 1;
  });
 }
 @override
  Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(title: Text('Sorteio de Número')),
    body: Center (
      child: Text("Número sorteado: $numero", style: TextStyle(fontSize: 30),
      ),
    ),
    //Center
      floatingActionButton: FloatingActionButton(
        onPressed: sortear,
        child: Icon(Icons.casino),
      ),
  );
  }
}