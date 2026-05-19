class Reserva {
  int id;
  int usuarioId;
  int livroId;
  String dataReserva;
  String status; // 'pendente', 'confirmada', 'cancelada'

  Reserva({
    required this.id,
    required this.usuarioId,
    required this.livroId,
    required this.dataReserva,
    required this.status,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id:          json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      usuarioId:   json['usuario_id'] is int ? json['usuario_id'] : int.parse(json['usuario_id'].toString()),
      livroId:     json['livro_id'] is int ? json['livro_id'] : int.parse(json['livro_id'].toString()),
      dataReserva: json['data_reserva'] ?? '',
      status:      json['status'] ?? 'pendente',
    );
  }
}