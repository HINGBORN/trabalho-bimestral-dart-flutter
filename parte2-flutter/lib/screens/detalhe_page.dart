import 'package:flutter/material.dart';
import '../models/peca.dart';
import '../models/peca_performance.dart';
import 'cadastro_page.dart';

class DetalhePage extends StatelessWidget {
  final Peca peca;

  const DetalhePage({super.key, required this.peca});

  void _confirmarExclusao(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Peça'),
        content: Text('Deseja realmente remover "${peca.nome}" do estoque?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop({'action': 'delete', 'peca': peca});
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _abrirEdicao(BuildContext context) async {
    final pecaEditada = await Navigator.of(context).push<Peca>(
      MaterialPageRoute(builder: (context) => CadastroPage(pecaParaEditar: peca)),
    );
    if (pecaEditada != null && context.mounted) {
      Navigator.of(context).pop({'action': 'edit', 'peca': pecaEditada});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E1E1E);
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    final dia = peca.dataCadastro.day.toString().padLeft(2, '0');
    final mes = peca.dataCadastro.month.toString().padLeft(2, '0');
    final ano = peca.dataCadastro.year;
    final dataFormatada = '$dia/$mes/$ano';

    return Scaffold(
      appBar: AppBar(
        title: Text(peca.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar Peça',
            onPressed: () => _abrirEdicao(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            tooltip: 'Excluir Peça',
            onPressed: () => _confirmarExclusao(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: isDark ? const Color(0xFF181818) : Colors.white,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      peca.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        child: const Icon(Icons.build, size: 80, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(peca.nome, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 6),
                        Text('Fabricante: ${peca.fabricante}', style: TextStyle(fontSize: 16, color: subTextColor)),
                        const Divider(height: 36),
                        _buildDetailRow(Icons.attach_money, 'Preço Unitário', 'R\$ ${peca.preco.toStringAsFixed(2)}', isDark),
                        const SizedBox(height: 18),
                        _buildDetailRow(Icons.inventory_2_outlined, 'Quantidade em Estoque', '${peca.quantidade} un.', isDark),
                        const SizedBox(height: 18),
                        _buildDetailRow(Icons.calendar_today_outlined, 'Data de Cadastro', dataFormatada, isDark),
                        if (peca is PecaPerformance) ...[
                          const Divider(height: 36),
                          _buildDetailRow(Icons.speed, 'Ganho de Potência', '+${(peca as PecaPerformance).ganhoCavalos}cv (estimativa)', isDark),
                          const SizedBox(height: 18),
                          _buildDetailRow(Icons.architecture, 'Material de Fabricação', (peca as PecaPerformance).material, isDark),
                        ],
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  side: BorderSide(color: isDark ? Colors.white38 : Colors.black26),
                                ),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Editar Peça'),
                                onPressed: () => _abrirEdicao(context),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent.withValues(alpha: 0.15),
                                  foregroundColor: Colors.redAccent,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Excluir Peça'),
                                onPressed: () => _confirmarExclusao(context),
                              ),
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
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFF1E1E1E).withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: isDark ? Colors.white : const Color(0xFF1E1E1E), size: 24),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 13, color: isDark ? Colors.grey[400] : Colors.grey[600])),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
          ],
        ),
      ],
    );
  }
}