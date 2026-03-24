import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ListaContatos(),
  ));
}

class Contato {
  final String nome;
  final String telefone;
  final Color cor;

  const Contato({
    required this.nome,
    required this.telefone,
    required this.cor,
  });
}

class ListaContatos extends StatelessWidget {
  const ListaContatos({super.key});

  static const List<Contato> contatos = [
    Contato(
      nome: 'Viviane Vitoria',
      telefone: '(19) 99014-3084',
      cor: Color(0xFFE91E8C), 
    ),
    Contato(
      nome: 'Duda',
      telefone: '(19) 98269-2448',
      cor: Color(0xFF6C3DD9), 
    ),
    Contato(
      nome: 'Brenda',
      telefone: '(19) 93505-0851',
      cor: Color(0xFF00B4A6), 
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        backgroundColor: const Color(0xFFE91E8C),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          final contato = contatos[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: contato.cor,
              child: Text(
                contato.nome[0], 
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(contato.nome),
            subtitle: Text(contato.telefone),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalheContato(contato: contato),
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
  final Contato contato;

  const DetalheContato({super.key, required this.contato});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        backgroundColor: contato.cor, 
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: contato.cor, 
              child: Text(
                contato.nome[0],
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              contato.nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              contato.telefone,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: contato.cor, 
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LigarContato(contato: contato),
                  ),
                );
              },
              icon: const Icon(Icons.phone),
              label: const Text('Ligar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: contato.cor, 
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LigarContato extends StatelessWidget {
  final Contato contato;

  const LigarContato({super.key, required this.contato});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ligar'),
        backgroundColor: contato.cor, 
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone, size: 80, color: contato.cor), 
            const SizedBox(height: 16),
            Text(
              contato.nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              contato.telefone,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            Text(
              'Ligando...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: contato.cor, 
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: contato.cor, 
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}