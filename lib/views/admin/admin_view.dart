import 'package:flutter/material.dart';
import '../../models/livro.dart';
import '../../models/emprestimo.dart';
import '../../models/reserva.dart';
import '../../services/livro_service.dart';
import '../../services/emprestimo_service.dart';
import '../../services/reserva_service.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _livroService     = LivroService();
  final _emprestimoService = EmprestimoService();
  final _reservaService   = ReservaService();

  List<Livro>      _livros      = [];
  List<Emprestimo> _emprestimos = [];
  List<Reserva>    _reservas    = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _carregar();
  }

  Future<void> _carregar() async {
    final livros      = await _livroService.listar();
    final emprestimos = await _emprestimoService.listar();
    final reservas    = await _reservaService.listar();
    setState(() {
      _livros      = livros;
      _emprestimos = emprestimos;
      _reservas    = reservas;
      _carregando  = false;
    });
  }

  void _abrirFormLivro({Livro? livro}) {
    final tituloCtrl    = TextEditingController(text: livro?.titulo ?? '');
    final autorCtrl     = TextEditingController(text: livro?.autor ?? '');
    final isbnCtrl      = TextEditingController(text: livro?.isbn ?? '');
    final anoCtrl       = TextEditingController(text: livro?.ano.toString() ?? '');
    final qtdCtrl       = TextEditingController(text: livro?.quantidade.toString() ?? '1');
    final sinopseCtrl   = TextEditingController(text: livro?.sinopse ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(livro == null ? 'Novo Livro' : 'Editar Livro',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: tituloCtrl,  decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            TextField(controller: autorCtrl,   decoration: const InputDecoration(labelText: 'Autor', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            TextField(controller: isbnCtrl,    decoration: const InputDecoration(labelText: 'ISBN', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: TextField(controller: anoCtrl, decoration: const InputDecoration(labelText: 'Ano', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: qtdCtrl, decoration: const InputDecoration(labelText: 'Qtd', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
            ]),
            const SizedBox(height: 8),
            TextField(controller: sinopseCtrl, decoration: const InputDecoration(labelText: 'Sinopse', border: OutlineInputBorder()), maxLines: 3),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  final novoLivro = Livro(
                    id:         livro?.id ?? 0,
                    titulo:     tituloCtrl.text,
                    autor:      autorCtrl.text,
                    isbn:       isbnCtrl.text,
                    ano:        int.tryParse(anoCtrl.text) ?? 0,
                    quantidade: int.tryParse(qtdCtrl.text) ?? 1,
                    sinopse:    sinopseCtrl.text,
                  );
                  if (livro == null) {
                    await _livroService.inserir(novoLivro);
                  } else {
                    await _livroService.atualizar(novoLivro);
                  }
                  Navigator.pop(context);
                  _carregar();
                },
                child: Text(livro == null ? 'Cadastrar' : 'Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Livros'),
            Tab(text: 'Empréstimos'),
            Tab(text: 'Reservas'),
          ],
        ),
        Expanded(
          child: _carregando
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
            controller: _tabController,
            children: [
              // ABA LIVROS
              Stack(
                children: [
                  ListView.builder(
                    itemCount: _livros.length,
                    itemBuilder: (_, i) {
                      final l = _livros[i];
                      return ListTile(
                        title: Text(l.titulo),
                        subtitle: Text(l.autor),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _abrirFormLivro(livro: l)),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await _livroService.deletar(l.id);
                                _carregar();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 16, right: 16,
                    child: FloatingActionButton(
                      onPressed: () => _abrirFormLivro(),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),

              // ABA EMPRÉSTIMOS
              ListView.builder(
                itemCount: _emprestimos.length,
                itemBuilder: (_, i) {
                  final e = _emprestimos[i];
                  return ListTile(
                    leading: Icon(e.devolvido ? Icons.check_circle : Icons.swap_horiz,
                        color: e.devolvido ? Colors.green : Colors.orange),
                    title: Text('Usuário #${e.usuarioId} — Livro #${e.livroId}'),
                    subtitle: Text('Devolução: ${e.dataDevolucao}'),
                    trailing: !e.devolvido
                        ? FilledButton(
                      onPressed: () async {
                        await _emprestimoService.devolver(e.id);
                        _carregar();
                      },
                      child: const Text('Devolver'),
                    )
                        : const Chip(label: Text('Devolvido')),
                  );
                },
              ),

              // ABA RESERVAS
              ListView.builder(
                itemCount: _reservas.length,
                itemBuilder: (_, i) {
                  final r = _reservas[i];
                  return ListTile(
                    leading: const Icon(Icons.bookmark, color: Colors.blue),
                    title: Text('Usuário #${r.usuarioId} — Livro #${r.livroId}'),
                    subtitle: Text('Status: ${r.status}'),
                    trailing: r.status == 'pendente'
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () async {
                            await _reservaService.atualizarStatus(r.id, 'confirmada');
                            _carregar();
                          },
                          child: const Text('Confirmar'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _reservaService.atualizarStatus(r.id, 'cancelada');
                            _carregar();
                          },
                          child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    )
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}