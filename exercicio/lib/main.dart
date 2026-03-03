import 'package:flutter/material.dart';

void main() {
  runApp(const Exercicio());
}
// O que precisa ser passado dentro do runApp?
// uma classe que extende StatelessWidget ou StatefulWidget.

class Exercicio extends StatelessWidget {
  const Exercicio({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoPage(title: 'Lista de Exercicio'),
    );
  }
}
// Esse widget deve ser Stateless ou Stateful? porque?
// Stateless, porque não tem estado, ou seja, não tem variáveis que mudam ao longo do tempo.

class TodoPage extends StatefulWidget {
  const TodoPage({super.key, required this.title});
  final String title;
  @override
  State<TodoPage> createState() => _TodoPageState();
}
class _TodoPageState extends State<TodoPage> {
  final List<String> todoList = [];
  // Por que essa variável precisa estar dentro da classe _TodoPageState?
  // Porque ela é uma variável de estado do widget TodoPage, e portanto deve ser declarada dentro da classe que gerencia o estado do widget.
  final TextEditingController controller = TextEditingController();
  // Qual classe controla o texto digitado? 
  // A classe _TodoPageState controla o texto digitado, pois ela é a classe que gerencia o estado do widget TodoPage e possui acesso ao controller.
 @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isEmpty) return;
                setState(() {
                  todoList.add(text);
                });
                controller.clear();
              },
              child: const Text("Adicionar"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(todoList[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        todoList.removeAt(index);
                      });
                      print(todoList);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void adicionarTarefa() {
  setState(() {
  todoList.add(controller.text);
  });
  }
  void removerTarefa(int index) {
  setState(() {
  todoList.removeAt(index);
  });
  }
  // O que acontece se remover o setState? 
  // Se o setState for removido, a interface do usuário não será atualizada para refletir a nova tarefa adicionada à lista
  //O que deve ser usado para limpar o campo? controller.clear()
  // o que é index? index é a posição do item na lista, começando do zero. Ele é usado para acessar o item específico na lista todoList.
  // Por que usamos .length? .length é usado para obter o número de itens na lista todoList, o que é necessário para construir a lista de tarefas corretamente no ListView.builder.