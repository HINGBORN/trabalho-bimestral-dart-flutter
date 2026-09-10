import 'models/peca.dart';
import 'models/peca_performance.dart';
import 'models/estoque.dart';

void main() {
  // Configurando os objetos
  final pastilha = Peca(nome: 'Pastilha de Freio', fabricante: 'Cobreq', preco: 89.90, quantidade: 4);
  final filtroAr = Peca(nome: 'Filtro de Ar', fabricante: 'Fram', preco: 35.00);
  final escapeInox = PecaPerformance(
    nome: 'Escapamento Dimensionado', 
    fabricante: 'Luzian', 
    preco: 850.00, 
    ganhoCavalos: 12, 
    material: 'Inox'
  );

  final estoque = Estoque(categoria: 'Performance e Reposição');
  estoque.adicionar(pastilha);
  estoque.adicionar(filtroAr);

  // ===== [1] ENTIDADE PRINCIPAL =====
  print("===== [1] ENTIDADE PRINCIPAL =====");
  print(pastilha.ficha());
  print("");

  // ===== [2] HERANÇA =====
  print("===== [2] HERANÇA =====");
  print("Peca comum -> ficha: ${filtroAr.ficha()}");
  print("PecaPerformance -> ficha: ${escapeInox.ficha()}");
  print("");

  // ===== [3] COMPOSIÇÃO =====
  print("===== [3] COMPOSIÇÃO =====");
  print("Estoque '${estoque.categoria}' contém ${estoque.quantidadeItens} peças:");
  for (var p in estoque.pecas) {
    print("  - ${p.nome}");
  }
  print("");

  // ===== [4] ENCAPSULAMENTO =====
  print("===== [4] ENCAPSULAMENTO =====");
  print("Estoque -> valor total (calculado): R\$ ${estoque.valorTotal.toStringAsFixed(2)}");
  estoque.adicionar(escapeInox);
  print("Após adicionar '${escapeInox.nome}' (R\$ 850.00): R\$ ${estoque.valorTotal.toStringAsFixed(2)}");
}