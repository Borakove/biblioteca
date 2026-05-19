import 'package:flutter/material.dart';
import '../../models/notificacao.dart';
import '../../models/usuario.dart';
import '../../services/notificacao_service.dart';

class NotificacoesView extends StatefulWidget {
  final Usuario usuario;
  const NotificacoesView({super.key, required this.usuario});

  @override
  State<NotificacoesView> createState() => _NotificacoesViewState();
}

class _NotificacoesViewState extends State<NotificacoesView> {
  final _service            = NotificacaoService();
  List<Notificacao> _lista  = [];
  bool _carregando          = true;

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

  Future<void> _marcarLida(int id) async {
    await _service.marcarLida(id);
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return _carregando
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
      onRefresh: _carregar,
      child: _lista.isEmpty
          ? const Center(child: Text('Nenhuma notificação.'))
          : ListView.builder(
        itemCount: _lista.length,
        itemBuilder: (context, i) {
          final n = _lista[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: n.lida ? null : Colors.blue.shade50,
            child: ListTile(
              leading: Icon(
                n.lida ? Icons.notifications_none : Icons.notifications_active,
                color: n.lida ? Colors.grey : Colors.blue,
              ),
              title: Text(n.mensagem),
              subtitle: Text(n.criadoEm),
              trailing: !n.lida
                  ? TextButton(
                onPressed: () => _marcarLida(n.id),
                child: const Text('Marcar lida'),
              )
                  : null,
            ),
          );
        },
      ),
    );
  }
}