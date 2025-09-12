class BandaMusicaModel {
  int? id;
  int? idBanda;
  int? idMusica;
  int? idRepertorio;
  DateTime? dataInclusao;
  int? ordem;
  String? titulo;
  String? arquivo;

  BandaMusicaModel({
    this.id,
    this.idBanda,
    this.idMusica,
    this.idRepertorio,
    DateTime? dataInclusao,
    this.ordem,
    this.titulo,
    this.arquivo,
  }) : dataInclusao = dataInclusao ?? DateTime.now();

  // Método copyWith para criar uma cópia do objeto com novas propriedades
  BandaMusicaModel copyWith({
    int? id,
    String? titulo,
    int? ordem,
  }) {
    return BandaMusicaModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      ordem: ordem ?? this.ordem,
    );
  }

  // Factory para converter JSON em objeto BandaMusicaModel
  factory BandaMusicaModel.fromJson(Map<String, dynamic> json) {
    return BandaMusicaModel(
      id: json['id'] as int? ?? 0,
      idBanda: json['idBanda'] as int? ?? 0,
      idMusica: json['idMusica'] as int? ?? 0,
      idRepertorio: json['idRepertorio'] as int? ?? 0,
      dataInclusao: json['dataInclusao'] != null
          ? DateTime.tryParse(json['dataInclusao']) ?? DateTime.now()
          : DateTime.now(),
      ordem: json['ordem'] as int? ?? 0,
      titulo: json['titulo'] as String? ?? '',
      arquivo: json['arquivo'] as String? ?? '',
    );
  }

  // Método toJson para converter objeto BandaMusicaModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'idBanda': idBanda ?? 0,
      'idMusica': idMusica ?? 0,
      'idRepertorio': idRepertorio ?? 0,
      'dataInclusao': (dataInclusao ?? DateTime.now()).toIso8601String(),
      'ordem': ordem ?? 0,
      'titulo': titulo ?? '',
      'arquivo': arquivo ?? '',
    };
  }
}
