class Livro {
  int id;
  String titulo;
  String autor;
  String isbn;
  int ano;
  int quantidade;
  String sinopse;

  Livro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.isbn,
    required this.ano,
    required this.quantidade,
    required this.sinopse,
  });

  factory Livro.fromJson(Map<String, dynamic> json) {
    return Livro(
      id:         json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      titulo:     json['titulo'] ?? '',
      autor:      json['autor'] ?? '',
      isbn:       json['isbn'] ?? '',
      ano:        json['ano'] is int ? json['ano'] : int.parse(json['ano'].toString()),
      quantidade: json['quantidade'] is int ? json['quantidade'] : int.parse(json['quantidade'].toString()),
      sinopse:    json['sinopse'] ?? '',
    );
  }
}