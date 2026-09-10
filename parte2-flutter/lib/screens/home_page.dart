import 'package:flutter/material.dart';
import '../main.dart';
import '../models/peca.dart';
import '../models/peca_performance.dart';
import '../models/estoque.dart';
import '../widgets/cartao_peca.dart';
import 'detalhe_page.dart';
import 'cadastro_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Estoque estoque = Estoque(categoria: "Reposição Automotiva");

  @override
  void initState() {
    super.initState();
    estoque.adicionar(Peca(
      nome: 'Pastilha de Freio', 
      fabricante: 'Cobreq', 
      preco: 116.90,
      quantidade: 4, 
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdaTJUIt56vaZnr7a2wMSh6M9GRtFh_A0PEpiZBmPvmw&s=10'
    ));
    estoque.adicionar(Peca(
      nome: 'Filtro de Óleo', 
      fabricante: 'Fram', 
      preco: 45.90,
      quantidade: 2, 
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeEo87DMZNXTry7BKD9XsCP9mMI55jsulOYcm8lOcxEA&s=10'
    ));
    estoque.adicionar(Peca(
      nome: 'Amortecedor Dianteiro', 
      fabricante: 'Monroe', 
      preco: 325.50,
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLs4wIJkCZEONQnh1g0DYnfdt6DusoaW4fTUUdU_2IQA&s=10'
    ));
    estoque.adicionar(PecaPerformance(
      nome: 'Filtro Esportivo', 
      fabricante: 'K&N', 
      preco: 699.90,
      ganhoCavalos: 5, 
      material: 'Algodão', 
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR60o0MPwdL6edFU8lXsb6L6OfA8xcegjqyCABhAVLWdA&s=10'
    ));
    estoque.adicionar(Peca(
      nome: 'Vela de Ignição', 
      fabricante: 'NGK', 
      preco: 34.90,
      quantidade: 4, 
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTloQwUBD1NNAvwbAopfGiOZ1ryG6Z2QFiO6HF0L9BAmA&s'
    ));
    estoque.adicionar(PecaPerformance(
      nome: 'Escape Dimensionado', 
      fabricante: 'Luzian', 
      preco: 829.90,
      ganhoCavalos: 12, 
      material: 'Inox', 
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRitp_c4OVYmhq69mXOZT_c4zEOjvLRcdd3otjzcp4vA&s=10'
    ));
  }

  void _editarPeca(Peca pecaAntiga) async {
    final pecaEditada = await Navigator.of(context).push<Peca>(
      MaterialPageRoute(builder: (context) => CadastroPage(pecaParaEditar: pecaAntiga)),
    );
    if (pecaEditada != null) {
      setState(() {
        estoque.atualizar(pecaAntiga, pecaEditada);
      });
    }
  }

  void _excluirPeca(Peca peca) {
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
              setState(() {
                estoque.remover(peca);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${peca.nome} removida com sucesso!'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Ex 5: AppBar Personalizada
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: const Color(0xFF1E1E1E),
        title: Row(
          children: [
            // Ícone estilizado com fundo arredondado
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.speed_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            // Título e Subtítulo profissional
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AUTO PERFORMANCE',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white54,
                  ),
                ),
                Text(
                  'Catálogo de Peças',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Badge com contador dinâmico de itens
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.inventory_2_outlined, size: 16, color: Colors.white70),
                const SizedBox(width: 6),
                Text(
                  '${estoque.quantidadeItens} itens',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Botão de alternar tema
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            tooltip: isDark ? 'Modo Claro' : 'Modo Escuro',
            onPressed: () {
              MyApp.themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
          const SizedBox(width: 8),
        ],
        // Linha sutil na borda inferior da AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08),
            height: 1,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dashboard de Valor Total (Ex 4 e Ex 5)
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('VALOR TOTAL EM ESTOQUE', style: TextStyle(color: Colors.grey, fontSize: 13, letterSpacing: 1.2)),
                    const SizedBox(height: 8),
                    Text(
                      'R\$ ${estoque.valorTotal.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // Lista de Peças (Ex 7)
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: estoque.quantidadeItens,
                  itemBuilder: (context, index) {
                    final peca = estoque.pecas[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => DetalhePage(peca: peca)),
                        );
                      },
                      child: CartaoPeca(
                        peca: peca,
                        onEditar: () => _editarPeca(peca),
                        onExcluir: () => _excluirPeca(peca),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final novaPeca = await Navigator.of(context).push<Peca>(
            MaterialPageRoute(builder: (context) => const CadastroPage()),
          );
          if (novaPeca != null) {
            setState(() {
              estoque.adicionar(novaPeca);
            });
          }
        },
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nova Peça'),
      ),
    );
  }
}