import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: ListaCompras(),
    ),
  );
}

class ListaCompras extends StatefulWidget {
  @override
  _ListaComprasState createState() => _ListaComprasState();
}

class _ListaComprasState extends State<ListaCompras> {
  List<String> itens = [];
  List<bool> comprado = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void adicionarItem() {
    if (controller.text.isNotEmpty) {
      setState(() {
        itens.add(controller.text);
        comprado.add(false);
        controller.clear();
      });
      salvarDados();
    }
  }

  void alternarComprado(int index) {
    setState(() {
      comprado[index] = !comprado[index];
    });
    salvarDados();
  }

  void removerItem(int index) {
    setState(() {
      itens.removeAt(index);
      comprado.removeAt(index);
    });
    salvarDados();
  }

  void salvarDados() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("itens", itens);

    List<String> listaStatus = comprado.map((e) => e.toString()).toList();
    await prefs.setStringList("comprado", listaStatus);
  }

  void carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      itens = prefs.getStringList("itens") ?? [];
      List<String> listaBool = prefs.getStringList("comprado") ?? [];
      comprado = listaBool.map((e) => e == "true").toList();
    });
  }

  void limparLista() {
    setState(() {
      itens.clear();
      comprado.clear();
    });
    salvarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compras (${itens.length})"),
        actions: [
          IconButton(icon: Icon(Icons.delete_sweep), onPressed: limparLista),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: "Item de mercado...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.add_circle, size: 40, color: Colors.green),
                  onPressed: adicionarItem,
                ),
              ],
            ),
          ),
          Expanded(
            child: itens.isEmpty
                ? Center(child: Text("Sua lista está vazia!"))
                : ListView.builder(
                    itemCount: itens.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Checkbox(
                          value: comprado[index],
                          onChanged: (val) => alternarComprado(index),
                        ),
                        title: Text(
                          itens[index],
                          style: TextStyle(
                            decoration: comprado[index]
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: comprado[index] ? Colors.grey : Colors.black,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => removerItem(index),
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
