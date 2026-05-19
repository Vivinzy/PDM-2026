import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

// ─────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────

class Produto {
  String id;
  String nome;
  String categoria;
  int qtd;
  double preco;
  int qtdMinima;
  String descricao;

  Produto({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.qtd,
    required this.preco,
    this.qtdMinima = 5,
    this.descricao = '',
  });

  bool get estoqueBaixo => qtd <= qtdMinima;
  double get valorTotal => qtd * preco;
}

class Fornecedor {
  String id;
  String nome;
  String contato;
  String email;
  String telefone;
  String cnpj;
  List<String> categorias;

  Fornecedor({
    required this.id,
    required this.nome,
    required this.contato,
    required this.email,
    required this.telefone,
    this.cnpj = '',
    this.categorias = const [],
  });
}

enum TipoMovimentacao { entrada, saida, ajuste }

class Movimentacao {
  String id;
  String produtoId;
  String produtoNome;
  TipoMovimentacao tipo;
  int quantidade;
  String motivo;
  DateTime data;
  String responsavel;

  Movimentacao({
    required this.id,
    required this.produtoId,
    required this.produtoNome,
    required this.tipo,
    required this.quantidade,
    required this.motivo,
    required this.data,
    required this.responsavel,
  });
}

// ─────────────────────────────────────────────
// GLOBAL STATE (simples, sem provider)
// ─────────────────────────────────────────────

class AppData {
  static List<Produto> produtos = [
    Produto(id: '1', nome: 'Parafuso M6', categoria: 'Fixação', qtd: 3, preco: 0.50, qtdMinima: 10, descricao: 'Parafuso sextavado M6x20'),
    Produto(id: '2', nome: 'Resistor 10kΩ', categoria: 'Eletrônica', qtd: 200, preco: 0.10, qtdMinima: 50, descricao: 'Resistor 1/4W 5%'),
    Produto(id: '3', nome: 'Cabo USB-C', categoria: 'Cabos', qtd: 15, preco: 12.90, qtdMinima: 5, descricao: 'Cabo USB-C 1m'),
    Produto(id: '4', nome: 'Arduino Uno', categoria: 'Eletrônica', qtd: 4, preco: 89.90, qtdMinima: 5, descricao: 'Microcontrolador Arduino Uno R3'),
  ];

  static List<Fornecedor> fornecedores = [
    Fornecedor(id: '1', nome: 'TechParts Ltda', contato: 'João Silva', email: 'joao@techparts.com', telefone: '(11) 9999-0000', cnpj: '12.345.678/0001-99', categorias: ['Eletrônica', 'Cabos']),
    Fornecedor(id: '2', nome: 'MetalFix Ind.', contato: 'Maria Costa', email: 'maria@metalfix.com', telefone: '(11) 8888-1111', cnpj: '98.765.432/0001-11', categorias: ['Fixação']),
  ];

  static List<Movimentacao> movimentacoes = [
    Movimentacao(id: '1', produtoId: '2', produtoNome: 'Resistor 10kΩ', tipo: TipoMovimentacao.entrada, quantidade: 100, motivo: 'Compra fornecedor', data: DateTime.now().subtract(const Duration(days: 2)), responsavel: 'Admin'),
    Movimentacao(id: '2', produtoId: '1', produtoNome: 'Parafuso M6', tipo: TipoMovimentacao.saida, quantidade: 20, motivo: 'Uso em aula', data: DateTime.now().subtract(const Duration(days: 1)), responsavel: 'Prof. Carlos'),
  ];

  static String usuarioNome = 'Administrador';
  static String usuarioEmail = 'admin@senai.br';
  static String usuarioCargo = 'Gestor de Estoque';

  static String gerarId() => DateTime.now().millisecondsSinceEpoch.toString();

  static List<Produto> get produtosEstoqueBaixo =>
      produtos.where((p) => p.estoqueBaixo).toList();

  static double get valorTotalEstoque =>
      produtos.fold(0, (sum, p) => sum + p.valorTotal);

  static int get totalItens => produtos.fold(0, (sum, p) => sum + p.qtd);

  static Map<String, int> get porCategoria {
    final map = <String, int>{};
    for (final p in produtos) {
      map[p.categoria] = (map[p.categoria] ?? 0) + p.qtd;
    }
    return map;
  }
}

// ─────────────────────────────────────────────
// APP
// ─────────────────────────────────────────────

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SenaiStock',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD32F2F),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFD32F2F),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFD32F2F),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD32F2F),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// 🔐 LOGIN
// ─────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(text: 'admin@senai.br');
  final _senha = TextEditingController(text: '123456');
  bool _verSenha = false;
  bool _carregando = false;
  final _form = GlobalKey<FormState>();

  void _login() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _carregando = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)],
                ),
                child: const Icon(Icons.inventory_2, size: 56, color: Color(0xFFD32F2F)),
              ),
              const SizedBox(height: 24),
              const Text('SenaiStock', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const Text('Gestão de Almoxarifado', style: TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 48),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Entrar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _email,
                          decoration: _dec('E-mail', Icons.email),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => v!.isEmpty ? 'Informe o e-mail' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _senha,
                          decoration: _dec('Senha', Icons.lock).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(_verSenha ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _verSenha = !_verSenha),
                            ),
                          ),
                          obscureText: !_verSenha,
                          validator: (v) => v!.length < 4 ? 'Senha muito curta' : null,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _carregando ? null : _login,
                            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            child: _carregando
                                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text('Entrar', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      );
}

// ─────────────────────────────────────────────
// 🧭 MAIN NAV
// ─────────────────────────────────────────────

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onRefresh: _rebuild),
      ProdutosScreen(onRefresh: _rebuild),
      EstoqueScreen(onRefresh: _rebuild),
      FornecedoresScreen(onRefresh: _rebuild),
      MovimentacaoScreen(onRefresh: _rebuild),
      PerfilScreen(onLogout: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Produtos'),
          NavigationDestination(icon: Icon(Icons.storage_outlined), selectedIcon: Icon(Icons.storage), label: 'Estoque'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Fornec.'),
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'Mov.'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 🏠 HOME / DASHBOARD
// ─────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  final VoidCallback onRefresh;
  const HomeScreen({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final alertas = AppData.produtosEstoqueBaixo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: onRefresh),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Boas-vindas
            Card(
              color: const Color(0xFFD32F2F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xFFD32F2F))),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Olá, ${AppData.usuarioNome}!', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(AppData.usuarioCargo, style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Métricas
            const Text('Resumo do Estoque', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _MetricCard(label: 'Total de Produtos', value: '${AppData.produtos.length}', icon: Icons.inventory_2, color: Colors.blue),
                _MetricCard(label: 'Total de Itens', value: '${AppData.totalItens}', icon: Icons.widgets, color: Colors.green),
                _MetricCard(label: 'Valor em Estoque', value: 'R\$ ${AppData.valorTotalEstoque.toStringAsFixed(2)}', icon: Icons.attach_money, color: Colors.orange),
                _MetricCard(label: 'Alertas', value: '${alertas.length}', icon: Icons.warning, color: alertas.isEmpty ? Colors.grey : Colors.red),
              ],
            ),
            const SizedBox(height: 16),

            // Distribuição por categoria
            const Text('Por Categoria', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...AppData.porCategoria.entries.map((e) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.category, color: Color(0xFFD32F2F)),
                title: Text(e.key),
                trailing: Chip(label: Text('${e.value} un'), backgroundColor: Colors.red.shade50),
              ),
            )),

            // Alertas
            if (alertas.isNotEmpty) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.red),
                  const SizedBox(width: 8),
                  Text('Estoque Crítico (${alertas.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                ],
              ),
              const SizedBox(height: 8),
              ...alertas.map((p) => Card(
                color: Colors.red.shade50,
                child: ListTile(
                  leading: const Icon(Icons.error_outline, color: Colors.red),
                  title: Text(p.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Qtd: ${p.qtd} | Mínimo: ${p.qtdMinima}'),
                  trailing: const Chip(label: Text('Repor!'), backgroundColor: Colors.red, labelStyle: TextStyle(color: Colors.white)),
                ),
              )),
            ],

            // Últimas movimentações
            const SizedBox(height: 16),
            const Text('Últimas Movimentações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...AppData.movimentacoes.reversed.take(3).map((m) => _MovCard(mov: m)),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _MetricCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MovCard extends StatelessWidget {
  final Movimentacao mov;
  const _MovCard({required this.mov});

  @override
  Widget build(BuildContext context) {
    final isEntrada = mov.tipo == TipoMovimentacao.entrada;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isEntrada ? Colors.green.shade100 : Colors.red.shade100,
          child: Icon(isEntrada ? Icons.arrow_downward : Icons.arrow_upward,
              color: isEntrada ? Colors.green : Colors.red),
        ),
        title: Text(mov.produtoNome),
        subtitle: Text('${mov.motivo} • ${_fmt(mov.data)}'),
        trailing: Text('${isEntrada ? '+' : '-'}${mov.quantidade}',
            style: TextStyle(fontWeight: FontWeight.bold, color: isEntrada ? Colors.green : Colors.red, fontSize: 16)),
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

// ─────────────────────────────────────────────
// 📦 PRODUTOS CRUD
// ─────────────────────────────────────────────

class ProdutosScreen extends StatefulWidget {
  final VoidCallback onRefresh;
  const ProdutosScreen({super.key, required this.onRefresh});

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  String _busca = '';
  String _filtroCategoria = 'Todas';

  List<Produto> get _lista {
    return AppData.produtos.where((p) {
      final buscaOk = _busca.isEmpty || p.nome.toLowerCase().contains(_busca.toLowerCase()) || p.categoria.toLowerCase().contains(_busca.toLowerCase());
      final catOk = _filtroCategoria == 'Todas' || p.categoria == _filtroCategoria;
      return buscaOk && catOk;
    }).toList();
  }

  List<String> get _categorias {
    final cats = AppData.produtos.map((p) => p.categoria).toSet().toList();
    cats.insert(0, 'Todas');
    return cats;
  }

  void _abrirForm({Produto? p}) {
    final nome = TextEditingController(text: p?.nome);
    final cat = TextEditingController(text: p?.categoria);
    final qtd = TextEditingController(text: p?.qtd.toString() ?? '0');
    final preco = TextEditingController(text: p?.preco.toStringAsFixed(2) ?? '0.00');
    final qtdMin = TextEditingController(text: p?.qtdMinima.toString() ?? '5');
    final desc = TextEditingController(text: p?.descricao);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        builder: (_, ctrl) => SingleChildScrollView(
          controller: ctrl,
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Text(p == null ? 'Novo Produto' : 'Editar Produto', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _campo(nome, 'Nome do Produto', Icons.label, obrigatorio: true),
                const SizedBox(height: 12),
                _campo(cat, 'Categoria', Icons.category, obrigatorio: true),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _campo(qtd, 'Quantidade', Icons.widgets, tipo: TextInputType.number, obrigatorio: true)),
                  const SizedBox(width: 12),
                  Expanded(child: _campo(qtdMin, 'Qtd Mínima', Icons.warning_amber, tipo: TextInputType.number)),
                ]),
                const SizedBox(height: 12),
                _campo(preco, 'Preço (R\$)', Icons.attach_money, tipo: TextInputType.number, obrigatorio: true),
                const SizedBox(height: 12),
                TextFormField(
                  controller: desc,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    setState(() {
                      if (p == null) {
                        AppData.produtos.add(Produto(
                          id: AppData.gerarId(),
                          nome: nome.text,
                          categoria: cat.text,
                          qtd: int.tryParse(qtd.text) ?? 0,
                          preco: double.tryParse(preco.text.replaceAll(',', '.')) ?? 0,
                          qtdMinima: int.tryParse(qtdMin.text) ?? 5,
                          descricao: desc.text,
                        ));
                      } else {
                        p.nome = nome.text;
                        p.categoria = cat.text;
                        p.qtd = int.tryParse(qtd.text) ?? p.qtd;
                        p.preco = double.tryParse(preco.text.replaceAll(',', '.')) ?? p.preco;
                        p.qtdMinima = int.tryParse(qtdMin.text) ?? p.qtdMinima;
                        p.descricao = desc.text;
                      }
                    });
                    widget.onRefresh();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar Produto', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmarDeletar(Produto p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Produto'),
        content: Text('Deseja excluir "${p.nome}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => AppData.produtos.remove(p));
              widget.onRefresh();
              Navigator.pop(context);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _mostrarFiltro(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirForm(),
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
      body: Column(
        children: [
          // Busca
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (v) => setState(() => _busca = v),
              decoration: InputDecoration(
                hintText: 'Buscar produto...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),

          // Chips categoria
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _categorias.map((c) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(c),
                  selected: _filtroCategoria == c,
                  onSelected: (_) => setState(() => _filtroCategoria = c),
                  selectedColor: const Color(0xFFD32F2F),
                  labelStyle: TextStyle(color: _filtroCategoria == c ? Colors.white : null),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Lista
          Expanded(
            child: _lista.isEmpty
                ? const Center(child: Text('Nenhum produto encontrado'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _lista.length,
                    itemBuilder: (_, i) {
                      final p = _lista[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: p.estoqueBaixo ? Colors.red.shade100 : Colors.green.shade100,
                            child: Icon(Icons.inventory_2,
                                color: p.estoqueBaixo ? Colors.red : Colors.green),
                          ),
                          title: Row(
                            children: [
                              Expanded(child: Text(p.nome, style: const TextStyle(fontWeight: FontWeight.bold))),
                              if (p.estoqueBaixo) const Chip(label: Text('Baixo', style: TextStyle(color: Colors.white, fontSize: 11)), backgroundColor: Colors.red, padding: EdgeInsets.zero),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${p.categoria} • R\$ ${p.preco.toStringAsFixed(2)}'),
                              Text('Qtd: ${p.qtd} | Valor: R\$ ${p.valorTotal.toStringAsFixed(2)}',
                                  style: TextStyle(color: p.estoqueBaixo ? Colors.red : Colors.green.shade700, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (v) {
                              if (v == 'editar') _abrirForm(p: p);
                              if (v == 'deletar') _confirmarDeletar(p);
                              if (v == 'detalhe') _verDetalhe(p);
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(value: 'detalhe', child: ListTile(leading: Icon(Icons.info_outline), title: Text('Detalhes'))),
                              PopupMenuItem(value: 'editar', child: ListTile(leading: Icon(Icons.edit), title: Text('Editar'))),
                              PopupMenuItem(value: 'deletar', child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Excluir', style: TextStyle(color: Colors.red)))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _verDetalhe(Produto p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(p.nome),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detalheRow('Categoria', p.categoria),
            _detalheRow('Quantidade', '${p.qtd} unidades'),
            _detalheRow('Qtd Mínima', '${p.qtdMinima} unidades'),
            _detalheRow('Preço Unit.', 'R\$ ${p.preco.toStringAsFixed(2)}'),
            _detalheRow('Valor Total', 'R\$ ${p.valorTotal.toStringAsFixed(2)}'),
            if (p.descricao.isNotEmpty) _detalheRow('Descrição', p.descricao),
            _detalheRow('Status', p.estoqueBaixo ? '⚠️ Estoque Baixo' : '✅ Normal'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar'))],
      ),
    );
  }

  Widget _detalheRow(String label, String valor) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(valor)),
      ],
    ),
  );

  void _mostrarFiltro() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Filtrar por categoria'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _categorias.map((c) => RadioListTile<String>(
            title: Text(c),
            value: c,
            groupValue: _filtroCategoria,
            onChanged: (v) {
              setState(() => _filtroCategoria = v!);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  Widget _campo(TextEditingController ctrl, String label, IconData icon,
      {TextInputType tipo = TextInputType.text, bool obrigatorio = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: tipo,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
      validator: obrigatorio ? (v) => v!.isEmpty ? 'Campo obrigatório' : null : null,
    );
  }
}

// ─────────────────────────────────────────────
// 📊 ESTOQUE
// ─────────────────────────────────────────────

class EstoqueScreen extends StatefulWidget {
  final VoidCallback onRefresh;
  const EstoqueScreen({super.key, required this.onRefresh});

  @override
  State<EstoqueScreen> createState() => _EstoqueScreenState();
}

class _EstoqueScreenState extends State<EstoqueScreen> {
  String _ordenar = 'nome';

  List<Produto> get _lista {
    final l = [...AppData.produtos];
    switch (_ordenar) {
      case 'qtd_asc': l.sort((a, b) => a.qtd.compareTo(b.qtd));
      case 'qtd_desc': l.sort((a, b) => b.qtd.compareTo(a.qtd));
      case 'valor': l.sort((a, b) => b.valorTotal.compareTo(a.valorTotal));
      default: l.sort((a, b) => a.nome.compareTo(b.nome));
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {
    final criticos = AppData.produtosEstoqueBaixo;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estoque'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) => setState(() => _ordenar = v),
            icon: const Icon(Icons.sort),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'nome', child: Text('Nome')),
              PopupMenuItem(value: 'qtd_asc', child: Text('Quantidade ↑')),
              PopupMenuItem(value: 'qtd_desc', child: Text('Quantidade ↓')),
              PopupMenuItem(value: 'valor', child: Text('Valor Total')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumo
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _resumo('SKUs', '${AppData.produtos.length}', Colors.blue),
                    _resumo('Total Itens', '${AppData.totalItens}', Colors.green),
                    _resumo('Valor', 'R\$${AppData.valorTotalEstoque.toStringAsFixed(0)}', Colors.orange),
                    _resumo('Alertas', '${criticos.length}', Colors.red),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (criticos.isNotEmpty) ...[
              const Text('⚠️ Produtos Críticos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
              const SizedBox(height: 8),
              ...criticos.map((p) => Card(
                color: Colors.red.shade50,
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: Text(p.nome),
                  subtitle: LinearProgressIndicator(
                    value: p.qtd / p.qtdMinima,
                    backgroundColor: Colors.red.shade200,
                    color: Colors.red,
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${p.qtd}/${p.qtdMinima}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      const Text('un', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: 16),
            ],

            const Text('Todos os Produtos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._lista.map((p) {
              final pct = p.qtdMinima > 0 ? (p.qtd / (p.qtdMinima * 3)).clamp(0.0, 1.0) : 1.0;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(p.nome, style: const TextStyle(fontWeight: FontWeight.bold))),
                          Text('R\$ ${p.valorTotal.toStringAsFixed(2)}', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(p.categoria, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const Spacer(),
                          Text('${p.qtd} un', style: TextStyle(color: p.estoqueBaixo ? Colors.red : Colors.green.shade700)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: pct,
                        backgroundColor: Colors.grey.shade200,
                        color: p.estoqueBaixo ? Colors.red : Colors.green,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _resumo(String label, String valor, Color cor) => Column(
    children: [
      Text(valor, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: cor)),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ],
  );
}

// ─────────────────────────────────────────────
// 🏭 FORNECEDORES CRUD
// ─────────────────────────────────────────────

class FornecedoresScreen extends StatefulWidget {
  final VoidCallback onRefresh;
  const FornecedoresScreen({super.key, required this.onRefresh});

  @override
  State<FornecedoresScreen> createState() => _FornecedoresScreenState();
}

class _FornecedoresScreenState extends State<FornecedoresScreen> {
  String _busca = '';

  List<Fornecedor> get _lista => AppData.fornecedores
      .where((f) => _busca.isEmpty || f.nome.toLowerCase().contains(_busca.toLowerCase()) || f.contato.toLowerCase().contains(_busca.toLowerCase()))
      .toList();

  void _abrirForm({Fornecedor? f}) {
    final nome = TextEditingController(text: f?.nome);
    final contato = TextEditingController(text: f?.contato);
    final email = TextEditingController(text: f?.email);
    final tel = TextEditingController(text: f?.telefone);
    final cnpj = TextEditingController(text: f?.cnpj);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        builder: (_, ctrl) => SingleChildScrollView(
          controller: ctrl,
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Text(f == null ? 'Novo Fornecedor' : 'Editar Fornecedor', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _campof(nome, 'Razão Social / Nome', Icons.business, obrig: true),
                const SizedBox(height: 12),
                _campof(contato, 'Contato', Icons.person, obrig: true),
                const SizedBox(height: 12),
                _campof(email, 'E-mail', Icons.email, tipo: TextInputType.emailAddress),
                const SizedBox(height: 12),
                _campof(tel, 'Telefone', Icons.phone, tipo: TextInputType.phone),
                const SizedBox(height: 12),
                _campof(cnpj, 'CNPJ', Icons.badge),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    setState(() {
                      if (f == null) {
                        AppData.fornecedores.add(Fornecedor(
                          id: AppData.gerarId(),
                          nome: nome.text,
                          contato: contato.text,
                          email: email.text,
                          telefone: tel.text,
                          cnpj: cnpj.text,
                        ));
                      } else {
                        f.nome = nome.text;
                        f.contato = contato.text;
                        f.email = email.text;
                        f.telefone = tel.text;
                        f.cnpj = cnpj.text;
                      }
                    });
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campof(TextEditingController ctrl, String label, IconData icon,
      {TextInputType tipo = TextInputType.text, bool obrig = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: tipo,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
      validator: obrig ? (v) => v!.isEmpty ? 'Obrigatório' : null : null,
    );
  }

  void _deletar(Fornecedor f) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Fornecedor'),
        content: Text('Excluir "${f.nome}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () { setState(() => AppData.fornecedores.remove(f)); Navigator.pop(context); },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fornecedores')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirForm(),
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (v) => setState(() => _busca = v),
              decoration: InputDecoration(
                hintText: 'Buscar fornecedor...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),
          Expanded(
            child: _lista.isEmpty
                ? const Center(child: Text('Nenhum fornecedor'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _lista.length,
                    itemBuilder: (_, i) {
                      final f = _lista[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(f.nome[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                          ),
                          title: Text(f.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(f.contato),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: Column(
                                children: [
                                  if (f.email.isNotEmpty) _infoRow(Icons.email, f.email),
                                  if (f.telefone.isNotEmpty) _infoRow(Icons.phone, f.telefone),
                                  if (f.cnpj.isNotEmpty) _infoRow(Icons.badge, f.cnpj),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(onPressed: () => _abrirForm(f: f), icon: const Icon(Icons.edit), label: const Text('Editar')),
                                      const SizedBox(width: 8),
                                      TextButton.icon(onPressed: () => _deletar(f), icon: const Icon(Icons.delete, color: Colors.red), label: const Text('Excluir', style: TextStyle(color: Colors.red))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(children: [Icon(icon, size: 16, color: Colors.grey), const SizedBox(width: 8), Text(text)]),
  );
}

// ─────────────────────────────────────────────
// 🔄 MOVIMENTAÇÃO
// ─────────────────────────────────────────────

class MovimentacaoScreen extends StatefulWidget {
  final VoidCallback onRefresh;
  const MovimentacaoScreen({super.key, required this.onRefresh});

  @override
  State<MovimentacaoScreen> createState() => _MovimentacaoScreenState();
}

class _MovimentacaoScreenState extends State<MovimentacaoScreen> {
  String _filtro = 'todos';

  List<Movimentacao> get _lista {
    if (_filtro == 'entrada') return AppData.movimentacoes.where((m) => m.tipo == TipoMovimentacao.entrada).toList().reversed.toList();
    if (_filtro == 'saida') return AppData.movimentacoes.where((m) => m.tipo == TipoMovimentacao.saida).toList().reversed.toList();
    return AppData.movimentacoes.reversed.toList();
  }

  void _novaMovimentacao() {
    Produto? prodSelecionado;
    TipoMovimentacao tipo = TipoMovimentacao.entrada;
    final qtd = TextEditingController();
    final motivo = TextEditingController();
    final resp = TextEditingController(text: AppData.usuarioNome);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(builder: (ctx, setS) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        builder: (_, ctrl) => SingleChildScrollView(
          controller: ctrl,
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              const Text('Nova Movimentação', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Tipo
              const Text('Tipo:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<TipoMovimentacao>(
                segments: const [
                  ButtonSegment(value: TipoMovimentacao.entrada, label: Text('Entrada'), icon: Icon(Icons.arrow_downward)),
                  ButtonSegment(value: TipoMovimentacao.saida, label: Text('Saída'), icon: Icon(Icons.arrow_upward)),
                  ButtonSegment(value: TipoMovimentacao.ajuste, label: Text('Ajuste'), icon: Icon(Icons.tune)),
                ],
                selected: {tipo},
                onSelectionChanged: (v) => setS(() => tipo = v.first),
              ),
              const SizedBox(height: 16),

              // Produto
              const Text('Produto:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<Produto>(
                value: prodSelecionado,
                hint: const Text('Selecionar produto'),
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true),
                items: AppData.produtos.map((p) => DropdownMenuItem(value: p, child: Text('${p.nome} (${p.qtd} un)'))).toList(),
                onChanged: (v) => setS(() => prodSelecionado = v),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: qtd,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantidade',
                  prefixIcon: const Icon(Icons.numbers),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: motivo,
                decoration: InputDecoration(
                  labelText: 'Motivo',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: resp,
                decoration: InputDecoration(
                  labelText: 'Responsável',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  if (prodSelecionado == null || qtd.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
                    return;
                  }
                  final q = int.tryParse(qtd.text) ?? 0;
                  if (q <= 0) return;

                  setState(() {
                    // Atualiza estoque
                    final idx = AppData.produtos.indexOf(prodSelecionado!);
                    if (tipo == TipoMovimentacao.entrada) {
                      AppData.produtos[idx].qtd += q;
                    } else if (tipo == TipoMovimentacao.saida) {
                      AppData.produtos[idx].qtd = (AppData.produtos[idx].qtd - q).clamp(0, 99999);
                    } else {
                      AppData.produtos[idx].qtd = q;
                    }

                    AppData.movimentacoes.add(Movimentacao(
                      id: AppData.gerarId(),
                      produtoId: prodSelecionado!.id,
                      produtoNome: prodSelecionado!.nome,
                      tipo: tipo,
                      quantidade: q,
                      motivo: motivo.text.isEmpty ? 'Sem motivo' : motivo.text,
                      data: DateTime.now(),
                      responsavel: resp.text,
                    ));
                  });
                  widget.onRefresh();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check),
                label: const Text('Registrar', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ],
          ),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entradas = AppData.movimentacoes.where((m) => m.tipo == TipoMovimentacao.entrada).fold(0, (s, m) => s + m.quantidade);
    final saidas = AppData.movimentacoes.where((m) => m.tipo == TipoMovimentacao.saida).fold(0, (s, m) => s + m.quantidade);

    return Scaffold(
      appBar: AppBar(title: const Text('Movimentações')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _novaMovimentacao,
        icon: const Icon(Icons.add),
        label: const Text('Registrar'),
      ),
      body: Column(
        children: [
          // Resumo
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(children: [
                      Icon(Icons.arrow_downward, color: Colors.green.shade700),
                      Text('$entradas un', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700, fontSize: 18)),
                      const Text('Entradas', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ]),
                  ),
                )),
                const SizedBox(width: 8),
                Expanded(child: Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(children: [
                      Icon(Icons.arrow_upward, color: Colors.red.shade700),
                      Text('$saidas un', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade700, fontSize: 18)),
                      const Text('Saídas', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ]),
                  ),
                )),
                const SizedBox(width: 8),
                Expanded(child: Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(children: [
                      Icon(Icons.swap_horiz, color: Colors.blue.shade700),
                      Text('${AppData.movimentacoes.length}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700, fontSize: 18)),
                      const Text('Total Mov.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ]),
                  ),
                )),
              ],
            ),
          ),

          // Filtro
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'todos', label: Text('Todos')),
                ButtonSegment(value: 'entrada', label: Text('Entradas')),
                ButtonSegment(value: 'saida', label: Text('Saídas')),
              ],
              selected: {_filtro},
              onSelectionChanged: (v) => setState(() => _filtro = v.first),
            ),
          ),
          const SizedBox(height: 8),

          // Lista
          Expanded(
            child: _lista.isEmpty
                ? const Center(child: Text('Nenhuma movimentação'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _lista.length,
                    itemBuilder: (_, i) {
                      final m = _lista[i];
                      final isEntrada = m.tipo == TipoMovimentacao.entrada;
                      final isAjuste = m.tipo == TipoMovimentacao.ajuste;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isAjuste ? Colors.orange.shade100 : isEntrada ? Colors.green.shade100 : Colors.red.shade100,
                            child: Icon(
                              isAjuste ? Icons.tune : isEntrada ? Icons.arrow_downward : Icons.arrow_upward,
                              color: isAjuste ? Colors.orange : isEntrada ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(m.produtoNome, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.motivo),
                              Text('${m.responsavel} • ${_fmt(m.data)}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                          trailing: Text(
                            '${isEntrada ? '+' : isAjuste ? '=' : '-'}${m.quantidade}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isAjuste ? Colors.orange : isEntrada ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

// ─────────────────────────────────────────────
// 👤 PERFIL
// ─────────────────────────────────────────────

class PerfilScreen extends StatefulWidget {
  final VoidCallback onLogout;
  const PerfilScreen({super.key, required this.onLogout});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool _notificacoes = true;
  bool _temaEscuro = false;

  void _editarPerfil() {
    final nome = TextEditingController(text: AppData.usuarioNome);
    final cargo = TextEditingController(text: AppData.usuarioCargo);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(16, 24, 16, MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Editar Perfil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: nome,
              decoration: InputDecoration(labelText: 'Nome', prefixIcon: const Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: cargo,
              decoration: InputDecoration(labelText: 'Cargo', prefixIcon: const Icon(Icons.work), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  AppData.usuarioNome = nome.text;
                  AppData.usuarioCargo = cargo.text;
                });
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: const Text('Salvar'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: const Color(0xFFD32F2F),
                      child: Text(AppData.usuarioNome[0], style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 16),
                    Text(AppData.usuarioNome, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(AppData.usuarioCargo, style: const TextStyle(color: Colors.grey)),
                    Text(AppData.usuarioEmail, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _editarPerfil,
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar Perfil'),
                      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Estatísticas do usuário
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Minhas Estatísticas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Divider(),
                    _statRow('Produtos cadastrados', '${AppData.produtos.length}'),
                    _statRow('Fornecedores', '${AppData.fornecedores.length}'),
                    _statRow('Movimentações', '${AppData.movimentacoes.length}'),
                    _statRow('Itens em estoque', '${AppData.totalItens}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Configurações
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _notificacoes,
                    onChanged: (v) => setState(() => _notificacoes = v),
                    title: const Text('Notificações de alerta'),
                    subtitle: const Text('Estoque mínimo atingido'),
                    secondary: const Icon(Icons.notifications),
                  ),
                  const Divider(height: 0),
                  SwitchListTile(
                    value: _temaEscuro,
                    onChanged: (v) => setState(() => _temaEscuro = v),
                    title: const Text('Tema escuro'),
                    subtitle: const Text('(funcionalidade em breve)'),
                    secondary: const Icon(Icons.dark_mode),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Sobre o app'),
                    subtitle: const Text('SenaiStock v1.0.0'),
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationName: 'SenaiStock',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2024 SENAI',
                      children: const [Text('Sistema de gestão de almoxarifado para o SENAI.')],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Sair'),
                    content: const Text('Deseja sair do sistema?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: widget.onLogout,
                        child: const Text('Sair'),
                      ),
                    ],
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Sair do Sistema'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statRow(String label, String valor) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
} 