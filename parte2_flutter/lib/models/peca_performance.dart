import 'peca.dart';

class PecaPerformance extends Peca {
  final int ganhoCavalos;
  final String material;

  PecaPerformance({
    required super.nome,
    required super.fabricante,
    required super.preco,
    super.quantidade,
    super.imageUrl, // Permite receber foto
    required this.ganhoCavalos,
    required this.material,
  });

  @override
  String ficha() {
    return "${super.ficha()} | +${ganhoCavalos}cv | Material: $material";
  }
}