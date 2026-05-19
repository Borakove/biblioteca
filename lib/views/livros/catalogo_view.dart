import 'package:flutter/material.dart';
import '../../models/livro.dart';
import '../../models/usuario.dart';
import '../../services/livro_service.dart';
import '../../services/reserva_service.dart';

class CatalogoView extends StatefulWidget {
  final Usuario usuario;
  const CatalogoView({super.key, required this.usuario});

  @override
  State<CatalogoView> createState() => _CatalogoViewState();
}

class _CatalogoViewState extends State<CatalogoView> {
  final _livroService   = LivroService();
  final _reservaService = ReservaService();
  List<Livro> _livros   = [];
  List<Livro> _filtrados = [];
  bool _carregando      = true;
  final _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final livros = await _livroService.listar();
    setState(() {
      _livros    = livros;
      _filtrados = livros;
      _carregando = false;
    });
  }

  void _filtrar(String termo) {
    setState(() {
      _filtrados = _livros.where((l) =>
      l.titulo.toLowerCase().contains(termo.toLowerCase()) ||
          l.autor.toLowerCase().contains(termo.toLowerCase())
      ).toList();
    });
  }

  Future<void> _reservar(Livro livro) async {
    final resposta = await _reservaService.inserir(widget.usuario.id, livro.id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resposta)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _buscaController,
            onChanged: _filtrar,
            decoration: const InputDecoration(
              labelText: 'Buscar livro ou autor',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _carregando
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
            onRefresh: _carregar,
            child: ListView.builder(
              itemCount: _filtrados.length,
              itemBuilder: (context, i) {
                final livro = _filtrados[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.menu_book, color: Colors.blue),
                    title: Text(livro.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${livro.autor} • ${livro.ano}\nDisponíveis: ${livro.quantidade}'),
                    isThreeLine: true,
                    trailing: livro.quantidade > 0
                        ? FilledButton(
                      onPressed: () => _reservar(livro),
                      child: const Text('Reservar'),
                    )
                        : const Chip(label: Text('Indisponível')),
                    onTap: () => _mostrarDetalhes(livro),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _mostrarDetalhes(Livro livro) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(livro.titulo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Autor: ${livro.autor}'),
            Text('Ano: ${livro.ano}'),
            Text('ISBN: ${livro.isbn}'),
            Text('Disponíveis: ${livro.quantidade}'),
            const SizedBox(height: 12),
            Text(livro.sinopse),
          ],
        ),
      ),
    );
  }
}