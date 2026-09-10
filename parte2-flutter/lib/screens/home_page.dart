import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text('Catálogo de Peças', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dashboard de Valor Total
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
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
              // Lista de Peças
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
                      child: CartaoPeca(peca: peca),
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