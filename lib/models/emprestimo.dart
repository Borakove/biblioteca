class Emprestimo {
  int id;
  int usuarioId;
  int livroId;
  String dataEmprestimo;
  String dataDevolucao;
  bool devolvido;

  Emprestimo({
    required this.id,
    required this.usuarioId,
    required this.livroId,
    required this.dataEmprestimo,
    required this.dataDevolucao,
    required this.devolvido,
  });

  factory Emprestimo.fromJson(Map<String, dynamic> json) {
    return Emprestimo(
      id:              json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      usuarioId:       json['usuario_id'] is int ? json['usuario_id'] : int.parse(json['usuario_id'].toString()),
      livroId:         json['livro_id'] is int ? json['livro_id'] : int.parse(json['livro_id'].toString()),
      dataEmprestimo:  json['data_emprestimo'] ?? '',
      dataDevolucao:   json['data_devolucao'] ?? '',
      devolvido:       json['devolvido'].toString() == '1',
    );
  }
}