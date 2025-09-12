class BandaModel {
  int? id;
  int? idUsuario;
  String? nome;
  int? qtdIntegrante;
  int? qtdRepertorio;
  DateTime? dataCriacao;
  int? status;

  BandaModel({
    this.id,
    this.idUsuario,
    this.nome,
    this.qtdIntegrante,
    this.qtdRepertorio,
    DateTime? dataCriacao,
    this.status,
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  // Factory para converter JSON em objeto BandaModel
  factory BandaModel.fromJson(Map<String, dynamic> json) {
    return BandaModel(
      id: json['id'] as int? ?? 0,
      idUsuario: json['idUsuario'] as int? ?? 0,
      nome: json['nome'] as String? ?? '',
      qtdIntegrante: json['qtdIntegrante'] as int? ?? 0,
      qtdRepertorio: json['qtdRepertorio'] as int? ?? 0,
      dataCriacao: json['dataCriacao'] != null
          ? DateTime.tryParse(json['dataCriacao']) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] as int? ?? 1,
    );
  }

  // Método toJson para converter objeto BandaModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'idUsuario': idUsuario ?? 0,
      'nome': nome ?? '',
      'qtdIntegrante': qtdIntegrante ?? 0,
      'qtdRepertorio': qtdRepertorio ?? 0,
      'dataCriacao': (dataCriacao ?? DateTime.now()).toIso8601String(),
      'status': status ?? 1,
    };
  }
}
