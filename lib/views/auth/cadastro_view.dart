import 'package:flutter/material.dart';
import '../../services/usuario_service.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final _nomeController    = TextEditingController();
  final _emailController   = TextEditingController();
  final _senhaController   = TextEditingController();
  final _service           = UsuarioService();
  String _mensagem         = '';
  bool _carregando         = false;

  Future<void> _cadastrar() async {
    setState(() {
      _carregando = true;
      _mensagem   = '';
    });

    final resposta = await _service.cadastrar(
      _nomeController.text,
      _emailController.text,
      _senhaController.text,
    );

    setState(() {
      _carregando = false;
      _mensagem   = resposta;
    });

    if (resposta.contains('sucesso')) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_mensagem.isNotEmpty)
              Text(
                _mensagem,
                style: TextStyle(
                  color: _mensagem.contains('sucesso') ? Colors.green : Colors.red,
                ),
              ),
            const SizedBox(height: 8),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
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
                onPressed: _carregando ? null : _cadastrar,
                child: _carregando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Cadastrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}