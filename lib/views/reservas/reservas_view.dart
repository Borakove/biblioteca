import 'package:flutter/material.dart';
import '../../models/reserva.dart';
import '../../models/usuario.dart';
import '../../services/reserva_service.dart';

class ReservasView extends StatefulWidget {
  final Usuario usuario;
  const ReservasView({super.key, required this.usuario});

  @override
  State<ReservasView> createState() => _ReservasViewState();
}

class _ReservasViewState extends State<ReservasView> {
  final _service       = ReservaService();
  List<Reserva> _lista = [];
  bool _carregando     = true;

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

  Future<void> _cancelar(int id) async {
    final resposta = await _service.atualizarStatus(id, 'cancelada');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resposta)));
    _carregar();
  }

  Color _corStatus(String status) {
    switch (status) {
      case 'confirmada': return Colors.green;
      case 'cancelada':  return Colors.red;
      default:           return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _carregando
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
      onRefresh: _carregar,
      child: _lista.isEmpty
          ? const Center(child: Text('Nenhuma reserva encontrada.'))
          : ListView.builder(
        itemCount: _lista.length,
        itemBuilder: (context, i) {
          final r = _lista[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(Icons.bookmark, color: _corStatus(r.status)),
              title: Text('Livro #${r.livroId}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Reservado em: ${r.dataReserva}'),
              trailing: r.status == 'pendente'
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Chip(
                    label: Text(r.status),
                    backgroundColor: _corStatus(r.status).withOpacity(0.2),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _cancelar(r.id),
                    child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
                  ),
                ],
              )
                  : Chip(
                label: Text(r.status),
                backgroundColor: _corStatus(r.status).withOpacity(0.2),
              ),
            ),
          );
        },
      ),
    );
  }
}