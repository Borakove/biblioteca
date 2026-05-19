import 'package:flutter/material.dart';
import '../../services/usuario_service.dart';
import '../../models/usuario.dart';
import 'cadastro_view.dart';
import '../home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _service = UsuarioService();
  String _mensagem = '';
  bool _carregando = false;

  Future<void> _login() async {
    setState(() {
      _carregando = true;
      _mensagem = '';
    });

    final Usuario? usuario = await _service.login(
      _emailController.text,
      _senhaController.text,
    );

    setState(() => _carregando = false);

    if (usuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeView(usuario: usuario)),
      );
    } else {
      setState(() => _mensagem = 'Email ou senha incorretos.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biblioteca')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              'Faça seu login',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            if (_mensagem.isNotEmpty)
              Text(_mensagem, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _senhaController,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _carregando ? null : _login,
                child: _carregando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Entrar'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CadastroView()),
              ),
              child: const Text('Não tem conta? Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}