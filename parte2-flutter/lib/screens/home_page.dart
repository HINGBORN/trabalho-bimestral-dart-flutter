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
      preco: 116.90, // Atualizado
      quantidade: 4, 
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdaTJUIt56vaZnr7a2wMSh6M9GRtFh_A0PEpiZBmPvmw&s=10'
    ));
    estoque.adicionar(Peca(
      nome: 'Filtro de Óleo', 
      fabricante: 'Fram', 
      preco: 45.90, // Atualizado
      quantidade: 2, 
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeEo87DMZNXTry7BKD9XsCP9mMI55jsulOYcm8lOcxEA&s=10'
    ));
    estoque.adicionar(Peca(
      nome: 'Amortecedor Dianteiro', 
      fabricante: 'Monroe', 
      preco: 325.50, // Atualizado
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLs4wIJkCZEONQnh1g0DYnfdt6DusoaW4fTUUdU_2IQA&s=10'
    ));
    estoque.adicionar(PecaPerformance(
      nome: 'Filtro Esportivo', 
      fabricante: 'K&N', 
      preco: 699.90, // Atualizado (Valor real da marca K&N)
      ganhoCavalos: 5, 
      material: 'Algodão', 
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR60o0MPwdL6edFU8lXsb6L6OfA8xcegjqyCABhAVLWdA&s=10'
    ));
    estoque.adicionar(Peca(
      nome: 'Vela de Ignição', 
      fabricante: 'NGK', 
      preco: 34.90, // Atualizado (Valor unitário, totaliza ~R$ 140 nas 4)
      quantidade: 4, 
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTloQwUBD1NNAvwbAopfGiOZ1ryG6Z2QFiO6HF0L9BAmA&s'
    ));
    estoque.adicionar(PecaPerformance(
      nome: 'Escape Dimensionado', 
      fabricante: 'Luzian', 
      preco: 829.90, // Atualizado (Preço médio do abafador inox)
      ganhoCavalos: 12, 
      material: 'Inox', 
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRitp_c4OVYmhq69mXOZT_c4zEOjvLRcdd3otjzcp4vA&s=10'
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Fundo levemente cinza para destacar os cartões brancos
      appBar: AppBar(
        title: const Text('Catálogo de Peças', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E1E), // Appbar escura profissional
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dashboard de Valor Total
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const Text('Valor em Estoque', style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${estoque.valorTotal.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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