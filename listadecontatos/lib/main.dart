import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ListaContatos(),
  ));
}

class ListaContatos extends StatelessWidget {
  final List<Map<String, String>> contatos = [
    {'nome': 'Viviane Vitoria',      'telefone': '(19) 99014-3084'},
    {'nome': 'Duda','telefone': '(19) 98269-2448'},
    {'nome': 'Brenda',  'telefone': '(19)  93505-0851'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
        backgroundColor: const Color.fromARGB(111, 255, 166, 236),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          String nome     = contatos[index]['nome']!;
          String telefone = contatos[index]['telefone']!;

          return ListTile(
            leading: Icon(Icons.person),
            title: Text(nome),
            subtitle: Text(telefone),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalheContato(
                    nome: nome,
                    telefone: telefone,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetalheContato extends StatelessWidget {
  final String nome;
  final String telefone;

  const DetalheContato({
    required this.nome,
    required this.telefone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        backgroundColor: const Color.fromARGB(106, 195, 0, 255),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: const Color.fromARGB(71, 33, 149, 243)),
            SizedBox(height: 16),
            Text(nome,     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(telefone, style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 0, 0, 0))),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
              label: Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}