import 'peca.dart';

class Estoque {
  final String categoria;
  final List<Peca> _pecas = []; // Ex 4: Atributo privado

  Estoque({required this.categoria});

  // Ex 3: Método para adicionar
  void adicionar(Peca peca) {
    _pecas.add(peca);
  }

  // Getter para expor a lista de forma segura (usado na Parte 2)
  List<Peca> get pecas => _pecas;

  int get quantidadeItens => _pecas.length;

  // Ex 4: Get que devolve um valor calculado (não é guardado numa variável)
  double get valorTotal {
    double total = 0;
    for (var peca in _pecas) {
      total += peca.preco * peca.quantidade;
    }
    return total;
  }
}