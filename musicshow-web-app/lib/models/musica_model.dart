class MusicaModel {
  int? id;
  int? idUsuario;
  String? titulo;
  String? arquivo;
  DateTime? dataCriacao;
  int? status;

  MusicaModel({
    this.id,
    this.idUsuario,
    this.titulo,
    this.arquivo,
    DateTime? dataCriacao,
    this.status,
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  // Factory para converter JSON em objeto MusicaModel
  factory MusicaModel.fromJson(Map<String, dynamic> json) {
    return MusicaModel(
      id: json['id'] as int? ?? 0,
      idUsuario: json['idUsuario'] as int? ?? 0,
      titulo: json['titulo'] as String? ?? '',
      arquivo: json['arquivo'] as String? ?? '',
      dataCriacao: json['dataCriacao'] != null
          ? DateTime.tryParse(json['dataCriacao']) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] as int? ?? 0,
    );
  }

  // Método toJson para converter objeto MusicaModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'idUsuario': idUsuario ?? 0,
      'titulo': titulo ?? '',
      'arquivo': arquivo ?? '',
      'dataCriacao': (dataCriacao ?? DateTime.now()).toIso8601String(),
      'status': status ?? 0,
    };
  }
}
