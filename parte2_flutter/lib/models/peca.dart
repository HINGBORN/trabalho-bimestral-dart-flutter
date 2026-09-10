class Peca {
  final String nome;
  final String fabricante;
  final double preco;
  final int quantidade;
  final String imageUrl;

  Peca({
    required this.nome,
    required this.fabricante,
    required this.preco,
    this.quantidade = 1,
    // Se não passarmos a URL (como no cadastro), ele usa essa imagem genérica de motor:
    this.imageUrl = 'https://images.unsplash.com/photo-1580273916550-e323be2ae537?q=80&w=400&auto=format&fit=crop',
  });

  String ficha() {
    return "$nome ($fabricante) - R\$ ${preco.toStringAsFixed(2)} - Qtd: $quantidade";
  }
}