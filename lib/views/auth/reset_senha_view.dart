import 'package:flutter/material.dart';
import '../../services/usuario_service.dart';

class ResetSenhaView extends StatefulWidget {
  const ResetSenhaView({super.key});

  @override
  State<ResetSenhaView> createState() => _ResetSenhaViewState();
}

class _ResetSenhaViewState extends State<ResetSenhaView> {
  final _emailController     = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarController = TextEditingController();
  final _service             = UsuarioService();
  String _mensagem           = '';
  bool _carregando           = false;
  bool _sucesso              = false;
  bool _senhaVisivel         = false;

  Future<void> _resetar() async {
    if (_emailController.text.trim().isEmpty ||
        _novaSenhaController.text.trim().isEmpty ||
        _confirmarController.text.trim().isEmpty) {
      setState(() => _mensagem = 'Preencha todos os campos.');
      return;
    }

    if (_novaSenhaController.text != _confirmarController.text) {
      setState(() => _mensagem = 'As senhas não coincidem.');
      return;
    }

    if (_novaSenhaController.text.length < 4) {
      setState(() => _mensagem = 'A senha deve ter pelo menos 4 caracteres.');
      return;
    }

    setState(() {
      _carregando = true;
      _mensagem   = '';
    });

    final resposta = await _service.resetarSenha(
      _emailController.text.trim(),
      _novaSenhaController.text.trim(),
    );

    setState(() {
      _carregando = false;
      _mensagem   = resposta;
      _sucesso    = resposta.contains('sucesso');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Redefinir Senha')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_reset, size: 60, color: Colors.blue),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Redefinir Senha',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Informe seu email e a nova senha.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),

                if (_mensagem.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: _sucesso ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _sucesso ? Colors.green.shade300 : Colors.red.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _sucesso ? Icons.check_circle_outline : Icons.error_outline,
                          color: _sucesso ? Colors.green.shade700 : Colors.red.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _mensagem,
                            style: TextStyle(
                              color: _sucesso ? Colors.green.shade800 : Colors.red.shade800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email cadastrado',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _novaSenhaController,
                  obscureText: !_senhaVisivel,
                  decoration: InputDecoration(
                    labelText: 'Nova senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_senhaVisivel ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmarController,
                  obscureText: !_senhaVisivel,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar nova senha',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _carregando ? null : _resetar,
                    child: _carregando
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text('Redefinir Senha', style: TextStyle(fontSize: 16)),
                  ),
                ),
                if (_sucesso)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Voltar para o login'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}