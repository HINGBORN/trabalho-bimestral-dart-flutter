import 'dart:convert';
import 'dart:typed_data';

import '../models/peca.dart';

/// Monta a URL de uma imagem a partir do nome digitado da peça.
///
/// Não é uma busca de verdade (isso exigiria chave de API e requisição
/// HTTP): é um serviço que devolve uma imagem direto pela URL, gerada a
/// partir do texto. Como o Image.network já sabe baixar uma URL, nenhum
/// pacote novo precisa entrar no pubspec.
class ImagemPeca {
  const ImagemPeca._();

  static bool isDataUrl(String valor) => valor.startsWith('data:image/');

  static Uint8List bytesFromDataUrl(String valor) {
    final separador = valor.indexOf(',');
    if (separador == -1) return Uint8List(0);
    return base64Decode(valor.substring(separador + 1));
  }

  /// Devolve a URL da imagem correspondente ao nome.
  /// Nome vazio cai na imagem padrão da Peca.
  static String urlPara(String nome) {
    final limpo = nome.trim();
    if (limpo.isEmpty) return Peca.imagemPadrao;

    // O texto vai dentro da URL, então precisa ser codificado:
    // espaços e acentos viram %20, %C3%B3 etc.
    final descricao = Uri.encodeComponent(
      'foto de produto de $limpo, peça automotiva, fundo branco',
    );

    // A seed fixa pelo nome faz a mesma peça devolver sempre a mesma
    // imagem. Sem ela, cada reconstrução da tela traria uma foto
    // diferente e a lista ficaria piscando.
    final seed = limpo.toLowerCase().hashCode.abs() % 100000;

    return 'https://image.pollinations.ai/prompt/$descricao'
        '?width=400&height=300&seed=$seed&nologo=true';
  }

  /// Alternativa com fotos reais do Flickr, em vez de imagem gerada.
  /// Troque a chamada em urlPara se preferir este resultado — devolve
  /// fotos de verdade, mas às vezes pouco relacionadas ao termo.
  static String urlFlickr(String nome) {
    final termos = nome
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((p) => p.length > 2)
        .join(',');
    if (termos.isEmpty) return Peca.imagemPadrao;
    final lock = nome.toLowerCase().hashCode.abs() % 100000;
    return 'https://loremflickr.com/400/300/$termos,autopart?lock=$lock';
  }
}