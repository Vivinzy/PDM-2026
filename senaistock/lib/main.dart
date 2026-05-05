import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(const SenaiStockApp());
}

// ==================== MODELS ====================

class Usuario {
  String nome;
  String sobrenome;
  String email;
  String senha;
  String funcao;

  Usuario({
    required this.nome,
    required this.sobrenome,
    required this.email,
    required this.senha,
    this.funcao = 'Administrador',
  });
}

class Produto {
  String id;
  String nome;
  String codigo;
  String descricao;
  String categoria;
  String fornecedor;
  double preco;
  double precoVenda;
  int quantidade;
  int quantidadeMinima;
  String status;
  DateTime dataValidade;
  bool ativo;

  Produto({
    required this.id,
    required this.nome,
    required this.codigo,
    this.descricao = '',
    required this.categoria,
    required this.fornecedor,
    required this.preco,
    required this.precoVenda,
    required this.quantidade,
    this.quantidadeMinima = 5,
    this.status = 'Ativo',
    required this.dataValidade,
    this.ativo = true,
  });
}

class Fornecedor {
  String id;
  String nome;
  String contato;
  String email;
  String telefone;
  String cnpj;
  String endereco;
  String status;
  int produtos;
  int titulos;
  DateTime? proximoPagamento;

  Fornecedor({
    required this.id,
    required this.nome,
    required this.contato,
    required this.email,
    required this.telefone,
    this.cnpj = '',
    this.endereco = '',
    this.status = 'Ativo',
    this.produtos = 0,
    this.titulos = 0,
    this.proximoPagamento,
  });
}

class Movimentacao {
  String id;
  DateTime data;
  String tipo; // Entrada, Saída, Ajuste
  String produto;
  String codigoProduto;
  int quantidade;
  int estoqueFinal;
  String responsavel;
  String categoria;
  String observacoes;

  Movimentacao({
    required this.id,
    required this.data,
    required this.tipo,
    required this.produto,
    required this.codigoProduto,
    required this.quantidade,
    required this.estoqueFinal,
    required this.responsavel,
    this.categoria = '',
    this.observacoes = '',
  });
}

// ==================== APP STATE ====================

class AppState {
  static Usuario? usuarioLogado;
  static List<Usuario> usuarios = [];
  static List<Produto> produtos = _produtosIniciais();
  static List<Fornecedor> fornecedores = _fornecedoresIniciais();
  static List<Movimentacao> movimentacoes = _movimentacoesIniciais();

  static List<Produto> _produtosIniciais() {
    return [
      Produto(id: '1', nome: 'Manutenção Elétrica Industrial', codigo: 'P001-12', categoria: 'Industrial', fornecedor: 'Editora Senai', preco: 45.00, precoVenda: 65.00, quantidade: 32, quantidadeMinima: 5, dataValidade: DateTime(2026, 1, 1), status: 'Ativo'),
      Produto(id: '2', nome: 'Fundamentos de Usinagem de Metais', codigo: 'G521', categoria: 'Metalmecânica', fornecedor: 'Editora LP', preco: 38.00, precoVenda: 55.00, quantidade: 8, quantidadeMinima: 5, dataValidade: DateTime(2025, 6, 1), status: 'Crítico'),
      Produto(id: '3', nome: 'Logística e Gestão de Suprimentos', codigo: 'G521', categoria: 'Administração', fornecedor: 'Editora PN', preco: 42.00, precoVenda: 60.00, quantidade: 12, quantidadeMinima: 5, dataValidade: DateTime(2025, 12, 1), status: 'Atenção'),
      Produto(id: '4', nome: 'Tecnologia: Saúde, Força e Versão', codigo: 'G9-LS', categoria: 'Saúde', fornecedor: 'Editora Senai', preco: 35.00, precoVenda: 50.00, quantidade: 25, quantidadeMinima: 5, dataValidade: DateTime(2026, 3, 1), status: 'Ativo'),
      Produto(id: '5', nome: 'Matemática Avançada', codigo: 'MAT-01', categoria: 'Matemática', fornecedor: 'Editora Senai', preco: 50.00, precoVenda: 75.00, quantidade: 60, quantidadeMinima: 10, dataValidade: DateTime(2027, 1, 1), status: 'Ativo'),
      Produto(id: '6', nome: 'Física Quântica Aplicada', codigo: 'FIS-02', categoria: 'Física', fornecedor: 'Editora LP', preco: 55.00, precoVenda: 80.00, quantidade: 3, quantidadeMinima: 5, dataValidade: DateTime(2025, 4, 1), status: 'Crítico'),
    ];
  }

  static List<Fornecedor> _fornecedoresIniciais() {
    return [
      Fornecedor(id: '1', nome: 'TechGear Inc.', contato: 'João Paulo Pessoa', email: 'joaopaulp@techgear.com', telefone: '+55 (35) 99494-6090', cnpj: '12.345.678/0001-90', endereco: 'Rua das Flores, 123 - São Paulo, SP', status: 'Ativo', produtos: 43, titulos: 2),
      Fornecedor(id: '2', nome: 'ELPNext Inc.', contato: 'João Paulo Pessoa', email: 'joaopaulp@elpnext.com', telefone: '+55 (35) 99494-6090', cnpj: '98.765.432/0001-10', endereco: 'Av. Industrial, 456 - Campinas, SP', status: 'Inativo', produtos: 12, titulos: 0),
      Fornecedor(id: '3', nome: 'TechGear Inc.', contato: 'João Paulo Pessoa', email: 'joaopaulp@techgear.com', telefone: '+55 (35) 99494-6090', cnpj: '11.222.333/0001-44', endereco: 'Rua Tech, 789 - BH, MG', status: 'Ativo', produtos: 67, titulos: 5),
      Fornecedor(id: '4', nome: 'SoftBuild Inc.', contato: 'João Paulo Pessoa', email: 'joaopaulp@softbuild.com', telefone: '+55 (35) 99494-6090', cnpj: '55.666.777/0001-88', endereco: 'Rua Soft, 321 - Rio, RJ', status: 'Aguardando', produtos: 8, titulos: 1),
    ];
  }

  static List<Movimentacao> _movimentacoesIniciais() {
    return [
      Movimentacao(id: '1', data: DateTime(2025, 4, 3, 21, 37), tipo: 'Entrada', produto: 'Notebook Dell Inspiron 15', codigoProduto: 'P003-03128', quantidade: 10, estoqueFinal: 547, responsavel: 'Juliana Albuquerque', categoria: 'Compras'),
      Movimentacao(id: '2', data: DateTime(2025, 4, 3, 16, 51), tipo: 'Saída', produto: 'Notebook Dell Inspiron 15', codigoProduto: 'P003-03128', quantidade: 5, estoqueFinal: 537, responsavel: 'Juliana Albuquerque', categoria: 'Vendas'),
      Movimentacao(id: '3', data: DateTime(2025, 4, 2, 10, 22), tipo: 'Ajuste', produto: 'Notebook Dell Inspiron 15', codigoProduto: 'P003-03128', quantidade: 3, estoqueFinal: 540, responsavel: 'SAY', categoria: 'Ajuste'),
    ];
  }
}

// ==================== THEME ====================

class AppTheme {
  static const Color primary = Color(0xFFCC0000);
  static const Color primaryDark = Color(0xFF990000);
  static const Color accent = Color(0xFFE53935);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color sidebar = Color(0xFF1A1A2E);
  static const Color sidebarText = Color(0xFFB0B0C0);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static ThemeData get theme => ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: accent,
      surface: surface,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: primary, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: Colors.white,
    ),
  );
}

// ==================== MAIN APP ====================

class SenaiStockApp extends StatelessWidget {
  const SenaiStockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SENAISTOCK',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (ctx) => const LoginScreen(),
        '/cadastro': (ctx) => const CadastroScreen(),
        '/home': (ctx) => const MainShell(initialIndex: 0),
      },
    );
  }
}

// ==================== LOGIN SCREEN ====================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  bool _obscure = true;
  bool _lembrar = false;
  bool _loading = false;

  void _login() async {
    if (_emailCtrl.text.isEmpty || _senhaCtrl.text.isEmpty) {
      _showError('Preencha e-mail e senha.');
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    // Check registered users or default admin
    Usuario? user;
    for (var u in AppState.usuarios) {
      if (u.email == _emailCtrl.text && u.senha == _senhaCtrl.text) {
        user = u;
        break;
      }
    }
    if (user == null && _emailCtrl.text == 'admin@senai.br' && _senhaCtrl.text == '123456') {
      user = Usuario(nome: 'Bruno Augusto', sobrenome: 'de Moraes', email: 'admin@senai.br', senha: '123456', funcao: 'ADM/Líder');
    }

    setState(() => _loading = false);
    if (user != null) {
      AppState.usuarioLogado = user;
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showError('E-mail ou senha inválidos.');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppTheme.danger));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      body: Center(
        child: Container(
          width: 800,
          height: 420,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 10))],
          ),
          child: Row(
            children: [
              // Left image panel
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=400&fit=crop'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Right form
              SizedBox(
                width: 320,
                child: Padding(
                  padding: const EdgeInsets.all(36),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.settings, color: AppTheme.primary, size: 28),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('SENAISTOCK', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary, letterSpacing: 1)),
                              Text('GESTÃO DE ESTOQUES', style: TextStyle(fontSize: 8, color: AppTheme.textSecondary, letterSpacing: 2)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      TextField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(hintText: 'E-mail'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _senhaCtrl,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: 'Senha',
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, size: 18),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        onSubmitted: (_) => _login(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(value: _lembrar, onChanged: (v) => setState(() => _lembrar = v!), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          const Text('Lembrar-me', style: TextStyle(fontSize: 12)),
                          const Spacer(),
                          TextButton(onPressed: () {}, child: const Text('Esqueceu a senha?', style: TextStyle(fontSize: 12, color: AppTheme.primary))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _login,
                          child: _loading ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Entrar'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Não tem uma conta?', style: TextStyle(fontSize: 12)),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/cadastro'),
                            child: const Text('Cadastre-se', style: TextStyle(fontSize: 12, color: AppTheme.primary)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== CADASTRO SCREEN ====================

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeCtrl = TextEditingController();
  final _sobrenomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure1 = true, _obscure2 = true;
  bool _termos = false;

  void _cadastrar() {
    if (_nomeCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _senhaCtrl.text.isEmpty) {
      _showMsg('Preencha todos os campos obrigatórios.', error: true);
      return;
    }
    if (_senhaCtrl.text != _confirmCtrl.text) {
      _showMsg('As senhas não coincidem.', error: true);
      return;
    }
    if (!_termos) {
      _showMsg('Aceite os Termos de Serviço.', error: true);
      return;
    }
    AppState.usuarios.add(Usuario(
      nome: _nomeCtrl.text,
      sobrenome: _sobrenomeCtrl.text,
      email: _emailCtrl.text,
      senha: _senhaCtrl.text,
    ));
    _showMsg('Conta criada com sucesso!');
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    });
  }

  void _showMsg(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: error ? AppTheme.danger : AppTheme.success));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: Container(
          width: 820,
          height: 460,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30)],
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=400&fit=crop'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 360,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: Text('Cadastro', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary))),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: TextField(controller: _nomeCtrl, decoration: const InputDecoration(hintText: 'Nome'))),
                          const SizedBox(width: 8),
                          Expanded(child: TextField(controller: _sobrenomeCtrl, decoration: const InputDecoration(hintText: 'Sobrenome'))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(controller: _emailCtrl, decoration: const InputDecoration(hintText: 'E-mail'), keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _senhaCtrl,
                        obscureText: _obscure1,
                        decoration: InputDecoration(
                          hintText: 'Senha',
                          suffixIcon: IconButton(icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility, size: 18), onPressed: () => setState(() => _obscure1 = !_obscure1)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _confirmCtrl,
                        obscureText: _obscure2,
                        decoration: InputDecoration(
                          hintText: 'Confirmação',
                          suffixIcon: IconButton(icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility, size: 18), onPressed: () => setState(() => _obscure2 = !_obscure2)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(value: _termos, onChanged: (v) => setState(() => _termos = v!)),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                children: [
                                  const TextSpan(text: 'Concordo com os '),
                                  TextSpan(text: 'Termos de Serviço', style: const TextStyle(color: AppTheme.primary, decoration: TextDecoration.underline)),
                                  const TextSpan(text: ' e a '),
                                  TextSpan(text: 'Política de Privacidade', style: const TextStyle(color: AppTheme.primary, decoration: TextDecoration.underline)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _cadastrar, child: const Text('Criar Conta'))),
                      const SizedBox(height: 8),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Já tem uma conta?', style: TextStyle(fontSize: 12)),
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entrar', style: TextStyle(fontSize: 12, color: AppTheme.primary))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== MAIN SHELL (Sidebar + Navigation) ====================

class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<_NavItem> _navItems = [
    _NavItem('Dashboard', Icons.dashboard_outlined, Icons.dashboard),
    _NavItem('Produtos', Icons.inventory_2_outlined, Icons.inventory_2),
    _NavItem('Estoque', Icons.warehouse_outlined, Icons.warehouse),
    _NavItem('Fornecedores', Icons.business_outlined, Icons.business),
    _NavItem('Movimentações', Icons.swap_horiz, Icons.swap_horiz),
    _NavItem('Sistema', Icons.settings_outlined, Icons.settings),
    _NavItem('Usuários', Icons.people_outline, Icons.people),
  ];

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0: return const DashboardScreen();
      case 1: return const ProdutosScreen();
      case 2: return const EstoqueScreen();
      case 3: return const FornecedoresScreen();
      case 4: return const MovimentacoesScreen();
      case 5: return const ConfiguracoesScreen();
      case 6: return const UsuariosScreen();
      default: return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AppState.usuarioLogado;
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 220,
            color: AppTheme.sidebar,
            child: Column(
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.settings, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('SENAISTOCK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
                          Text('GESTÃO DE ESTOQUES', style: TextStyle(color: Color(0xFF6B7280), fontSize: 7, letterSpacing: 1.5)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF2D2D4A), height: 1),
                // Section label
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Align(alignment: Alignment.centerLeft, child: Text('MENU PRINCIPAL', style: TextStyle(color: Color(0xFF4B5563), fontSize: 10, letterSpacing: 1.5))),
                ),
                // Main nav items 0-4
                ...List.generate(5, (i) => _buildNavItem(i)),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Align(alignment: Alignment.centerLeft, child: Text('CONFIGURAÇÕES', style: TextStyle(color: Color(0xFF4B5563), fontSize: 10, letterSpacing: 1.5))),
                ),
                // Config items 5-6
                ...List.generate(2, (i) => _buildNavItem(i + 5)),
                const Spacer(),
                // User avatar at bottom
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFF2D2D4A)))),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppTheme.primary,
                        child: Text(user != null ? user.nome[0].toUpperCase() : 'A', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user != null ? '${user.nome} ${user.sobrenome}' : 'Admin', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                            Text(user?.funcao ?? 'Administrador', style: const TextStyle(color: AppTheme.sidebarText, fontSize: 10)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: AppTheme.sidebarText, size: 18),
                        onPressed: () {
                          AppState.usuarioLogado = null;
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Top bar
                Container(
                  height: 56,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text(_navItems[_selectedIndex].label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                      const Spacer(),
                      Container(
                        width: 220,
                        height: 36,
                        decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE5E7EB))),
                        child: const Row(
                          children: [
                            SizedBox(width: 12),
                            Icon(Icons.search, size: 16, color: AppTheme.textSecondary),
                            SizedBox(width: 8),
                            Text('Pesquisar...', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Stack(
                        children: [
                          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
                          Positioned(top: 8, right: 8, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle))),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Screen content
                Expanded(
                  child: _buildScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final selected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: selected ? Border.all(color: AppTheme.primary.withOpacity(0.3)) : null,
        ),
        child: Row(
          children: [
            Icon(selected ? item.activeIcon : item.icon, color: selected ? AppTheme.primary : AppTheme.sidebarText, size: 18),
            const SizedBox(width: 10),
            Text(item.label, style: TextStyle(color: selected ? Colors.white : AppTheme.sidebarText, fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
            if (selected) ...[const Spacer(), Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle))],
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  _NavItem(this.label, this.icon, this.activeIcon);
}

// ==================== DASHBOARD SCREEN ====================

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final produtos = AppState.produtos;
    final total = produtos.fold(0, (sum, p) => sum + p.quantidade);
    final criticos = produtos.where((p) => p.status == 'Crítico').length;
    final atencao = produtos.where((p) => p.status == 'Atenção').length;
    final valorTotal = produtos.fold(0.0, (sum, p) => sum + (p.preco * p.quantidade));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          Row(
            children: [
              _SummaryCard(label: 'Total em Estoque', value: '$total', icon: Icons.inventory, color: AppTheme.info, subtitle: 'itens cadastrados'),
              const SizedBox(width: 16),
              _SummaryCard(label: 'Crítico', value: '$criticos', icon: Icons.arrow_downward, color: AppTheme.danger, subtitle: 'abaixo do mínimo'),
              const SizedBox(width: 16),
              _SummaryCard(label: 'Atenção', value: '$atencao itens', icon: Icons.warning_amber, color: AppTheme.warning, subtitle: 'próximos do mínimo'),
              const SizedBox(width: 16),
              _SummaryCard(label: 'Valor Total', value: 'R\$ ${valorTotal.toStringAsFixed(2).replaceAll('.', ',')}', icon: Icons.attach_money, color: AppTheme.success, subtitle: 'em estoque'),
            ],
          ),
          const SizedBox(height: 24),
          // Status table
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Text('Status do Estoque', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('+ Novo Produto'),
                        style: OutlinedButton.styleFrom(foregroundColor: AppTheme.primary, side: const BorderSide(color: AppTheme.primary)),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(1.5),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2.5),
                    4: FlexColumnWidth(1.5),
                  },
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFFF9FAFB)),
                      children: ['PRODUTO', 'CÓDIGO', 'NOME', 'ESTOQUE FINAL', 'STATUS'].map((h) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, letterSpacing: 0.5)),
                      )).toList(),
                    ),
                    ...AppState.produtos.take(5).map((p) => TableRow(
                      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF3F4F6)))),
                      children: [
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: Row(children: [
                          Container(width: 32, height: 32, decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.menu_book, size: 16, color: AppTheme.primary)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(p.nome, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
                        ])),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: Text(p.codigo, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary))),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: Text(p.categoria, style: const TextStyle(fontSize: 12))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('${p.quantidade} unidades', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: (p.quantidade / 60).clamp(0.0, 1.0),
                                backgroundColor: const Color(0xFFE5E7EB),
                                color: p.status == 'Crítico' ? AppTheme.danger : p.status == 'Atenção' ? AppTheme.warning : AppTheme.success,
                                minHeight: 6,
                              ),
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: _StatusBadge(status: p.status),
                        ),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label, value, subtitle;
  final IconData icon;
  final Color color;

  const _SummaryCard({required this.label, required this.value, required this.icon, required this.color, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                  Text(subtitle, style: TextStyle(fontSize: 10, color: color)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== PRODUTOS SCREEN ====================

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({super.key});

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  String _busca = '';
  String _categoriaFiltro = 'Todos';

  List<Produto> get _filtrados => AppState.produtos.where((p) {
    final matchBusca = _busca.isEmpty || p.nome.toLowerCase().contains(_busca.toLowerCase()) || p.codigo.toLowerCase().contains(_busca.toLowerCase());
    final matchCat = _categoriaFiltro == 'Todos' || p.categoria == _categoriaFiltro;
    return matchBusca && matchCat;
  }).toList();

  void _abrirFormulario([Produto? produto]) async {
    final result = await showDialog<bool>(context: context, builder: (_) => ProdutoFormDialog(produto: produto));
    if (result == true) setState(() {});
  }

  void _importar() {
    showDialog(context: context, builder: (_) => const ImportarDialog(titulo: 'Produtos'));
  }

  void _excluir(Produto p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Excluir "${p.nome}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              setState(() => AppState.produtos.remove(p));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto excluído.'), backgroundColor: AppTheme.success));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = AppState.produtos.length;
    final ativos = AppState.produtos.where((p) => p.status == 'Ativo').length;
    final criticos = AppState.produtos.where((p) => p.status == 'Crítico').length;
    final semEstoque = AppState.produtos.where((p) => p.quantidade == 0).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          Row(
            children: [
              _StatCard(value: '$total', label: 'Total de Produtos', color: AppTheme.info),
              const SizedBox(width: 12),
              _StatCard(value: '$ativos', label: 'Ativos', color: AppTheme.success),
              const SizedBox(width: 12),
              _StatCard(value: '$criticos', label: 'Crítico', color: AppTheme.danger),
              const SizedBox(width: 12),
              _StatCard(value: '$semEstoque', label: 'Sem Estoque', color: AppTheme.warning),
            ],
          ),
          const SizedBox(height: 20),
          // Actions bar
          Row(
            children: [
              Expanded(child: TextField(
                onChanged: (v) => setState(() => _busca = v),
                decoration: const InputDecoration(hintText: 'Buscar Produto...', prefixIcon: Icon(Icons.search, size: 18), contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14)),
              )),
              const SizedBox(width: 8),
              OutlinedButton.icon(onPressed: _importar, icon: const Icon(Icons.upload, size: 16), label: const Text('Importar')),
              const SizedBox(width: 8),
              OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.download, size: 16), label: const Text('Exportar')),
              const SizedBox(width: 8),
              ElevatedButton.icon(onPressed: () => _abrirFormulario(), icon: const Icon(Icons.add, size: 16), label: const Text('Adicionar Produto')),
            ],
          ),
          const SizedBox(height: 16),
          // Table
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: Column(
              children: [
                // Table header
                Container(
                  decoration: const BoxDecoration(color: Color(0xFFF9FAFB), borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                  child: const Row(
                    children: [
                      _TableHeader('PRODUTO', flex: 4),
                      _TableHeader('CÓDIGO', flex: 2),
                      _TableHeader('CATEGORIA', flex: 2),
                      _TableHeader('FORNECEDOR', flex: 3),
                      _TableHeader('PREÇO', flex: 2),
                      _TableHeader('QTD', flex: 1),
                      _TableHeader('STATUS', flex: 2),
                      _TableHeader('AÇÕES', flex: 2),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ..._filtrados.map((p) => _ProdutoRow(produto: p, onEdit: () => _abrirFormulario(p), onDelete: () => _excluir(p))),
                if (_filtrados.isEmpty)
                  const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('Nenhum produto encontrado.', style: TextStyle(color: AppTheme.textSecondary)))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatCard({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      ]),
    ),
  );
}

class _TableHeader extends StatelessWidget {
  final String text;
  final int flex;
  const _TableHeader(this.text, {required this.flex});

  @override
  Widget build(BuildContext context) => Expanded(
    flex: flex,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, letterSpacing: 0.5)),
    ),
  );
}

class _ProdutoRow extends StatelessWidget {
  final Produto produto;
  final VoidCallback onEdit, onDelete;
  const _ProdutoRow({required this.produto, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF3F4F6)))),
      child: Row(
        children: [
          Expanded(flex: 4, child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(children: [
              Container(width: 32, height: 32, decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.menu_book, size: 16, color: AppTheme.primary)),
              const SizedBox(width: 8),
              Expanded(child: Text(produto.nome, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
            ]),
          )),
          Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(produto.codigo, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)))),
          Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(produto.categoria, style: const TextStyle(fontSize: 12)))),
          Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(produto.fornecedor, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis))),
          Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('R\$ ${produto.preco.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)))),
          Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('${produto.quantidade}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)))),
          Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: _StatusBadge(status: produto.status))),
          Expanded(flex: 2, child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(children: [
              IconButton(onPressed: onEdit, icon: const Icon(Icons.edit, size: 16, color: AppTheme.info), tooltip: 'Editar', constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
              const SizedBox(width: 4),
              IconButton(onPressed: onDelete, icon: const Icon(Icons.delete, size: 16, color: AppTheme.danger), tooltip: 'Excluir', constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
            ]),
          )),
        ],
      ),
    );
  }
}

// ==================== PRODUTO FORM DIALOG ====================

class ProdutoFormDialog extends StatefulWidget {
  final Produto? produto;
  const ProdutoFormDialog({super.key, this.produto});

  @override
  State<ProdutoFormDialog> createState() => _ProdutoFormDialogState();
}

class _ProdutoFormDialogState extends State<ProdutoFormDialog> {
  late TextEditingController _nomeCtrl, _codigoCtrl, _descCtrl, _precoCtrl, _precoVendaCtrl, _qtdCtrl, _qtdMinCtrl;
  String _categoria = 'Industrial';
  String _fornecedor = 'Editora Senai';
  bool _ativo = true;

  final List<String> _categorias = ['Industrial', 'Metalmecânica', 'Administração', 'Saúde', 'Matemática', 'Física', 'Informática', 'Outros'];
  final List<String> _fornecedores = ['Editora Senai', 'Editora LP', 'Editora PN', 'TechGear Inc.'];

  @override
  void initState() {
    super.initState();
    final p = widget.produto;
    _nomeCtrl = TextEditingController(text: p?.nome ?? '');
    _codigoCtrl = TextEditingController(text: p?.codigo ?? '');
    _descCtrl = TextEditingController(text: p?.descricao ?? '');
    _precoCtrl = TextEditingController(text: p != null ? p.preco.toStringAsFixed(2) : '');
    _precoVendaCtrl = TextEditingController(text: p != null ? p.precoVenda.toStringAsFixed(2) : '');
    _qtdCtrl = TextEditingController(text: p != null ? '${p.quantidade}' : '');
    _qtdMinCtrl = TextEditingController(text: p != null ? '${p.quantidadeMinima}' : '5');
    if (p != null) {
      _categoria = p.categoria;
      _fornecedor = p.fornecedor;
      _ativo = p.ativo;
    }
  }

  void _salvar() {
    if (_nomeCtrl.text.isEmpty || _codigoCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nome e código são obrigatórios.'), backgroundColor: AppTheme.danger));
      return;
    }
    final qtd = int.tryParse(_qtdCtrl.text) ?? 0;
    final qtdMin = int.tryParse(_qtdMinCtrl.text) ?? 5;
    final preco = double.tryParse(_precoCtrl.text.replaceAll(',', '.')) ?? 0.0;
    final precoV = double.tryParse(_precoVendaCtrl.text.replaceAll(',', '.')) ?? 0.0;

    String status = 'Ativo';
    if (qtd == 0) status = 'Sem Estoque';
    else if (qtd <= qtdMin) status = 'Crítico';
    else if (qtd <= qtdMin * 2) status = 'Atenção';

    if (widget.produto != null) {
      widget.produto!
        ..nome = _nomeCtrl.text
        ..codigo = _codigoCtrl.text
        ..descricao = _descCtrl.text
        ..categoria = _categoria
        ..fornecedor = _fornecedor
        ..preco = preco
        ..precoVenda = precoV
        ..quantidade = qtd
        ..quantidadeMinima = qtdMin
        ..status = status
        ..ativo = _ativo;
    } else {
      AppState.produtos.add(Produto(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nome: _nomeCtrl.text,
        codigo: _codigoCtrl.text,
        descricao: _descCtrl.text,
        categoria: _categoria,
        fornecedor: _fornecedor,
        preco: preco,
        precoVenda: precoV,
        quantidade: qtd,
        quantidadeMinima: qtdMin,
        status: status,
        dataValidade: DateTime.now().add(const Duration(days: 365)),
        ativo: _ativo,
      ));
    }
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.produto != null ? 'Produto atualizado!' : 'Produto adicionado!'), backgroundColor: AppTheme.success));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.produto != null;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(isEdit ? 'Editar Produto' : 'Adicionar Novo Produto', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _Field('Nome do Produto *', _nomeCtrl)),
                  const SizedBox(width: 12),
                  Expanded(child: _DropField('Categoria *', _categorias, _categoria, (v) => setState(() => _categoria = v!))),
                  const SizedBox(width: 12),
                  Expanded(child: _DropField('Fornecedor', _fornecedores, _fornecedor, (v) => setState(() => _fornecedor = v!))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _Field('Código do Produto *', _codigoCtrl)),
                  const SizedBox(width: 12),
                  Expanded(child: _Field('Preço de Custo', _precoCtrl, prefix: 'R\$')),
                  const SizedBox(width: 12),
                  Expanded(child: _Field('Preço de Venda', _precoVendaCtrl, prefix: 'R\$')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _Field('Quantidade', _qtdCtrl, keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: _Field('Quantidade Mínima', _qtdMinCtrl, keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(children: [
                      Switch(value: _ativo, onChanged: (v) => setState(() => _ativo = v), activeColor: AppTheme.primary),
                      Text(_ativo ? 'Ativo' : 'Inativo', style: const TextStyle(fontSize: 13)),
                    ]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _Field('Descrição', _descCtrl, maxLines: 2),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(onPressed: _salvar, icon: const Icon(Icons.save, size: 16), label: Text(isEdit ? 'Salvar' : 'Salvar produto')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _Field(String label, TextEditingController ctrl, {int maxLines = 1, TextInputType keyboardType = TextInputType.text, String? prefix}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
      const SizedBox(height: 4),
      TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(prefixText: prefix != null ? '$prefix ' : null),
      ),
    ],
  );
}

Widget _DropField(String label, List<String> items, String value, ValueChanged<String?> onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
      const SizedBox(height: 4),
      DropdownButtonFormField<String>(
        value: value,
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13)))).toList(),
        onChanged: onChanged,
        decoration: const InputDecoration(),
      ),
    ],
  );
}

// ==================== ESTOQUE SCREEN ====================

class EstoqueScreen extends StatefulWidget {
  const EstoqueScreen({super.key});

  @override
  State<EstoqueScreen> createState() => _EstoqueScreenState();
}

class _EstoqueScreenState extends State<EstoqueScreen> {
  String _busca = '';
  Produto? _produtoSelecionado;

  @override
  Widget build(BuildContext context) {
    final produtos = AppState.produtos.where((p) => _busca.isEmpty || p.nome.toLowerCase().contains(_busca.toLowerCase())).toList();
    final totalAcervo = AppState.produtos.length;
    final totalDisp = AppState.produtos.fold(0, (s, p) => s + p.quantidade);
    final semEstoque = AppState.produtos.where((p) => p.quantidade == 0).length;
    final criticos = AppState.produtos.where((p) => p.status == 'Crítico').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _StatCard(value: '$totalAcervo no Acervo', label: '', color: AppTheme.info),
            const SizedBox(width: 12),
            _StatCard(value: '$totalDisp Disponíveis', label: '', color: AppTheme.success),
            const SizedBox(width: 12),
            _StatCard(value: '$criticos Títulos', label: 'críticos', color: AppTheme.warning),
            const SizedBox(width: 12),
            _StatCard(value: '$semEstoque sem estoque', label: '', color: AppTheme.danger),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: TextField(onChanged: (v) => setState(() => _busca = v), decoration: const InputDecoration(hintText: 'Buscar Todos os Acervos', prefixIcon: Icon(Icons.search, size: 18)))),
            const SizedBox(width: 8),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.filter_list, size: 16), label: const Text('Filtrar')),
            const SizedBox(width: 8),
            ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 16), label: const Text('+ Edt')),
          ]),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: Column(children: [
              Container(
                decoration: const BoxDecoration(color: Color(0xFFF9FAFB), borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                child: const Row(children: [
                  _TableHeader('TÍTULO', flex: 4),
                  _TableHeader('CATEGORIA', flex: 2),
                  _TableHeader('QTD TOTAL', flex: 2),
                  _TableHeader('DISPONÍVEIS', flex: 2),
                  _TableHeader('VENCIMENTO', flex: 2),
                  _TableHeader('STATUS', flex: 2),
                  _TableHeader('AÇÕES', flex: 2),
                ]),
              ),
              const Divider(height: 1),
              ...produtos.map((p) => _EstoqueRow(produto: p, onTap: () => setState(() => _produtoSelecionado = _produtoSelecionado == p ? null : p))),
              if (_produtoSelecionado != null) _AjustePanel(produto: _produtoSelecionado!, onSave: () => setState(() {})),
              if (produtos.isEmpty) const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('Nenhum item encontrado.', style: TextStyle(color: AppTheme.textSecondary)))),
            ]),
          ),
        ],
      ),
    );
  }
}

class _EstoqueRow extends StatelessWidget {
  final Produto produto;
  final VoidCallback onTap;
  const _EstoqueRow({required this.produto, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF3F4F6)))),
      child: Row(children: [
        Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), child: Row(children: [
          Container(width: 32, height: 32, decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.menu_book, size: 16, color: AppTheme.primary)),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(produto.nome, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
            Text(produto.codigo, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ])),
        ]))),
        Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(produto.categoria, style: const TextStyle(fontSize: 12)))),
        Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('${produto.quantidade}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)))),
        Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('${produto.quantidade}', style: const TextStyle(fontSize: 12, color: AppTheme.success)))),
        Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('${produto.dataValidade.day.toString().padLeft(2,'0')}/${produto.dataValidade.month.toString().padLeft(2,'0')}/${produto.dataValidade.year}', style: const TextStyle(fontSize: 12)))),
        Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: _StatusBadge(status: produto.status))),
        Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Row(children: [
          IconButton(onPressed: onTap, icon: const Icon(Icons.edit, size: 16, color: AppTheme.info), constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
        ]))),
      ]),
    ),
  );
}

class _AjustePanel extends StatefulWidget {
  final Produto produto;
  final VoidCallback onSave;
  const _AjustePanel({required this.produto, required this.onSave});

  @override
  State<_AjustePanel> createState() => _AjustePanelState();
}

class _AjustePanelState extends State<_AjustePanel> {
  late TextEditingController _qtdCtrl;

  @override
  void initState() {
    super.initState();
    _qtdCtrl = TextEditingController(text: '${widget.produto.quantidade}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Row(children: [
        const Text('Ajustar quantidade:', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(width: 12),
        SizedBox(width: 80, child: TextField(controller: _qtdCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)))),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            final qtd = int.tryParse(_qtdCtrl.text) ?? widget.produto.quantidade;
            widget.produto.quantidade = qtd;
            String status = 'Ativo';
            if (qtd == 0) status = 'Sem Estoque';
            else if (qtd <= widget.produto.quantidadeMinima) status = 'Crítico';
            else if (qtd <= widget.produto.quantidadeMinima * 2) status = 'Atenção';
            widget.produto.status = status;
            widget.onSave();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Estoque atualizado!'), backgroundColor: AppTheme.success));
          },
          child: const Text('Salvar'),
        ),
      ]),
    );
  }
}

// ==================== FORNECEDORES SCREEN ====================

class FornecedoresScreen extends StatefulWidget {
  const FornecedoresScreen({super.key});

  @override
  State<FornecedoresScreen> createState() => _FornecedoresScreenState();
}

class _FornecedoresScreenState extends State<FornecedoresScreen> {
  Fornecedor? _selecionado;
  String _busca = '';

  List<Fornecedor> get _filtrados => AppState.fornecedores.where((f) =>
    _busca.isEmpty || f.nome.toLowerCase().contains(_busca.toLowerCase()) || f.contato.toLowerCase().contains(_busca.toLowerCase())
  ).toList();

  void _abrirFormulario([Fornecedor? f]) async {
    final result = await showDialog<bool>(context: context, builder: (_) => FornecedorFormDialog(fornecedor: f));
    if (result == true) setState(() {});
  }

  void _excluir(Fornecedor f) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Excluir "${f.nome}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              setState(() { AppState.fornecedores.remove(f); _selecionado = null; });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = AppState.fornecedores.length;
    final ativos = AppState.fornecedores.where((f) => f.status == 'Ativo').length;
    final inativos = AppState.fornecedores.where((f) => f.status == 'Inativo').length;
    final aguardando = AppState.fornecedores.where((f) => f.status == 'Aguardando').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(children: [
            _StatCard(value: '$total', label: 'Total de Fornecedores', color: AppTheme.info),
            const SizedBox(width: 12),
            _StatCard(value: '$ativos', label: 'Ativos', color: AppTheme.success),
            const SizedBox(width: 12),
            _StatCard(value: '$inativos', label: 'Inativos', color: AppTheme.danger),
            const SizedBox(width: 12),
            _StatCard(value: '$aguardando', label: 'Aguardando', color: AppTheme.warning),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: TextField(onChanged: (v) => setState(() => _busca = v), decoration: const InputDecoration(hintText: 'Buscar Fornecedores...', prefixIcon: Icon(Icons.search, size: 18)))),
            const SizedBox(width: 8),
            OutlinedButton.icon(onPressed: () => showDialog(context: context, builder: (_) => const ImportarDialog(titulo: 'Fornecedores')), icon: const Icon(Icons.upload, size: 16), label: const Text('Importar')),
            const SizedBox(width: 8),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.download, size: 16), label: const Text('Exportar')),
            const SizedBox(width: 8),
            ElevatedButton.icon(onPressed: () => _abrirFormulario(), icon: const Icon(Icons.add, size: 16), label: const Text('Adicionar Fornecedor')),
          ]),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: Column(children: [
              Container(
                decoration: const BoxDecoration(color: Color(0xFFF9FAFB), borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                child: const Row(children: [
                  _TableHeader('EMPRESA', flex: 3),
                  _TableHeader('CONTATO', flex: 3),
                  _TableHeader('E-MAIL', flex: 3),
                  _TableHeader('TELEFONE', flex: 2),
                  _TableHeader('PRODUTOS', flex: 1),
                  _TableHeader('TÍTULOS', flex: 1),
                  _TableHeader('STATUS', flex: 2),
                  _TableHeader('AÇÕES', flex: 2),
                ]),
              ),
              const Divider(height: 1),
              ..._filtrados.map((f) => _FornecedorRow(
                fornecedor: f,
                selecionado: _selecionado == f,
                onTap: () => setState(() => _selecionado = _selecionado == f ? null : f),
                onEdit: () => _abrirFormulario(f),
                onDelete: () => _excluir(f),
              )),
              if (_selecionado != null) _FornecedorDetalhe(fornecedor: _selecionado!, onSave: () => setState(() {})),
            ]),
          ),
        ],
      ),
    );
  }
}

class _FornecedorRow extends StatelessWidget {
  final Fornecedor fornecedor;
  final bool selecionado;
  final VoidCallback onTap, onEdit, onDelete;
  const _FornecedorRow({required this.fornecedor, required this.selecionado, required this.onTap, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(color: Color(0xFFF3F4F6))),
        color: selecionado ? AppTheme.primary.withOpacity(0.04) : null,
      ),
      child: Row(children: [
        Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), child: Row(children: [
          CircleAvatar(radius: 16, backgroundColor: AppTheme.primary, child: Text(fornecedor.nome.substring(0, 2).toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(fornecedor.nome, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
            Text(fornecedor.cnpj.isNotEmpty ? fornecedor.cnpj : 'CNPJ não informado', style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
          ])),
        ]))),
        Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(fornecedor.contato, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis))),
        Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(fornecedor.email, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis))),
        Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(fornecedor.telefone, style: const TextStyle(fontSize: 11)))),
        Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('${fornecedor.produtos}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)))),
        Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('${fornecedor.titulos}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)))),
        Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: _StatusBadge(status: fornecedor.status))),
        Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Row(children: [
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit, size: 16, color: AppTheme.info), constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
          const SizedBox(width: 4),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete, size: 16, color: AppTheme.danger), constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
        ]))),
      ]),
    ),
  );
}

class _FornecedorDetalhe extends StatefulWidget {
  final Fornecedor fornecedor;
  final VoidCallback onSave;
  const _FornecedorDetalhe({required this.fornecedor, required this.onSave});

  @override
  State<_FornecedorDetalhe> createState() => _FornecedorDetalheState();
}

class _FornecedorDetalheState extends State<_FornecedorDetalhe> {
  late TextEditingController _cnpjCtrl, _telCtrl, _emailCtrl, _endCtrl;

  @override
  void initState() {
    super.initState();
    _cnpjCtrl = TextEditingController(text: widget.fornecedor.cnpj);
    _telCtrl = TextEditingController(text: widget.fornecedor.telefone);
    _emailCtrl = TextEditingController(text: widget.fornecedor.email);
    _endCtrl = TextEditingController(text: widget.fornecedor.endereco);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.fornecedor.nome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _Field('CNPJ', _cnpjCtrl)),
            const SizedBox(width: 12),
            Expanded(child: _Field('Telefone', _telCtrl)),
            const SizedBox(width: 12),
            Expanded(child: _Field('E-mail', _emailCtrl)),
          ]),
          const SizedBox(height: 12),
          _Field('Endereço', _endCtrl),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            OutlinedButton(onPressed: () {}, child: const Text('Deletar')),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: () {}, child: const Text('Ver Títulos Favoritos')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () {
              widget.fornecedor.cnpj = _cnpjCtrl.text;
              widget.fornecedor.telefone = _telCtrl.text;
              widget.fornecedor.email = _emailCtrl.text;
              widget.fornecedor.endereco = _endCtrl.text;
              widget.onSave();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fornecedor salvo!'), backgroundColor: AppTheme.success));
            }, child: const Text('Salvar')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textSecondary), child: const Text('Calcular')),
          ]),
        ],
      ),
    );
  }
}

// ==================== FORNECEDOR FORM DIALOG ====================

class FornecedorFormDialog extends StatefulWidget {
  final Fornecedor? fornecedor;
  const FornecedorFormDialog({super.key, this.fornecedor});

  @override
  State<FornecedorFormDialog> createState() => _FornecedorFormDialogState();
}

class _FornecedorFormDialogState extends State<FornecedorFormDialog> {
  late TextEditingController _nomeCtrl, _contatoCtrl, _emailCtrl, _telCtrl, _cnpjCtrl, _endCtrl;
  String _status = 'Ativo';

  @override
  void initState() {
    super.initState();
    final f = widget.fornecedor;
    _nomeCtrl = TextEditingController(text: f?.nome ?? '');
    _contatoCtrl = TextEditingController(text: f?.contato ?? '');
    _emailCtrl = TextEditingController(text: f?.email ?? '');
    _telCtrl = TextEditingController(text: f?.telefone ?? '');
    _cnpjCtrl = TextEditingController(text: f?.cnpj ?? '');
    _endCtrl = TextEditingController(text: f?.endereco ?? '');
    if (f != null) _status = f.status;
  }

  void _salvar() {
    if (_nomeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nome é obrigatório.'), backgroundColor: AppTheme.danger));
      return;
    }
    if (widget.fornecedor != null) {
      widget.fornecedor!
        ..nome = _nomeCtrl.text
        ..contato = _contatoCtrl.text
        ..email = _emailCtrl.text
        ..telefone = _telCtrl.text
        ..cnpj = _cnpjCtrl.text
        ..endereco = _endCtrl.text
        ..status = _status;
    } else {
      AppState.fornecedores.add(Fornecedor(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nome: _nomeCtrl.text,
        contato: _contatoCtrl.text,
        email: _emailCtrl.text,
        telefone: _telCtrl.text,
        cnpj: _cnpjCtrl.text,
        endereco: _endCtrl.text,
        status: _status,
      ));
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      width: 500,
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Text(widget.fornecedor != null ? 'Editar Fornecedor' : 'Novo Fornecedor', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        ]),
        const SizedBox(height: 16),
        _Field('Nome *', _nomeCtrl),
        const SizedBox(height: 10),
        _Field('Contato', _contatoCtrl),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _Field('E-mail', _emailCtrl)),
          const SizedBox(width: 10),
          Expanded(child: _Field('Telefone', _telCtrl)),
        ]),
        const SizedBox(height: 10),
        _Field('CNPJ', _cnpjCtrl),
        const SizedBox(height: 10),
        _Field('Endereço', _endCtrl),
        const SizedBox(height: 10),
        _DropField('Status', ['Ativo', 'Inativo', 'Aguardando'], _status, (v) => setState(() => _status = v!)),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
        ]),
      ]),
    ),
  );
}

// ==================== MOVIMENTAÇÕES SCREEN ====================

class MovimentacoesScreen extends StatefulWidget {
  const MovimentacoesScreen({super.key});

  @override
  State<MovimentacoesScreen> createState() => _MovimentacoesScreenState();
}

class _MovimentacoesScreenState extends State<MovimentacoesScreen> {
  String _tipo = 'Entrada';
  String _nota = '';
  String _produtoId = '';
  final _qtdCtrl = TextEditingController();
  final _obsCtrl = TextEditingController();
  String _filtroDias = '7 dias';

  List<Movimentacao> get _filtradas {
    final agora = DateTime.now();
    int dias = 7;
    if (_filtroDias == '30 dias') dias = 30;
    if (_filtroDias == '90 dias') dias = 90;
    return AppState.movimentacoes.where((m) => agora.difference(m.data).inDays <= dias).toList()
      ..sort((a, b) => b.data.compareTo(a.data));
  }

  void _registrar() {
    if (_produtoId.isEmpty || _qtdCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione o produto e a quantidade.'), backgroundColor: AppTheme.danger));
      return;
    }
    final qtd = int.tryParse(_qtdCtrl.text) ?? 0;
    final produto = AppState.produtos.firstWhere((p) => p.id == _produtoId, orElse: () => AppState.produtos.first);

    if (_tipo == 'Saída' && produto.quantidade < qtd) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Estoque insuficiente!'), backgroundColor: AppTheme.danger));
      return;
    }

    if (_tipo == 'Entrada') produto.quantidade += qtd;
    else if (_tipo == 'Saída') produto.quantidade -= qtd;
    else produto.quantidade = qtd;

    String status = 'Ativo';
    if (produto.quantidade == 0) status = 'Sem Estoque';
    else if (produto.quantidade <= produto.quantidadeMinima) status = 'Crítico';
    else if (produto.quantidade <= produto.quantidadeMinima * 2) status = 'Atenção';
    produto.status = status;

    AppState.movimentacoes.insert(0, Movimentacao(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      data: DateTime.now(),
      tipo: _tipo,
      produto: produto.nome,
      codigoProduto: produto.codigo,
      quantidade: qtd,
      estoqueFinal: produto.quantidade,
      responsavel: AppState.usuarioLogado?.nome ?? 'Admin',
      observacoes: _obsCtrl.text,
    ));

    _qtdCtrl.clear();
    _obsCtrl.clear();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Movimentação registrada!'), backgroundColor: AppTheme.success));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Nova Movimentação', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(children: [
                // Tipo
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Tipo de Movimentação', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  Row(children: [
                    _TipoBotao(label: 'Entrada', cor: AppTheme.success, selecionado: _tipo == 'Entrada', onTap: () => setState(() => _tipo = 'Entrada')),
                    const SizedBox(width: 8),
                    _TipoBotao(label: 'Saída', cor: AppTheme.danger, selecionado: _tipo == 'Saída', onTap: () => setState(() => _tipo = 'Saída')),
                    const SizedBox(width: 8),
                    _TipoBotao(label: 'Ajuste', cor: AppTheme.warning, selecionado: _tipo == 'Ajuste', onTap: () => setState(() => _tipo = 'Ajuste')),
                  ]),
                ]),
                const SizedBox(width: 24),
                // Nota
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Nota', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  SizedBox(width: 200, child: DropdownButtonFormField<String>(
                    value: _nota.isEmpty ? null,
                    hint: const Text('Selecione uma categoria'),
                    items: ['Compras', 'Vendas', 'Ajuste', 'Devolução', 'Outros'].map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
                    onChanged: (v) => setState(() => _nota = v ?? ''),
                    decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  )),
                ]),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                // Produto
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Produto', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _produtoId.isEmpty ? null,
                    hint: const Text('Buscar por código'),
                    items: AppState.produtos.map((p) => DropdownMenuItem(value: p.id, child: Text('${p.codigo} - ${p.nome}', overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => setState(() => _produtoId = v ?? ''),
                    decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  ),
                ])),
                const SizedBox(width: 16),
                // Insumo/data
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Insumo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  SizedBox(width: 140, child: TextField(
                    decoration: const InputDecoration(hintText: 'PROD/05-31/26', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                    readOnly: true,
                  )),
                ]),
                const SizedBox(width: 16),
                // Quantidade
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Quantidade *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  SizedBox(width: 120, child: TextField(controller: _qtdCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Quantidade', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                ]),
                const SizedBox(width: 16),
                // Observações
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Observações', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  TextField(controller: _obsCtrl, decoration: const InputDecoration(hintText: 'Adicionar observações...', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
                ])),
              ]),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                OutlinedButton(onPressed: () { _qtdCtrl.clear(); _obsCtrl.clear(); setState(() { _produtoId = ''; _nota = ''; }); }, child: const Text('Cancelar')),
                const SizedBox(width: 12),
                ElevatedButton.icon(onPressed: _registrar, icon: const Icon(Icons.check, size: 16), label: const Text('Enviar produto')),
              ]),
            ]),
          ),
          const SizedBox(height: 24),
          // History
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  const Text('Histórico de Movimentações', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  DropdownButton<String>(
                    value: _filtroDias,
                    underline: const SizedBox(),
                    items: ['7 dias', '30 dias', '90 dias'].map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
                    onChanged: (v) => setState(() => _filtroDias = v!),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.filter_list, size: 16), label: const Text('Filtrar')),
                ]),
              ),
              const Divider(height: 1),
              Container(
                decoration: const BoxDecoration(color: Color(0xFFF9FAFB)),
                child: const Row(children: [
                  _TableHeader('DATA/HORA', flex: 2),
                  _TableHeader('TIPO', flex: 1),
                  _TableHeader('PRODUTO', flex: 4),
                  _TableHeader('CÓDIGO', flex: 2),
                  _TableHeader('QTD', flex: 1),
                  _TableHeader('EST. FINAL', flex: 2),
                  _TableHeader('RESPONSÁVEL', flex: 2),
                  _TableHeader('CATEG.', flex: 2),
                  _TableHeader('AÇÕES', flex: 1),
                ]),
              ),
              const Divider(height: 1),
              ..._filtradas.map((m) => _MovRow(movimentacao: m, onDelete: () => setState(() => AppState.movimentacoes.remove(m)))),
              if (_filtradas.isEmpty) const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('Nenhuma movimentação encontrada.', style: TextStyle(color: AppTheme.textSecondary)))),
            ]),
          ),
        ],
      ),
    );
  }
}

class _TipoBotao extends StatelessWidget {
  final String label;
  final Color cor;
  final bool selecionado;
  final VoidCallback onTap;
  const _TipoBotao({required this.label, required this.cor, required this.selecionado, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selecionado ? cor : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cor),
      ),
      child: Text(label, style: TextStyle(color: selecionado ? Colors.white : cor, fontWeight: FontWeight.w600, fontSize: 13)),
    ),
  );
}

class _MovRow extends StatelessWidget {
  final Movimentacao movimentacao;
  final VoidCallback onDelete;
  const _MovRow({required this.movimentacao, required this.onDelete});

  Color get _tipoColor => movimentacao.tipo == 'Entrada' ? AppTheme.success : movimentacao.tipo == 'Saída' ? AppTheme.danger : AppTheme.warning;

  @override
  Widget build(BuildContext context) {
    final d = movimentacao.data;
    final dataStr = '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}, ${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
    return Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF3F4F6)))),
      child: Row(children: [
        Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), child: Text(dataStr, style: const TextStyle(fontSize: 11)))),
        Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: _tipoColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
          child: Text(movimentacao.tipo, style: TextStyle(fontSize: 11, color: _tipoColor, fontWeight: FontWeight.w600)),
        ))),
        Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(movimentacao.produto, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis))),
        Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(movimentacao.codigoProduto, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)))),
        Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('${movimentacao.quantidade}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)))),
        Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('${movimentacao.estoqueFinal}', style: const TextStyle(fontSize: 12)))),
        Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(movimentacao.responsavel, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis))),
        Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(movimentacao.categoria.isNotEmpty ? movimentacao.categoria : '-', style: const TextStyle(fontSize: 12)))),
        Expanded(flex: 1, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: IconButton(onPressed: onDelete, icon: const Icon(Icons.delete, size: 16, color: AppTheme.danger), constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)))),
      ]),
    );
  }
}

// ==================== CONFIGURAÇÕES SCREEN ====================

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final _empresaCtrl = TextEditingController(text: 'A Livraria ALULISTA');
  final _cnpjCtrl = TextEditingController(text: '0-392-23 MG Studio');
  final _endCtrl = TextEditingController(text: 'Rua Dinamite, MG - Conceição PI');
  bool _notifEmail = true, _notifEstoque = true, _notifCritico = true;
  bool _alertasEstoque = true, _alertaVencimento = false, _alertasPublico = false;

  late TextEditingController _nomeCtrl, _sobrenomeCtrl, _emailCtrl, _senhaCtrl;

  @override
  void initState() {
    super.initState();
    final u = AppState.usuarioLogado;
    _nomeCtrl = TextEditingController(text: u?.nome ?? '');
    _sobrenomeCtrl = TextEditingController(text: u?.sobrenome ?? '');
    _emailCtrl = TextEditingController(text: u?.email ?? '');
    _senhaCtrl = TextEditingController(text: u?.senha ?? '');
  }

  void _salvarPerfil() {
    if (AppState.usuarioLogado != null) {
      AppState.usuarioLogado!.nome = _nomeCtrl.text;
      AppState.usuarioLogado!.sobrenome = _sobrenomeCtrl.text;
      AppState.usuarioLogado!.email = _emailCtrl.text;
      if (_senhaCtrl.text.isNotEmpty) AppState.usuarioLogado!.senha = _senhaCtrl.text;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil salvo com sucesso!'), backgroundColor: AppTheme.success));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final u = AppState.usuarioLogado;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column
          Expanded(
            flex: 2,
            child: Column(children: [
              _ConfigCard(
                title: '⚙️ Configurações do Sistema',
                child: Column(children: [
                  Row(children: [
                    Expanded(child: _Field('Nome da Empresa', _empresaCtrl)),
                    const SizedBox(width: 12),
                    Expanded(child: _Field('Idioma Padrão', TextEditingController(text: 'Português - BR'))),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _Field('Funcionário', _cnpjCtrl)),
                    const SizedBox(width: 12),
                    Expanded(child: _Field('Formato de Data', TextEditingController(text: 'DD/MM/YYY'))),
                  ]),
                  const SizedBox(height: 10),
                  _Field('Endereço', _endCtrl),
                ]),
              ),
              const SizedBox(height: 16),
              _ConfigCard(
                title: '📦 Configurações de Estoque',
                child: Column(children: [
                  _SwitchRow('Alertas de Estoque', _alertasEstoque, (v) => setState(() => _alertasEstoque = v)),
                  const SizedBox(height: 4),
                  _Field('Nível Mínimo Padrão', TextEditingController(text: '5')),
                  const SizedBox(height: 10),
                  _Field('Nível Crítico Padrão', TextEditingController()),
                  const SizedBox(height: 8),
                  _SwitchRow('Permitir Estoque Negativo', false, (_) {}),
                  _SwitchRow('Alertar Vencimento de Produto', _alertaVencimento, (v) => setState(() => _alertaVencimento = v)),
                  _SwitchRow('Alertar Consulta do Livro', _alertasPublico, (v) => setState(() => _alertasPublico = v)),
                ]),
              ),
              const SizedBox(height: 16),
              _ConfigCard(
                title: '📧 Notificações por E-mail',
                child: Column(children: [
                  _SwitchRow('Notificar Estoque Baixo', _notifEstoque, (v) => setState(() => _notifEstoque = v)),
                  const SizedBox(height: 8),
                  _Field('E-mail para notificações', TextEditingController(text: 'senai@senai.com')),
                  const SizedBox(height: 8),
                  _Field('', TextEditingController(text: 'contato@senai.br')),
                  const SizedBox(height: 8),
                  _SwitchRow('Notificar Informações Críticas', _notifCritico, (v) => setState(() => _notifCritico = v)),
                ]),
              ),
            ]),
          ),
          const SizedBox(width: 24),
          // Right column
          Expanded(
            child: Column(children: [
              _ConfigCard(
                title: '👤 Perfil do Usuário',
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppTheme.primary,
                    child: Text(u != null ? u.nome[0].toUpperCase() : 'A', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Text(u != null ? '${u.nome} ${u.sobrenome}' : 'Admin', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(u?.funcao ?? 'ADM/Líder', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: _Field('Nome', _nomeCtrl)),
                    const SizedBox(width: 8),
                    Expanded(child: _Field('Sobrenome', _sobrenomeCtrl)),
                  ]),
                  const SizedBox(height: 8),
                  _Field('E-mail', _emailCtrl),
                  const SizedBox(height: 8),
                  _Field('Senha', _senhaCtrl),
                  const SizedBox(height: 8),
                  _DropField('Nome de exibição', ['Automático', 'Nome', 'Sobrenome', 'E-mail'], 'Automático', (_) {}),
                  const SizedBox(height: 16),
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _salvarPerfil, child: const Text('Salvar Perfil'))),
                ]),
              ),
              const SizedBox(height: 16),
              _ConfigCard(
                title: 'ℹ️ Informações do Sistema',
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _InfoRow('Versão', 'SENAI V1.0'),
                  _InfoRow('Última Atualização', '29/03/2025'),
                  _InfoRow('Licença', 'Licença Empresarial Válida até 24/03/2026'),
                  Row(children: [
                    const Icon(Icons.circle, size: 10, color: AppTheme.success),
                    const SizedBox(width: 6),
                    const Text('Plano: Sistema Atualizado', style: TextStyle(fontSize: 12)),
                  ]),
                  const SizedBox(height: 4),
                  _InfoRow('Último Backup', '29/03/2025, 16:32'),
                  const SizedBox(height: 12),
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup iniciado!'), backgroundColor: AppTheme.success));
                  }, child: const Text('Fazer Backup Agora'))),
                ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _InfoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
      Text(value, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
    ]),
  );

  Widget _SwitchRow(String label, bool value, ValueChanged<bool> onChanged) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 13)),
      Switch(value: value, onChanged: onChanged, activeColor: AppTheme.primary),
    ],
  );
}

class _ConfigCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _ConfigCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      child,
    ]),
  );
}

// ==================== USUÁRIOS SCREEN ====================

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  void _abrirFormulario([Usuario? usuario]) async {
    await showDialog(context: context, builder: (_) => UsuarioFormDialog(usuario: usuario));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final todos = [
      if (AppState.usuarioLogado != null) AppState.usuarioLogado!,
      ...AppState.usuarios,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            ElevatedButton.icon(onPressed: () => _abrirFormulario(), icon: const Icon(Icons.add, size: 16), label: const Text('Adicionar Usuário')),
          ]),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: Column(children: [
              Container(
                decoration: const BoxDecoration(color: Color(0xFFF9FAFB), borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                child: const Row(children: [
                  _TableHeader('USUÁRIO', flex: 3),
                  _TableHeader('E-MAIL', flex: 3),
                  _TableHeader('FUNÇÃO', flex: 2),
                  _TableHeader('AÇÕES', flex: 2),
                ]),
              ),
              const Divider(height: 1),
              ...todos.map((u) => Container(
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF3F4F6)))),
                child: Row(children: [
                  Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), child: Row(children: [
                    CircleAvatar(radius: 16, backgroundColor: AppTheme.primary, child: Text(u.nome[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                    const SizedBox(width: 8),
                    Text('${u.nome} ${u.sobrenome}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  ]))),
                  Expanded(flex: 3, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(u.email, style: const TextStyle(fontSize: 12)))),
                  Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(u.funcao, style: const TextStyle(fontSize: 12)))),
                  Expanded(flex: 2, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Row(children: [
                    IconButton(onPressed: () => _abrirFormulario(u), icon: const Icon(Icons.edit, size: 16, color: AppTheme.info), constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: u == AppState.usuarioLogado ? null : () {
                        setState(() => AppState.usuarios.remove(u));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário removido.')));
                      },
                      icon: const Icon(Icons.delete, size: 16, color: AppTheme.danger),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                    ),
                  ]))),
                ]),
              )),
              if (todos.isEmpty) const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('Nenhum usuário cadastrado.', style: TextStyle(color: AppTheme.textSecondary)))),
            ]),
          ),
        ],
      ),
    );
  }
}

class UsuarioFormDialog extends StatefulWidget {
  final Usuario? usuario;
  const UsuarioFormDialog({super.key, this.usuario});

  @override
  State<UsuarioFormDialog> createState() => _UsuarioFormDialogState();
}

class _UsuarioFormDialogState extends State<UsuarioFormDialog> {
  late TextEditingController _nomeCtrl, _sobCtrl, _emailCtrl, _senhaCtrl;
  String _funcao = 'Administrador';

  @override
  void initState() {
    super.initState();
    final u = widget.usuario;
    _nomeCtrl = TextEditingController(text: u?.nome ?? '');
    _sobCtrl = TextEditingController(text: u?.sobrenome ?? '');
    _emailCtrl = TextEditingController(text: u?.email ?? '');
    _senhaCtrl = TextEditingController(text: u?.senha ?? '');
    if (u != null) _funcao = u.funcao;
  }

  void _salvar() {
    if (_nomeCtrl.text.isEmpty || _emailCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nome e e-mail são obrigatórios.'), backgroundColor: AppTheme.danger));
      return;
    }
    if (widget.usuario != null) {
      widget.usuario!..nome = _nomeCtrl.text..sobrenome = _sobCtrl.text..email = _emailCtrl.text..funcao = _funcao;
      if (_senhaCtrl.text.isNotEmpty) widget.usuario!.senha = _senhaCtrl.text;
    } else {
      AppState.usuarios.add(Usuario(nome: _nomeCtrl.text, sobrenome: _sobCtrl.text, email: _emailCtrl.text, senha: _senhaCtrl.text, funcao: _funcao));
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário salvo!'), backgroundColor: AppTheme.success));
  }

  @override
  Widget build(BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      width: 420,
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Text(widget.usuario != null ? 'Editar Usuário' : 'Novo Usuário', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _Field('Nome *', _nomeCtrl)),
          const SizedBox(width: 10),
          Expanded(child: _Field('Sobrenome', _sobCtrl)),
        ]),
        const SizedBox(height: 10),
        _Field('E-mail *', _emailCtrl),
        const SizedBox(height: 10),
        _Field('Senha', _senhaCtrl),
        const SizedBox(height: 10),
        _DropField('Função', ['Administrador', 'ADM/Líder', 'Operador', 'Visualizador'], _funcao, (v) => setState(() => _funcao = v!)),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
        ]),
      ]),
    ),
  );
}

// ==================== IMPORTAR DIALOG ====================

class ImportarDialog extends StatefulWidget {
  final String titulo;
  const ImportarDialog({super.key, required this.titulo});

  @override
  State<ImportarDialog> createState() => _ImportarDialogState();
}

class _ImportarDialogState extends State<ImportarDialog> {
  bool _arrastando = false;

  @override
  Widget build(BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      width: 380,
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Text('Importar Planilha - ${widget.titulo}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Spacer(),
          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        ]),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione um arquivo CSV ou Excel.')));
          },
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _arrastando ? AppTheme.primary.withOpacity(0.05) : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _arrastando ? AppTheme.primary : const Color(0xFFE5E7EB), style: BorderStyle.solid),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.upload_file, size: 40, color: _arrastando ? AppTheme.primary : AppTheme.textSecondary),
              const SizedBox(height: 8),
              const Text('Arraste e solte o arquivo aqui', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              const Text('Suporta CSV e Excel (.xlsx)', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
              const SizedBox(height: 8),
              OutlinedButton(onPressed: () {}, child: const Text('Abrir Arquivo')),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${widget.titulo} importados com sucesso!'), backgroundColor: AppTheme.success));
          },
          child: const Text('Importar'),
        )),
      ]),
    ),
  );
}

// ==================== STATUS BADGE ====================

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case 'Ativo': return AppTheme.success;
      case 'Crítico': return AppTheme.danger;
      case 'Atenção': return AppTheme.warning;
      case 'Inativo': return AppTheme.textSecondary;
      case 'Aguardando': return AppTheme.warning;
      case 'Sem Estoque': return AppTheme.danger;
      default: return AppTheme.info;
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: _color.withOpacity(0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: _color.withOpacity(0.3))),
    child: Text(status, style: TextStyle(fontSize: 11, color: _color, fontWeight: FontWeight.w600)),
  );
}
