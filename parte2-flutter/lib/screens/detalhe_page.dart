import 'package:flutter/material.dart';
import '../models/peca.dart';
import '../models/peca_performance.dart';

class DetalhePage extends StatelessWidget {
  final Peca peca;

  const DetalhePage({super.key, required this.peca});

  @override
  Widget build(BuildContext context) {
    final dia = peca.dataCadastro.day.toString().padLeft(2, '0');
    final mes = peca.dataCadastro.month.toString().padLeft(2, '0');
    final ano = peca.dataCadastro.year;
    final dataFormatada = '$dia/$mes/$ano';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: Text(peca.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Container da foto com proporção bonita
                Container(
                  color: Colors.white,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      peca.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(peca.nome, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('Fabricante: ${peca.fabricante}', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                        const Divider(height: 36),
                        _buildDetailRow(Icons.attach_money, 'Preço Unitário', 'R\$ ${peca.preco.toStringAsFixed(2)}'),
                        const SizedBox(height: 18),
                        _buildDetailRow(Icons.inventory_2_outlined, 'Quantidade em Estoque', '${peca.quantidade} un.'),
                        const SizedBox(height: 18),
                        _buildDetailRow(Icons.calendar_today_outlined, 'Data de Cadastro', dataFormatada),
                        if (peca is PecaPerformance) ...[
                          const Divider(height: 36),
                          _buildDetailRow(Icons.speed, 'Ganho Estimado', '+${(peca as PecaPerformance).ganhoCavalos}cv'),
                          const SizedBox(height: 18),
                          _buildDetailRow(Icons.architecture, 'Material de Fabricação', (peca as PecaPerformance).material),
                        ]
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E).withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF1E1E1E), size: 24),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}