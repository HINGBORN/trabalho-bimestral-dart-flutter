import 'peca.dart';

class Estoque {
  final String categoria;
  final List<Peca> _pecas = []; // Ex 4: Atributo privado

  Estoque({required this.categoria});

  // Ex 3: Método para adicionar
  void adicionar(Peca peca) {
    _pecas.add(peca);
  }

  // Novo: Método para remover
  void remover(Peca peca) {
    _pecas.remove(peca);
  }

  // Novo: Método para atualizar
  void atualizar(Peca pecaAntiga, Peca pecaNova) {
    final index = _pecas.indexOf(pecaAntiga);
    if (index != -1) {
      _pecas[index] = pecaNova;
    }
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