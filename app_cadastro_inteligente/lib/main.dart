import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: AppCadastrado()));
}

class AppCadastrado extends StatefulWidget {
  @override
  _AppCadastradoState createState() => _AppCadastradoState();
}

class _AppCadastradoState extends State<AppCadastrado> {
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
          'CREATE TABLE dados(id INTEGER PRIMARY KEY AUTOINCREMENT, titulo TEXT, descricao TEXT, data TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> inserirItem(String titulo, String descricao, String data) async {
    final db = await criarBanco();
    await db.insert('dados', {"titulo": titulo, "descricao": descricao, "data": data});
    carregarDados();
  }


  Future<void> carregarDados() async {
    final db = await criarBanco();
    final lista = await db.query("dados", orderBy: "titulo ASC");
    setState(() {
      dados = lista;
    });
  }

  Future<void> atualizarItem(int id, String titulo, String descricao) async {
    final db = await criarBanco();
    await db.update(
      'dados',
      {"titulo": titulo, "descricao": descricao},
      where: 'id = ?',
      whereArgs: [id],
    );
    carregarDados();
  }

  Future<void> deletarItem(int id) async {
    final db = await criarBanco();
    await db.delete("dados", where: "id = ?", whereArgs: [id]);
    carregarDados();
  }

  void abrirDialogo({int? id, String? titulo, String? descricao}) {
    tituloController.text = titulo ?? "";
    descricaoController.text = descricao ?? "";
    showDialog(
      context: this.context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? "Novo Item" : "Editar Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: InputDecoration(
                  labelText: "Título",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (tituloController.text.isNotEmpty &&
                    descricaoController.text.isNotEmpty) {
                  if (id == null) {
                    inserirItem(
                      tituloController.text,
                      descricaoController.text,
                    );
                  } else {
                    atualizarItem(
                      id,
                      tituloController.text,
                      descricaoController.text,
                    );
                  }
                  Navigator.pop(context);
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
      appBar: AppBar(title: Text("Cadastro Inteligente"), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: dados.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "Nenhum item cadastrado",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Clique no + para adicionar",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: dados.length,
                    itemBuilder: (context, index) {
                      final item = dados[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(item["titulo"]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(item["descricao"]),
                              SizedBox(height: 8),
                              Text(
                                "${item["data"] ?? "N/A"}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    133,
                                    214,
                                  ),
                                ),
                                onPressed: () {
                                  abrirDialogo(
                                    id: item["id"],
                                    titulo: item["titulo"],
                                    descricao: item["descricao"],
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    195,
                                    245,
                                  ),
                                ),
                                onPressed: () {
                                  deletarItem(item["id"]);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => abrirDialogo(),
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    tituloController.dispose();
    descricaoController.dispose();
    super.dispose();
  }
}
