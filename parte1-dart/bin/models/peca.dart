/// Ex 1: entidade principal do domínio.
/// Recurso: class com construtor de parâmetros nomeados.
/// Conceito: `required` nos campos obrigatórios, padrão nos opcionais.
class Peca {
  // Imagem usada quando nenhuma é informada. Fica em uma constante
  // nomeada para não repetir a URL em outros arquivos.
  static const String imagemPadrao =
      'https://images.unsplash.com/photo-1580273916550-e323be2ae537?q=80&w=400&auto=format&fit=crop';

  final String nome; // 1: String
  final String fabricante;
  final double preco; // 2: double
  final int quantidade; // 3: int
  final DateTime dataCadastro; // 4: DateTime
  final String imageUrl;

  Peca({
    required this.nome,
    required this.fabricante,
    required this.preco,
    this.quantidade = 1,
    DateTime? dataCadastro,
    this.imageUrl = imagemPadrao,
  }) : dataCadastro = dataCadastro ?? DateTime.now();

  String ficha() {
    return "$nome ($fabricante) - R\$ ${preco.toStringAsFixed(2)} - Qtd: $quantidade";
  }
}
