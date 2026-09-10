import 'package:flutter/material.dart';
import '../models/peca.dart';
import '../models/peca_performance.dart';

class CartaoPeca extends StatelessWidget {
  final Peca peca;
  final VoidCallback? onEditar;
  final VoidCallback? onExcluir;

  const CartaoPeca({
    super.key,
    required this.peca,
    this.onEditar,
    this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E1E1E);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Row(
        children: [
          // Lado Esquerdo: Imagem
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: Image.network(
              peca.imageUrl,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 110,
                height: 110,
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                child: const Icon(Icons.build, size: 40, color: Colors.grey),
              ),
            ),
          ),
          // Lado Direito: Informações e Menu
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          peca.nome,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Menu suspenso discreto com Editar e Excluir
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, size: 20, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                        padding: EdgeInsets.zero,
                        onSelected: (value) {
                          if (value == 'editar' && onEditar != null) onEditar!();
                          if (value == 'excluir' && onExcluir != null) onExcluir!();
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'editar',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 18, color: Colors.blueAccent),
                                SizedBox(width: 8),
                                Text('Editar'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'excluir',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                                SizedBox(width: 8),
                                Text('Excluir'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    peca.fabricante,
                    style: TextStyle(fontSize: 14, color: isDark ? Colors.grey[400] : Colors.grey[600]),
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
                            color: Colors.redAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
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