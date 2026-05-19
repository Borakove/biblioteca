import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import 'constants.dart';

class UsuarioService {

  Future<Usuario?> login(String email, String senha) async {
    final url = Uri.parse(
      '$baseUrl/usuarios.php?acao=login&email=$email&senha=$senha',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    }
    return null; // login inválido
  }

  Future<String> cadastrar(String nome, String email, String senha) async {
    final url = Uri.parse(
      '$baseUrl/usuarios.php?acao=cadastrar&nome=$nome&email=$email&senha=$senha',
    );
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  Future<List<Usuario>> listar() async {
    final url = Uri.parse('$baseUrl/usuarios.php?acao=listar');
    final response = await http.get(url);
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => Usuario.fromJson(e)).toList();
  }
}