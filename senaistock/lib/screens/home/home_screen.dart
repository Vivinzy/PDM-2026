import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senaistock/core/constants/app_colors.dart';
import 'package:senaistock/providers/auth_provider.dart'; // Ajuste aqui se sua pasta for 'core/providers/'

// ==========================================
// 1. TELA HOME GERAL (OPCIONAL / RASCUNHO)
// ==========================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home Geral')),
    );
  }
}

// ==========================================
// 2. TELA DO PROFESSOR
// ==========================================
class ProfessorScreen extends StatelessWidget {
  const ProfessorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final professorNome = authProvider.usuarioAtual?.name ?? 'Professor';
    final professorRN = authProvider.usuarioAtual?.rn ?? '---';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Painel do Professor',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 24,
                      child: Icon(Icons.person, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, $professorNome',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        Text(
                          'RN: $professorRN | Cargo: Professor',
                          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Suas Solicitações Recentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            _buildPedidoCard('Livro: Algoritmos e Estruturas de Dados', 'Qtd: 35', 'Confirmado', AppColors.statusTranquilo),
            _buildPedidoCard('Livro: Banco de Dados MySQL', 'Qtd: 40', 'Pendente (Triagem)', AppColors.statusAlerta),
            _buildPedidoCard('Livro: Desenvolvimento Web com React', 'Qtd: 20', 'Aguardando Secretaria', AppColors.statusCritico),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Abrindo formulário de nova solicitação...')),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Solicitar Novo Material',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPedidoCard(String titulo, String qtd, String status, Color statusColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        subtitle: Text(qtd, style: const TextStyle(color: AppColors.textSecondary)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. TELA DA SECRETARIA
// ==========================================
class SecretariaScreen extends StatelessWidget {
  const SecretariaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final secretariaNome = authProvider.usuarioAtual?.name ?? 'Secretária(o)';
    final secretariaRN = authProvider.usuarioAtual?.rn ?? '---';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Painel da Secretaria',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 24,
                      child: Icon(Icons.assignment_ind, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, $secretariaNome',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        Text(
                          'RN: $secretariaRN | Cargo: Secretaria',
                          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Solicitações Pendentes de Validação',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            _buildValidacaoCard(context, 'Prof. Carlos', 'Livro: Banco de Dados MySQL', 'Qtd: 40'),
            _buildValidacaoCard(context, 'Prof. Roberto', 'Livro: Redes de Computadores', 'Qtd: 15'),
            _buildValidacaoCard(context, 'Profa. Mariana', 'Livro: Programação Mobile', 'Qtd: 30'),
          ],
        ),
      ),
    );
  }

  Widget _buildValidacaoCard(BuildContext context, String professor, String material, String qtd) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(professor, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                const Icon(Icons.pending_actions, color: AppColors.statusAlerta),
              ],
            ),
            const Divider(),
            Text(material, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            Text(qtd, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pedido recusado.')),
                    );
                  },
                  icon: const Icon(Icons.close, color: AppColors.statusCritico),
                  label: const Text('Recusar', style: TextStyle(color: AppColors.statusCritico)),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusTranquilo),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pedido aprovado e enviado ao Almoxarifado!')),
                    );
                  },
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text('Aprovar', style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}