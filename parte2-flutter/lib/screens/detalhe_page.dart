import 'package:flutter/material.dart';
import '../models/peca.dart';
import '../models/peca_performance.dart';
import 'cadastro_page.dart';
import 'package:parte2_flutter/theme/app_theme.dart';

/// Ex 8: a peça chega pelo construtor, vinda da lista.
/// A tela mostra dados que não aparecem no cartão: quantidade, data de
/// cadastro e, nas peças de performance, ganho de potência e material.
class DetalhePage extends StatelessWidget {
  final Peca peca;

  const DetalhePage({super.key, required this.peca});

  void _confirmarExclusao(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: const Text(
          'Excluir peça',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Text(
          '${peca.nome} será removida do estoque. Essa ação não pode ser desfeita.',
          style: const TextStyle(fontSize: 14.5, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Manter', style: TextStyle(color: ctx.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop({'action': 'delete', 'peca': peca});
            },
            child: Text(
              'Excluir',
              style: TextStyle(
                color: Theme.of(ctx).colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _abrirEdicao(BuildContext context) async {
    final pecaEditada = await Navigator.of(context).push<Peca>(
      MaterialPageRoute(
        builder: (context) => CadastroPage(pecaParaEditar: peca),
      ),
    );
    if (pecaEditada != null && context.mounted) {
      Navigator.of(context).pop({'action': 'edit', 'peca': pecaEditada});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPerformance = peca is PecaPerformance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da peça'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 21),
            tooltip: 'Editar peça',
            onPressed: () => _abrirEdicao(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Imagem sobre fundo neutro, sem cortar o produto.
                Container(
                  decoration: BoxDecoration(
                    color: context.isDark
                        ? Colors.white.withValues(alpha: 0.04)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    border: Border.all(color: context.hairline),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Image.network(
                      peca.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.settings_outlined,
                        size: 56,
                        color: context.textMuted.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                if (isPerformance) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.oxide.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Linha performance',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.oxide,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Text(
                  peca.nome,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                    height: 1.15,
                    color: context.textStrong,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  peca.fabricante,
                  style: TextStyle(fontSize: 15, color: context.textMuted),
                ),
                const SizedBox(height: 18),

                // Ficha técnica
                Container(
                  decoration: BoxDecoration(
                    color: context.cardSurface,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    border: Border.all(color: context.hairline),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      _LinhaFicha(
                        rotulo: 'Preço unitário',
                        valor: Formato.real(peca.preco),
                        destaque: true,
                      ),
                      _LinhaFicha(
                        rotulo: 'Quantidade em estoque',
                        valor: '${peca.quantidade} un.',
                      ),
                      _LinhaFicha(
                        rotulo: 'Valor desta peça no estoque',
                        valor: Formato.real(peca.preco * peca.quantidade),
                      ),
                      _LinhaFicha(
                        rotulo: 'Cadastrada em',
                        valor: Formato.data(peca.dataCadastro),
                        ultima: !isPerformance,
                      ),
                      // Ex 2: dados que só a subclasse tem.
                      if (isPerformance) ...[
                        _LinhaFicha(
                          rotulo: 'Ganho de potência',
                          valor:
                              '+${(peca as PecaPerformance).ganhoCavalos} cv (estimado)',
                        ),
                        _LinhaFicha(
                          rotulo: 'Material',
                          valor: (peca as PecaPerformance).material,
                          ultima: true,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => _abrirEdicao(context),
                    icon: const Icon(Icons.edit_outlined, size: 19),
                    label: const Text('Editar peça'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmarExclusao(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.error.withValues(alpha: 0.4),
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline, size: 19),
                    label: const Text('Excluir peça'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Uma linha da ficha técnica: rótulo à esquerda, valor à direita.
class _LinhaFicha extends StatelessWidget {
  final String rotulo;
  final String valor;
  final bool destaque;
  final bool ultima;

  const _LinhaFicha({
    required this.rotulo,
    required this.valor,
    this.destaque = false,
    this.ultima = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(
        border: ultima
            ? null
            : Border(bottom: BorderSide(color: context.hairline)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              rotulo,
              style: TextStyle(fontSize: 14, color: context.textMuted),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            valor,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: destaque ? 17 : 14.5,
              fontWeight: destaque ? FontWeight.w700 : FontWeight.w600,
              letterSpacing: destaque ? -0.3 : 0,
              color: context.textStrong,
            ),
          ),
        ],
      ),
    );
  }
}
