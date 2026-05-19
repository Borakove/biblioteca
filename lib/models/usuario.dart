class Usuario {
  int id;
  String nome;
  String email;
  String tipo; // 'aluno' ou 'admin'

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id:    json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nome:  json['nome'] ?? '',
      email: json['email'] ?? '',
      tipo:  json['tipo'] ?? 'aluno',
    );
  }

  bool get isAdmin => tipo == 'admin';
}