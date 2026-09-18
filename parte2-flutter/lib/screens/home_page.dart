import 'package:flutter/material.dart';
import '../main.dart';
import '../models/peca.dart';
import '../models/peca_performance.dart';
import '../models/estoque.dart';
import 'package:parte2_flutter/theme/app_theme.dart';
import '../widgets/cartao_peca.dart';
import 'detalhe_page.dart';
import 'cadastro_page.dart';

// Ex 10: StatefulWidget — é ele que guarda o objeto agrupador.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Ex 3 e 4: entidade agrupadora. A lista e o total da tela saem daqui.
  final Estoque estoque = Estoque(categoria: 'Reposição Automotiva');

  @override
  void initState() {
    super.initState();
    // Ex 7: a lista já nasce com os seis itens, antes do primeiro frame.
    estoque.adicionar(Peca(
      nome: 'Pastilha de Freio',
      fabricante: 'Cobreq',
      preco: 116.90,
      quantidade: 4,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdaTJUIt56vaZnr7a2wMSh6M9GRtFh_A0PEpiZBmPvmw&s=10',
    ));
    estoque.adicionar(Peca(
      nome: 'Filtro de Óleo',
      fabricante: 'Fram',
      preco: 45.90,
      quantidade: 2,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeEo87DMZNXTry7BKD9XsCP9mMI55jsulOYcm8lOcxEA&s=10',
    ));
    estoque.adicionar(Peca(
      nome: 'Amortecedor Dianteiro',
      fabricante: 'Monroe',
      preco: 325.50,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLs4wIJkCZEONQnh1g0DYnfdt6DusoaW4fTUUdU_2IQA&s=10',
    ));
    // Ex 2: subclasse criada com extends — entra na mesma List<Peca>.
    estoque.adicionar(PecaPerformance(
      nome: 'Filtro Esportivo',
      fabricante: 'K&N',
      preco: 699.90,
      ganhoCavalos: 5,
      material: 'Algodão',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR60o0MPwdL6edFU8lXsb6L6OfA8xcegjqyCABhAVLWdA&s=10',
    ));
    estoque.adicionar(Peca(
      nome: 'Vela de Ignição',
      fabricante: 'NGK',
      preco: 34.90,
      quantidade: 4,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTloQwUBD1NNAvwbAopfGiOZ1ryG6Z2QFiO6HF0L9BAmA&s',
    ));
    estoque.adicionar(PecaPerformance(
      nome: 'Escape Dimensionado',
      fabricante: 'Luzian',
      preco: 829.90,
      ganhoCavalos: 12,
      material: 'Inox',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRitp_c4OVYmhq69mXOZT_c4zEOjvLRcdd3otjzcp4vA&s=10',
    ));
  }

  int get _totalUnidades =>
      estoque.pecas.fold<int>(0, (soma, p) => soma + p.quantidade);

  void _avisar(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensagem), duration: const Duration(seconds: 2)),
      );
  }

  // Ex 8: navegação passando o objeto pelo construtor da tela de destino.
  void _abrirDetalhes(Peca peca) async {
    final resultado = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => DetalhePage(peca: peca)),
    );

    // A tela de detalhe devolve a ação escolhida (excluir ou editar).
    if (resultado is Map && mounted) {
      if (resultado['action'] == 'delete') {
        setState(() => estoque.remover(peca));
        _avisar('${peca.nome} removida do estoque.');
      } else if (resultado['action'] == 'edit') {
        setState(() => estoque.atualizar(peca, resultado['peca']));
        _avisar('${resultado['peca'].nome} atualizada.');
      }
    }
  }

  void _abrirCadastro() async {
    final novaPeca = await Navigator.of(context).push<Peca>(
      MaterialPageRoute(builder: (context) => const CadastroPage()),
    );
    // Ex 10: setState avisa o Flutter de que o estado mudou. Sem ele, a peça
    // entra na lista do Estoque mas a tela continua mostrando seis itens.
    if (novaPeca != null && mounted) {
      setState(() => estoque.adicionar(novaPeca));
      _avisar('${novaPeca.nome} adicionada ao estoque.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    // Ex 5: Scaffold com AppBar personalizada.
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        titleSpacing: 20,
        title: Row(
          children: [
            const _MarcaLogo(),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Auto Performance',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: context.textStrong,
                  ),
                ),
                Text(
                  estoque.categoria,
                  style: TextStyle(fontSize: 12, color: context.textMuted),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 21,
            ),
            tooltip: isDark ? 'Usar tema claro' : 'Usar tema escuro',
            onPressed: () {
              MyApp.themeNotifier.value =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
          const SizedBox(width: 12),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: context.hairline, height: 1),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          // Ex 5: Column com os dois alinhamentos declarados.
          // mainAxisAlignment = eixo vertical (a Column empilha de cima
          // para baixo). crossAxisAlignment = eixo horizontal: stretch faz
          // os filhos ocuparem toda a largura disponível.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ex 4: o valor vem do getter calculado do Estoque.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _PainelEstoque(
                  valorTotal: estoque.valorTotal,
                  itens: estoque.quantidadeItens,
                  unidades: _totalUnidades,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
                child: Text(
                  'Peças cadastradas',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: context.textMuted,
                  ),
                ),
              ),
              // Ex 7: ListView.builder dentro de Expanded.
              // Sem o Expanded, a ListView e a Column disputam altura
              // infinita no mesmo eixo e o Flutter lança "unbounded height".
              Expanded(
                child: estoque.quantidadeItens == 0
                    ? _ListaVazia(onAdicionar: _abrirCadastro)
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                        // itemCount e itemBuilder alimentados pelo Estoque.
                        itemCount: estoque.quantidadeItens,
                        itemBuilder: (context, index) {
                          final peca = estoque.pecas[index];
                          return CartaoPeca(
                            peca: peca,
                            onTap: () => _abrirDetalhes(peca),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      // Ex 9 e 10: abre o cadastro e recebe a peça de volta.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastro,
        icon: const Icon(Icons.add, size: 20),
        label: const Text(
          'Nova peça',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// Logo da oficina. O quadrado tem tamanho fixo e a imagem usa
/// BoxFit.contain: ela se ajusta dentro do quadrado sem distorcer nem
/// ser cortada, qualquer que seja a proporção do PNG.
class _MarcaLogo extends StatelessWidget {
  const _MarcaLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/logo.png',
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        // Ícone de reserva se o asset não estiver declarado no pubspec.
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.speed_rounded, color: Colors.white, size: 22),
      ),
    );
  }
}

/// Painel escuro com a leitura principal do estoque (Ex 4).
/// É o único bloco de alto contraste da tela — o resto fica quieto.
class _PainelEstoque extends StatelessWidget {
  final double valorTotal;
  final int itens;
  final int unidades;

  const _PainelEstoque({
    required this.valorTotal,
    required this.itens,
    required this.unidades,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 3, color: AppColors.oxide),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Valor total em estoque',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'R\$',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      Formato.moeda(valorTotal),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _Leitura(rotulo: 'Peças', valor: '$itens'),
                    Container(
                      width: 1,
                      height: 28,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                    _Leitura(rotulo: 'Unidades', valor: '$unidades'),
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

class _Leitura extends StatelessWidget {
  final String rotulo;
  final String valor;

  const _Leitura({required this.rotulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          rotulo,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _ListaVazia extends StatelessWidget {
  final VoidCallback onAdicionar;
  const _ListaVazia({required this.onAdicionar});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 40, color: context.textMuted),
            const SizedBox(height: 14),
            Text(
              'Nenhuma peça no estoque',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.textStrong,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Cadastre a primeira peça para começar o controle.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: context.textMuted),
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: onAdicionar,
              child: const Text('Cadastrar peça'),
            ),
          ],
        ),
      ),
    );
  }
}
