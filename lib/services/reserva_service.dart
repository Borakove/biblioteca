import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reserva.dart';
import 'constants.dart';

class ReservaService {

  Future<List<Reserva>> listar() async {
    final url = Uri.parse('$baseUrl/reservas.php?acao=listar');
    final response = await http.get(url);
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => Reserva.fromJson(e)).toList();
  }

  Future<List<Reserva>> listarPorUsuario(int usuarioId) async {
    final url = Uri.parse(
      '$baseUrl/reservas.php?acao=listarPorUsuario&usuario_id=$usuarioId',
    );
    final response = await http.get(url);
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => Reserva.fromJson(e)).toList();
  }

  Future<String> inserir(int usuarioId, int livroId) async {
    final url = Uri.parse(
      '$baseUrl/reservas.php?acao=inserir&usuario_id=$usuarioId&livro_id=$livroId',
    );
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  Future<String> atualizarStatus(int id, String status) async {
    final url = Uri.parse(
      '$baseUrl/reservas.php?acao=atualizarStatus&id=$id&status=$status',
    );
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }
}