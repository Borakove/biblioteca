import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notificacao.dart';
import 'constants.dart';

class NotificacaoService {

  Future<List<Notificacao>> listarPorUsuario(int usuarioId) async {
    final url = Uri.parse(
      '$baseUrl/notificacoes.php?acao=listarPorUsuario&usuario_id=$usuarioId',
    );
    final response = await http.get(url);
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => Notificacao.fromJson(e)).toList();
  }

  Future<String> inserir(int usuarioId, String mensagem) async {
    final url = Uri.parse(
      '$baseUrl/notificacoes.php?acao=inserir&usuario_id=$usuarioId&mensagem=$mensagem',
    );
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  Future<String> marcarLida(int id) async {
    final url = Uri.parse(
      '$baseUrl/notificacoes.php?acao=marcarLida&id=$id',
    );
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }
}