import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/estoque_provider.dart';

class EstoqueScreen extends StatelessWidget {
  const EstoqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EstoqueProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Estoque")),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: provider.produtos
                  .map((e) => ListTile(title: Text(e)))
                  .toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.fetch(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}