import 'package:flutter/material.dart';
import '../models/peca.dart';
import '../models/peca_performance.dart';

class CartaoPeca extends StatelessWidget {
  final Peca peca;

  const CartaoPeca({super.key, required this.peca});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // Atualizado aqui
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Lado Esquerdo: Imagem
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            child: Image.network(
              peca.imageUrl,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => 
                const SizedBox(width: 110, height: 110, child: Icon(Icons.build, size: 40, color: Colors.grey)),
            ),
          ),
          // Lado Direito: Informações
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    peca.nome,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    peca.fabricante,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'R\$ ${peca.preco.toStringAsFixed(2)}',
                        style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      if (peca is PecaPerformance)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.1), // Atualizado aqui
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '+${(peca as PecaPerformance).ganhoCavalos}cv',
                            style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}