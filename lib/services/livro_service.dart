import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/livro.dart';
import 'constants.dart';

class LivroService {

  Future<List<Livro>> listar() async {
    final url = Uri.parse('$baseUrl/livros.php?acao=listar');
    final response = await http.get(url);
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => Livro.fromJson(e)).toList();
  }

  Future<Livro?> buscarPorId(int id) async {
    final url = Uri.parse('$baseUrl/livros.php?acao=buscar&id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Livro.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<String> inserir(Livro livro) async {
    final url = Uri.parse(
      '$baseUrl/livros.php?acao=inserir'
          '&titulo=${livro.titulo}'
          '&autor=${livro.autor}'
          '&isbn=${livro.isbn}'
          '&ano=${livro.ano}'
          '&quantidade=${livro.quantidade}'
          '&sinopse=${livro.sinopse}',
    );
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  Future<String> atualizar(Livro livro) async {
    final url = Uri.parse(
      '$baseUrl/livros.php?acao=atualizar'
          '&id=${livro.id}'
          '&titulo=${livro.titulo}'
          '&autor=${livro.autor}'
          '&isbn=${livro.isbn}'
          '&ano=${livro.ano}'
          '&quantidade=${livro.quantidade}'
          '&sinopse=${livro.sinopse}',
    );
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  Future<String> deletar(int id) async {
    final url = Uri.parse('$baseUrl/livros.php?acao=deletar&id=$id');
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }
}