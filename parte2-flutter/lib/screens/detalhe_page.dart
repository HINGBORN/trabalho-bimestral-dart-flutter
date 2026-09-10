import 'package:flutter/material.dart';
import '../models/peca.dart';
import '../models/peca_performance.dart';

class DetalhePage extends StatelessWidget {
  final Peca peca;

  const DetalhePage({super.key, required this.peca});

  @override
  Widget build(BuildContext context) {
    // Formata a data para dd/mm/aaaa
    final dia = peca.dataCadastro.day.toString().padLeft(2, '0');
    final mes = peca.dataCadastro.month.toString().padLeft(2, '0');
    final ano = peca.dataCadastro.year;
    final dataFormatada = '$dia/$mes/$ano';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(peca.nome),
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              peca.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Icon(Icons.build, size: 80, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    peca.nome,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    peca.fabricante,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const Divider(height: 32),
                  
                  // Preço unitário
                  _buildDetailRow(
                    Icons.attach_money,
                    'Preço Unitário',
                    'R\$ ${peca.preco.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 16),

                  // DADO INÉDITO 1: Quantidade em Estoque (não aparece no Cartão)
                  _buildDetailRow(
                    Icons.inventory,
                    'Quantidade em Estoque',
                    '${peca.quantidade} un.',
                  ),
                  const SizedBox(height: 16),

                  // DADO INÉDITO 2: Data de Cadastro (não aparece no Cartão e é o 4º tipo do Ex 1)
                  _buildDetailRow(
                    Icons.calendar_today,
                    'Data de Cadastro',
                    dataFormatada,
                  ),

                  // Dados exclusivos se for PecaPerformance
                  if (peca is PecaPerformance) ...[
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.speed,
                      'Ganho Estimado',
                      '+${(peca as PecaPerformance).ganhoCavalos}cv',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.science,
                      'Material',
                      (peca as PecaPerformance).material,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 28),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}