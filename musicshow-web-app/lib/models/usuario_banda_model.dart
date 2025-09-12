class UsuarioBandaModel {
  int? id;
  int? idBanda;
  int? idUsuario;
  DateTime? dataInclusao;
  String? papelUser;
  String? nome;

  UsuarioBandaModel({
    this.id,
    this.idBanda,
    this.idUsuario,
    DateTime? dataInclusao,
    this.papelUser,
    this.nome,
  }) : dataInclusao = dataInclusao ?? DateTime.now();

  // Factory para converter JSON em objeto UsuarioBandaModel
  factory UsuarioBandaModel.fromJson(Map<String, dynamic> json) {
    return UsuarioBandaModel(
      id: json['id'] as int? ?? 0,
      idBanda: json['idBanda'] as int? ?? 0,
      idUsuario: json['idUsuario'] as int? ?? 0,
      dataInclusao: json['dataInclusao'] != null
          ? DateTime.tryParse(json['dataInclusao']) ?? DateTime.now()
          : DateTime.now(),
      papelUser: json['papelUser'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
    );
  }

  // Método toJson para converter objeto UsuarioBandaModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'idBanda': idBanda ?? 0,
      'idUsuario': idUsuario ?? 0,
      'dataInclusao': (dataInclusao ?? DateTime.now()).toIso8601String(),
      'papelUser': papelUser ?? '',
      'nome': nome ?? '',
    };
  }
}
