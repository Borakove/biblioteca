class Notificacao {
  int id;
  int usuarioId;
  String mensagem;
  bool lida;
  String criadoEm;

  Notificacao({
    required this.id,
    required this.usuarioId,
    required this.mensagem,
    required this.lida,
    required this.criadoEm,
  });

  factory Notificacao.fromJson(Map<String, dynamic> json) {
    return Notificacao(
      id:        json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      usuarioId: json['usuario_id'] is int ? json['usuario_id'] : int.parse(json['usuario_id'].toString()),
      mensagem:  json['mensagem'] ?? '',
      lida:      json['lida'].toString() == '1',
      criadoEm:  json['criado_em'] ?? '',
    );
  }
}