import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SenaiStock',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const LoginScreen(),
    );
  }
}

//// 🔐 LOGIN
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Entrar'),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
          },
        ),
      ),
    );
  }
}

//// 🧠 MAIN NAV
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final pages = [
    const HomeScreen(),
    const ProdutosScreen(),
    const EstoqueScreen(),
    const FornecedoresScreen(),
    const MovimentacaoScreen(),
    const PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Produtos'),
          BottomNavigationBarItem(icon: Icon(Icons.storage), label: 'Estoque'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Fornec'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Mov'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

//// 🏠 HOME
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(child: Text('Bem-vindo 🚀')),
    );
  }
}

//// 📦 PRODUTO MODEL
class Produto {
  String nome;
  String categoria;
  int qtd;

  Produto(this.nome, this.categoria, this.qtd);
}

//// 📦 PRODUTOS CRUD
class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({super.key});

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  List<Produto> lista = [];

  void abrirForm({Produto? p, int? index}) {
    final nome = TextEditingController(text: p?.nome);
    final cat = TextEditingController(text: p?.categoria);
    final qtd = TextEditingController(text: p?.qtd.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(p == null ? 'Adicionar' : 'Editar'),

              TextField(controller: nome, decoration: const InputDecoration(labelText: 'Nome')),
              TextField(controller: cat, decoration: const InputDecoration(labelText: 'Categoria')),
              TextField(controller: qtd, decoration: const InputDecoration(labelText: 'Qtd')),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (p == null) {
                      lista.add(Produto(nome.text, cat.text, int.parse(qtd.text)));
                    } else {
                      lista[index!] = Produto(nome.text, cat.text, int.parse(qtd.text));
                    }
                  });

                  Navigator.pop(context);
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  void deletar(int i) {
    setState(() => lista.removeAt(i));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),

      floatingActionButton: FloatingActionButton(
        onPressed: () => abrirForm(),
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: lista.length,
        itemBuilder: (_, i) {
          final p = lista[i];

          return ListTile(
            title: Text(p.nome),
            subtitle: Text('${p.categoria} - ${p.qtd}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () => abrirForm(p: p, index: i)),
                IconButton(icon: const Icon(Icons.delete), onPressed: () => deletar(i)),
              ],
            ),
          );
        },
      ),
    );
  }
}

//// 📊 ESTOQUE
class EstoqueScreen extends StatelessWidget {
  const EstoqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Estoque')),
      body: Center(child: Text('Estoque')),
    );
  }
}

//// 🏭 FORNECEDORES
class FornecedoresScreen extends StatelessWidget {
  const FornecedoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fornecedores')),
      body: Center(child: Text('Fornecedores')),
    );
  }
}

//// 🔄 MOVIMENTAÇÃO
class MovimentacaoScreen extends StatelessWidget {
  const MovimentacaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movimentação')),
      body: Center(child: Text('Movimentações')),
    );
  }
}

//// 👤 PERFIL
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Center(child: Text('Perfil')),
    );
  }
}