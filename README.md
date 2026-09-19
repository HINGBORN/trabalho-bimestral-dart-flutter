<p align="center">
  <img src="logo.png" alt="Logo Catálogo de Peças" width="260">
</p>

# Trabalho do 1º Bimestre — Programação para Dispositivos Móveis

**Integrantes:** Arthur Beraldo Pelais Dos Santos RA: 252349-2024, Pedro Lucas de Jesus Fonseca RA: 273433-2024  
**Turma:** 4º ESW A  
**Professor:** Me. Gustavo Meneghetti Arcolezi  
**Tema / Domínio:** Gerenciamento de Estoque de Peças Automotivas e Performance  

---

### Descrição do Domínio
O sistema gerencia o estoque de peças de uma oficina e loja de autopeças. O domínio é estruturado a partir da entidade individual `Peca` (que possui como especialização `PecaPerformance`) e da entidade agrupadora `Estoque`, responsável por organizar e quantificar as peças cadastradas.

### Justificativa da Modelagem (Composição vs. Herança)
* A relação entre `Estoque` e `Peca` é de **composição ("tem um")**, pois um estoque não é uma peça de reposição, mas sim um contêiner que agrega e gerencia uma lista interna de peças (`List<Peca>`).
* A relação entre `PecaPerformance` e `Peca` é de **herança ("é um")**, pois toda peça de performance é, essencialmente, uma peça de reposição, herdando suas propriedades e especializando seu comportamento com acréscimo de ganho de cavalaria (`ganhoCavalos`) e especificação de liga (`material`).

---

## Tabela de Rastreio

| # | Exercício | Arquivo e linha | O que aparece na tela |
|---|---|---|---|
| 1 | Entidade principal | `parte1-dart/bin/models/peca.dart:4` | Bloco `[1]` do relatório no terminal |
| 2 | Herança | `parte1-dart/bin/models/peca_performance.dart:3` | Bloco `[2]` do relatório no terminal |
| 3 | Composição | `parte1-dart/bin/models/estoque.dart:3` | Bloco `[3]` do relatório no terminal |
| 4 | Encapsulamento | `parte1-dart/bin/models/estoque.dart:28` | Bloco `[4]` no terminal e valor total no topo da tela inicial |
| 5 | Estrutura de tela | `parte2-flutter/lib/screens/home_page.dart:124` | AppBar personalizada e corpo organizado em Column |
| 6 | Cartão | `parte2-flutter/lib/widgets/cartao_peca.dart:22` | Cada item estilizado com Container e BoxDecoration |
| 7 | Lista | `parte2-flutter/lib/screens/home_page.dart:206` | ListView.builder rolável inicializada com 6 itens |
| 8 | Navegação | `parte2-flutter/lib/screens/home_page.dart:89` | Toque no item abre a tela com detalhes exclusivos |
| 9 | Formulário | `parte2-flutter/lib/screens/cadastro_page.dart:245` | Tela de cadastro com 3 campos e TextEditingController |
| 10 | Estado | `parte2-flutter/lib/screens/home_page.dart:113` | setState adiciona o novo item e recalcula o total |

## Recursos adicionais

Além dos 10 exercícios, o aplicativo também possui:

- cadastro e edição de peças com nome, fabricante e preço;
- troca da imagem por uma URL externa;
- seleção de imagem do próprio dispositivo pelo botão de pasta;
- exibição de imagens locais na prévia, na lista e na tela de detalhes;
- fallback HTML para imagens externas que possuem restrições de CORS no Flutter Web;
- seleção de arquivos feita pelo pacote `file_selector`;
- correção do fechamento do diálogo com `Esc`, sem reutilizar um `TextEditingController` descartado.

### Imagens do dispositivo

Ao escolher uma imagem pelo botão de pasta, o arquivo é armazenado
temporariamente em memória. No Flutter Web, é usado o `blob:` URL fornecido
pelo navegador; nas plataformas nativas, a imagem é convertida para uma
`data:` URL. Por isso, a imagem fica disponível durante a execução do
aplicativo, mas ainda não é persistida após fechar ou reiniciar o app.

Para executar a parte Flutter:

```bash
cd parte2-flutter
flutter pub get
flutter run -d chrome
```
