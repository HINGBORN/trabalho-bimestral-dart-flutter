import 'package:flutter/material.dart';
import '../models/peca.dart';

class CadastroPage extends StatefulWidget {
  final Peca? pecaParaEditar;

  const CadastroPage({super.key, this.pecaParaEditar});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  // Ex 9: Controladores
  final _nomeController = TextEditingController();
  final _fabricanteController = TextEditingController();
  final _precoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Se for edição, pré-carrega os valores
    if (widget.pecaParaEditar != null) {
      _nomeController.text = widget.pecaParaEditar!.nome;
      _fabricanteController.text = widget.pecaParaEditar!.fabricante;
      _precoController.text = widget.pecaParaEditar!.preco.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _fabricanteController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.pecaParaEditar != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Peça' : 'Nova Peça', style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),
            padding: const EdgeInsets.all(24.0),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEditing ? 'Atualize os dados da peça' : 'Preencha os dados da peça',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome da Peça',
                    prefixIcon: const Icon(Icons.build_circle_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fabricanteController,
                  decoration: InputDecoration(
                    labelText: 'Fabricante',
                    prefixIcon: const Icon(Icons.business_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _precoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Preço Unitário (R\$)',
                    prefixIcon: const Icon(Icons.attach_money_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E1E1E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    icon: Icon(isEditing ? Icons.save_outlined : Icons.check),
                    label: Text(
                      isEditing ? 'Salvar Alterações' : 'Confirmar Cadastro',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      final precoParsed = double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0.0;
                      final pecaFinal = Peca(
                        nome: _nomeController.text.trim().isEmpty ? 'Peça Sem Nome' : _nomeController.text,
                        fabricante: _fabricanteController.text.trim().isEmpty ? 'Genérico' : _fabricanteController.text,
                        preco: precoParsed,
                        // Mantém quantidade e foto originais se estiver editando
                        quantidade: widget.pecaParaEditar?.quantidade ?? 1,
                        imageUrl: widget.pecaParaEditar?.imageUrl ??
                            'https://images.unsplash.com/photo-1580273916550-e323be2ae537?q=80&w=400&auto=format&fit=crop',
                      );
                      Navigator.of(context).pop(pecaFinal);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}