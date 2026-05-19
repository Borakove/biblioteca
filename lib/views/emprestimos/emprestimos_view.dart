import 'package:flutter/material.dart';
import '../../models/emprestimo.dart';
import '../../models/usuario.dart';
import '../../services/emprestimo_service.dart';

class EmprestimosView extends StatefulWidget {
  final Usuario usuario;
  const EmprestimosView({super.key, required this.usuario});

  @override
  State<EmprestimosView> createState() => _EmprestimosViewState();
}

class _EmprestimosViewState extends State<EmprestimosView> {
  final _service          = EmprestimoService();
  List<Emprestimo> _lista = [];
  bool _carregando        = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final lista = await _service.listarPorUsuario(widget.usuario.id);
    setState(() {
      _lista      = lista;
      _carregando = false;
    });
  }

  Future<void> _devolver(int id) async {
    final resposta = await _service.devolver(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resposta)));
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return _carregando
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
      onRefresh: _carregar,
      child: _lista.isEmpty
          ? const Center(child: Text('Nenhum empréstimo ativo.'))
          : ListView.builder(
        itemCount: _lista.length,
        itemBuilder: (context, i) {
          final e = _lista[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(
                e.devolvido ? Icons.check_circle : Icons.swap_horiz,
                color: e.devolvido ? Colors.green : Colors.orange,
              ),
              title: Text('Livro #${e.livroId}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                'Empréstimo: ${e.dataEmprestimo}\nDevolução: ${e.dataDevolucao}',
              ),
              isThreeLine: true,
              trailing: !e.devolvido
                  ? FilledButton(
                onPressed: () => _devolver(e.id),
                child: const Text('Devolver'),
              )
                  : const Chip(label: Text('Devolvido')),
            ),
          );
        },
      ),
    );
  }
}