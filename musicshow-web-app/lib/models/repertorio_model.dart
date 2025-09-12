class RepertorioModel {
  int? id;
  int? idBanda;
  String? nome;
  int? qtdMusica;
  DateTime? dataCriacao;
  int? status;

  RepertorioModel({
    this.id,
    this.idBanda,
    this.nome,
    this.qtdMusica,
    DateTime? dataCriacao,
    this.status,
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  // Factory para converter JSON em objeto RepertorioModel
  factory RepertorioModel.fromJson(Map<String, dynamic> json) {
    return RepertorioModel(
      id: json['id'] as int? ?? 0,
      idBanda: json['idBanda'] as int? ?? 0,
      nome: json['nome'] as String? ?? '',
      qtdMusica: json['qtdMusica'] as int? ?? 0,
      dataCriacao: json['dataCriacao'] != null
          ? DateTime.tryParse(json['dataCriacao']) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] as int? ?? 0,
    );
  }

  // Método toJson para converter objeto RepertorioModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'idBanda': idBanda ?? 0,
      'nome': nome ?? '',
      'qtdMusica': qtdMusica ?? 0,
      'dataCriacao': (dataCriacao ?? DateTime.now()).toIso8601String(),
      'status': status ?? 0,
    };
  }
}
