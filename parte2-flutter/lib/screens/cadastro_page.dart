import 'package:flutter/material.dart';
import '../models/peca.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  // Ex 9: Controladores
  final _nomeController = TextEditingController();
  final _fabricanteController = TextEditingController();
  final _precoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _fabricanteController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Peça')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome da peça',
                prefixIcon: const Icon(Icons.build),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fabricanteController,
              decoration: InputDecoration(
                labelText: 'Fabricante',
                prefixIcon: const Icon(Icons.factory),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _precoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Preço (R\$)',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final precoParsed = double.tryParse(_precoController.text) ?? 0.0;
                final novaPeca = Peca(
                  nome: _nomeController.text,
                  fabricante: _fabricanteController.text,
                  preco: precoParsed,
                );
                // Devolve a peça recém criada para a tela anterior
                Navigator.of(context).pop(novaPeca);
              },
              child: const Text('Confirmar Cadastro'),
            )
          ],
        ),
      ),
    );
  }
}