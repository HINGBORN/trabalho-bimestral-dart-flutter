import 'peca.dart';

class Estoque {
  final String categoria;
  final List<Peca> _pecas = []; // Ex 4: Atributo privado

  Estoque({required this.categoria});

  // Ex 3: Adicionar
  void adicionar(Peca peca) {
    _pecas.add(peca);
  }

  // Remover
  void remover(Peca peca) {
    _pecas.remove(peca);
  }

  // Atualizar
  void atualizar(Peca pecaAntiga, Peca pecaNova) {
    final index = _pecas.indexOf(pecaAntiga);
    if (index != -1) {
      _pecas[index] = pecaNova;
    }
  }

  List<Peca> get pecas => _pecas;

  int get quantidadeItens => _pecas.length;

  // Ex 4: Getter calculado
  double get valorTotal {
    double total = 0;
    for (var peca in _pecas) {
      total += peca.preco * peca.quantidade;
    }
    return total;
  }
}