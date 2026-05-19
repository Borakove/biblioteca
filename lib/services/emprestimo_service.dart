import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/emprestimo.dart';
import 'constants.dart';

class EmprestimoService {

  Future<List<Emprestimo>> listar() async {
    final url = Uri.parse('$baseUrl/emprestimos.php?acao=listar');
    final response = await http.get(url);
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => Emprestimo.fromJson(e)).toList();
  }

  Future<List<Emprestimo>> listarPorUsuario(int usuarioId) async {
    final url = Uri.parse(
      '$baseUrl/emprestimos.php?acao=listarPorUsuario&usuario_id=$usuarioId',
    );
    final response = await http.get(url);
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => Emprestimo.fromJson(e)).toList();
  }

  Future<String> inserir(int usuarioId, int livroId, String dataDevolucao) async {
    final url = Uri.parse(
      '$baseUrl/emprestimos.php?acao=inserir'
          '&usuario_id=$usuarioId'
          '&livro_id=$livroId'
          '&data_devolucao=$dataDevolucao',
    );
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  Future<String> devolver(int id) async {
    final url = Uri.parse('$baseUrl/emprestimos.php?acao=devolver&id=$id');
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }
}