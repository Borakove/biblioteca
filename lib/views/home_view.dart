import 'package:flutter/material.dart';
import '../models/usuario.dart';
import 'auth/login_view.dart';
import 'livros/catalogo_view.dart';
import 'emprestimos/emprestimos_view.dart';
import 'reservas/reservas_view.dart';
import 'notificacoes/notificacoes_view.dart';
import 'admin/admin_view.dart';

class HomeView extends StatefulWidget {
  final Usuario usuario;

  const HomeView({super.key, required this.usuario});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _abaSelecionada = 0;

  List<Widget> get _telas => [
    CatalogoView(usuario: widget.usuario),
    EmprestimosView(usuario: widget.usuario),
    ReservasView(usuario: widget.usuario),
    NotificacoesView(usuario: widget.usuario),
    if (widget.usuario.isAdmin) const AdminView(),
  ];

  List<BottomNavigationBarItem> get _itens => [
    const BottomNavigationBarItem(
      icon: Icon(Icons.book),
      label: 'Catálogo',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.swap_horiz),
      label: 'Empréstimos',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.bookmark),
      label: 'Reservas',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      label: 'Notificações',
    ),
    if (widget.usuario.isAdmin)
      const BottomNavigationBarItem(
        icon: Icon(Icons.admin_panel_settings),
        label: 'Admin',
      ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Olá, ${widget.usuario.nome.split(' ').first}!',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginView(),
              ),
                  (route) => false,
            ),
          ),
        ],
      ),
      body: _telas[_abaSelecionada],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _abaSelecionada,
        onTap: (i) => setState(() => _abaSelecionada = i),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: _itens,
      ),
    );
  }
}