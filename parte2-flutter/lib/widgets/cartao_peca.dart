import 'package:flutter/material.dart';
import 'package:parte2_flutter/theme/app_theme.dart';
import '../models/peca.dart';
import '../models/peca_performance.dart';


/// Ex 6: Cartão do item.
/// Recurso obrigatório: Container.  Conceito obrigatório: BoxDecoration.
/// O BoxDecoration abaixo define os três itens da evidência:
/// fundo (color), borda arredondada (borderRadius) e sombra (boxShadow).
class CartaoPeca extends StatelessWidget {
  final Peca peca;
  final VoidCallback? onTap;

  const CartaoPeca({super.key, required this.peca, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    // "é um": PecaPerformance é uma Peca, então cabe no mesmo cartão.
    final isPerformance = peca is PecaPerformance;
    final estoqueBaixo = peca.quantidade <= 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      // Ex 6: BoxDecoration — fundo, borda arredondada e sombra.
      decoration: BoxDecoration(
        color: context.cardSurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: context.hairline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Faixa lateral: só aparece nas peças de performance.
                Container(
                  width: 3,
                  color: isPerformance ? AppColors.oxide : Colors.transparent,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: _Miniatura(url: peca.imageUrl),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          peca.nome,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                            color: context.textStrong,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                peca.fabricante,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: context.textMuted,
                                ),
                              ),
                            ),
                            if (isPerformance) ...[
                              const SizedBox(width: 8),
                              const _Selo(texto: 'Performance'),
                            ],
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              Formato.real(peca.preco),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                                color: context.textStrong,
                              ),
                            ),
                            const SizedBox(width: 10),
                            _ChipEstoque(
                              quantidade: peca.quantidade,
                              alerta: estoqueBaixo,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 14),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: context.textMuted.withValues(alpha: 0.7),
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

class _Miniatura extends StatelessWidget {
  final String url;
  const _Miniatura({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: context.isDark
            ? Colors.white.withValues(alpha: 0.05)
            : const Color(0xFFF3F2EF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(
          Icons.settings_outlined,
          size: 26,
          color: context.textMuted.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class _Selo extends StatelessWidget {
  final String texto;
  const _Selo({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.oxide.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.oxide,
        ),
      ),
    );
  }
}

class _ChipEstoque extends StatelessWidget {
  final int quantidade;
  final bool alerta;

  const _ChipEstoque({required this.quantidade, required this.alerta});

  @override
  Widget build(BuildContext context) {
    final cor = alerta ? AppColors.hazard : context.textMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: cor.withValues(alpha: 0.35)),
      ),
      child: Text(
        quantidade == 1 ? 'última unidade' : '$quantidade em estoque',
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w500,
          color: cor,
        ),
      ),
    );
  }
}
