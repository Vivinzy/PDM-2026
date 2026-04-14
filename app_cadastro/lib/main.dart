import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: AppCadastro()));
}

class AppCadastro extends StatefulWidget {
  @override
  _AppCadastroState createState() => _AppCadastroState();
}

class _AppCadastroState extends State<AppCadastro> {
  TextEditingController tituloController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  List<Map<String, dynamic>> dados = [];

  Future<Database> criarBanco() async {
    final caminho = await getDatabasesPath();
    final localBanco = join(caminho, 'banco.db');

    return openDatabase(
      localBanco,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE dados(id INTEGER PRIMARY KEY AUTOINCREMENT, titulo TEXT, descricao TEXT, data TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> inserirDado(String titulo, String descricao) async {
    final db = await criarBanco();
    String data = DateTime.now().toString();

    await db.insert('dados', {
      "titulo": titulo,
      "descricao": descricao,
      "data": data,
    });

    carregarDados();
  }

  Future<void> carregarDados() async {
    final db = await criarBanco();

    final lista = await db.query("dados", orderBy: "titulo ASC");

    setState(() {
      dados = lista;
    });
  }

  Future<void> deletarDado(int id) async {
    final db = await criarBanco();

    await db.delete("dados", where: "id = ?", whereArgs: [id]);

    carregarDados();
  }

  Future<void> atualizarDado(int id, String titulo, String descricao) async {
    final db = await criarBanco();

    await db.update(
      "dados",
      {"titulo": titulo, "descricao": descricao},
      where: "id = ?",
      whereArgs: [id],
    );

    carregarDados();
  }

  void mostrarDialogEdicao(BuildContext context, Map<String, dynamic> item) {
    tituloController.text = item["titulo"];
    descricaoController.text = item["descricao"];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Editar Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: InputDecoration(labelText: "Título"),
              ),
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(labelText: "Descrição"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                if (tituloController.text.isNotEmpty &&
                    descricaoController.text.isNotEmpty) {
                  atualizarDado(
                    item["id"],
                    tituloController.text,
                    descricaoController.text,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro Inteligente")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: tituloController,
              decoration: InputDecoration(
                labelText: "Título",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: descricaoController,
              decoration: InputDecoration(
                labelText: "Descrição",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (tituloController.text.isNotEmpty &&
                  descricaoController.text.isNotEmpty) {
                inserirDado(tituloController.text, descricaoController.text);
                tituloController.clear();
                descricaoController.clear();
              }
            },
            child: Text("Salvar"),
          ),
          Expanded(
            child: dados.isEmpty
                ? Center(child: Text("Nenhum item cadastrado"))
                : ListView.builder(
                    itemCount: dados.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(dados[index]["titulo"]),
                        subtitle: Text(dados[index]["descricao"]),
                        onTap: () {
                          mostrarDialogEdicao(context, dados[index]);
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deletarDado(dados[index]["id"]);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
