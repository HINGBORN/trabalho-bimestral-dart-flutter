import 'dart:async';

import 'package:flutter/material.dart';
import '../models/peca.dart';
import '../models/peca_performance.dart';
import 'package:parte2_flutter/theme/app_theme.dart';
import '../utils/imagem_peca.dart';



/// Ex 9: entrada de dados.
/// Recurso obrigatório: TextFormField.  Conceito: TextEditingController.
/// São TRÊS campos: nome, fabricante e preço. A imagem não é um quarto
/// campo — ela é deduzida do nome digitado, e só pode ser trocada por um
/// botão que abre um diálogo à parte.
class CadastroPage extends StatefulWidget {
  final Peca? pecaParaEditar;

  const CadastroPage({super.key, this.pecaParaEditar});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  // Ex 9: um controlador por campo. É por eles que o botão de confirmar
  // recupera o que foi digitado — sem controlador, o texto fica na tela
  // e o código não tem como lê-lo.
  final _nomeController = TextEditingController();
  final _fabricanteController = TextEditingController();
  final _precoController = TextEditingController();

  /// URL escolhida à mão no diálogo "Trocar imagem". Enquanto for nula,
  /// a imagem vem do nome digitado.
  String? _imagemManual;

  /// Espera o usuário parar de digitar antes de trocar a prévia, para
  /// não pedir uma imagem nova a cada letra.
  Timer? _debounce;

  bool get _isEditing => widget.pecaParaEditar != null;

  @override
  void initState() {
    super.initState();
    final peca = widget.pecaParaEditar;
    if (peca != null) {
      _nomeController.text = peca.nome;
      _fabricanteController.text = peca.fabricante;
      _precoController.text = peca.preco.toStringAsFixed(2).replaceAll('.', ',');
    }
  }

  @override
  void dispose() {
    // Ex 10: controlador precisa ser descartado quando o widget sai de
    // cena, ou vaza memória. O mesmo vale para o Timer.
    _debounce?.cancel();
    _nomeController.dispose();
    _fabricanteController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  /// Qual imagem a peça terá ao ser salva.
  String get _imagemAtual {
    if (_imagemManual != null) return _imagemManual!;

    final nome = _nomeController.text.trim();
    final original = widget.pecaParaEditar;

    // Editando sem mudar o nome: mantém a foto que a peça já tinha.
    if (original != null &&
        original.nome.trim().toLowerCase() == nome.toLowerCase()) {
      return original.imageUrl;
    }
    if (nome.isEmpty) return original?.imageUrl ?? Peca.imagemPadrao;

    return ImagemPeca.urlPara(nome);
  }

  void _aoDigitarNome() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      if (mounted) setState(() {});
    });
  }

  Future<void> _trocarImagem() async {
    final controller = TextEditingController(text: _imagemManual ?? '');
    final url = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: const Text(
          'Trocar imagem',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            labelText: 'URL da imagem',
            hintText: 'https://...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
          ),
          onSubmitted: (v) => Navigator.of(ctx).pop(v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(''),
            child: Text(
              'Usar a do nome',
              style: TextStyle(color: ctx.textMuted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text(
              'Aplicar',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
    controller.dispose();

    if (url == null) return; // fechou sem escolher
    setState(() => _imagemManual = url.isEmpty ? null : url);
  }

  void _salvar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // O controlador sempre devolve String: o preço precisa de conversão.
    // A vírgula vira ponto porque double.tryParse só entende ponto.
    final preco =
        double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0.0;

    final original = widget.pecaParaEditar;
    final Peca pecaFinal;

    // Editar uma peça de performance não pode transformá-la em peça comum:
    // o ganho de cavalos e o material se perderiam.
    if (original is PecaPerformance) {
      pecaFinal = PecaPerformance(
        nome: _nomeController.text.trim(),
        fabricante: _fabricanteController.text.trim(),
        preco: preco,
        quantidade: original.quantidade,
        dataCadastro: original.dataCadastro,
        imageUrl: _imagemAtual,
        ganhoCavalos: original.ganhoCavalos,
        material: original.material,
      );
    } else {
      pecaFinal = Peca(
        nome: _nomeController.text.trim(),
        fabricante: _fabricanteController.text.trim(),
        preco: preco,
        quantidade: original?.quantidade ?? 1,
        dataCadastro: original?.dataCadastro,
        imageUrl: _imagemAtual,
      );
    }

    Navigator.of(context).pop(pecaFinal);
  }

  /// Borda arredondada usada nos três campos (InputDecoration).
  OutlineInputBorder get _borda => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        borderSide: BorderSide(color: context.hairline),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar peça' : 'Nova peça')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _isEditing
                        ? 'Ajuste os dados e salve para atualizar o estoque.'
                        : 'Informe os dados da peça para incluir no estoque.',
                    style: TextStyle(
                      fontSize: 14.5,
                      height: 1.4,
                      color: context.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 22),
                    decoration: BoxDecoration(
                      color: context.cardSurface,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      border: Border.all(color: context.hairline),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: context.isDark ? 0.28 : 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Prévia da imagem — não é um campo do formulário.
                        _PreviaImagem(
                          url: _imagemAtual,
                          manual: _imagemManual != null,
                          temNome: _nomeController.text.trim().isNotEmpty,
                          onTrocar: _trocarImagem,
                        ),
                        const SizedBox(height: 20),

                        // Campo 1 — nome
                        TextFormField(
                          controller: _nomeController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) => _aoDigitarNome(),
                          decoration: InputDecoration(
                            labelText: 'Nome da peça',
                            hintText: 'Ex.: Pastilha de freio dianteira',
                            prefixIcon: const Icon(Icons.build_circle_outlined),
                            border: _borda,
                            enabledBorder: _borda,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Informe o nome da peça'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Campo 2 — fabricante
                        TextFormField(
                          controller: _fabricanteController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Fabricante',
                            hintText: 'Ex.: Cobreq',
                            prefixIcon: const Icon(Icons.business_outlined),
                            border: _borda,
                            enabledBorder: _borda,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Informe o fabricante'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Campo 3 — preço
                        TextFormField(
                          controller: _precoController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onFieldSubmitted: (_) => _salvar(),
                          decoration: InputDecoration(
                            labelText: 'Preço unitário',
                            hintText: '0,00',
                            prefixIcon: const Icon(Icons.attach_money_outlined),
                            prefixText: 'R\$ ',
                            border: _borda,
                            enabledBorder: _borda,
                          ),
                          // Decide o que fazer quando a conversão falha:
                          // aqui o cadastro é barrado e o erro aparece no campo.
                          validator: (v) {
                            final valor =
                                double.tryParse((v ?? '').replaceAll(',', '.'));
                            if (valor == null) return 'Preço inválido';
                            if (valor <= 0) return 'Deve ser maior que zero';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _salvar,
                      icon: Icon(
                        _isEditing ? Icons.save_outlined : Icons.check,
                        size: 20,
                      ),
                      label: Text(
                        _isEditing ? 'Salvar alterações' : 'Cadastrar peça',
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Miniatura da imagem que a peça vai receber, com o botão de troca.
class _PreviaImagem extends StatelessWidget {
  final String url;
  final bool manual;
  final bool temNome;
  final VoidCallback onTrocar;

  const _PreviaImagem({
    required this.url,
    required this.manual,
    required this.temNome,
    required this.onTrocar,
  });

  @override
  Widget build(BuildContext context) {
    final String legenda;
    if (manual) {
      legenda = 'Imagem definida por você.';
    } else if (temNome) {
      legenda = 'Imagem sugerida a partir do nome digitado.';
    } else {
      legenda = 'Digite o nome e a imagem aparece aqui.';
    }

    return Row(
      children: [
        Container(
          width: 76,
          height: 76,
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
            // A key força o Flutter a recarregar quando a URL muda.
            key: ValueKey(url),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(
              Icons.image_not_supported_outlined,
              size: 24,
              color: context.textMuted,
            ),
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.textMuted.withValues(alpha: 0.5),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                legenda,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  color: context.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: onTrocar,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Trocar imagem',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.oxide,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
