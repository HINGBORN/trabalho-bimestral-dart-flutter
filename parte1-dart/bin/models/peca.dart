class Peca {
  final String nome;
  final String fabricante;
  final double preco;
  final int quantidade;
  final DateTime dataCadastro;
  final String imageUrl;

  Peca({
    required this.nome,
    required this.fabricante,
    required this.preco,
    this.quantidade = 1,
    DateTime? dataCadastro,
    this.imageUrl = 'https://images.unsplash.com/photo-1580273916550-e323be2ae537?q=80&w=400&auto=format&fit=crop',
  }) : dataCadastro = dataCadastro ?? DateTime.now();

  String ficha() {
    return "$nome ($fabricante) - R\$ ${preco.toStringAsFixed(2)} - Qtd: $quantidade - Cadastrado em: ${dataCadastro.day}/${dataCadastro.month}/${dataCadastro.year}";
  }
}