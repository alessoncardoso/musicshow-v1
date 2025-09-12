class UsuarioModel {
  int? id;
  String? nome;
  String? email;
  String? senha;
  DateTime? dataCriacao;
  int? status;

  UsuarioModel({
    this.id,
    this.nome,
    this.email,
    this.senha,
    DateTime? dataCriacao,
    this.status,
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  // Factory para converter JSON em objeto UsuarioModel
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as int? ?? 0,
      nome: json['nome'] as String? ?? '',
      email: json['email'] as String? ?? '',
      senha: json['senha'] as String? ?? '',
      dataCriacao: json['dataCriacao'] != null
          ? DateTime.tryParse(json['dataCriacao']) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] as int? ?? 1,
    );
  }

  // Método toJson para converter objeto UsuarioModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'nome': nome ?? '',
      'email': email ?? '',
      'senha': senha ?? '',
      'dataCriacao': (dataCriacao ?? DateTime.now()).toIso8601String(),
      'status': status ?? 1,
    };
  }

}
// import 'package:bcrypt/bcrypt.dart';

// class UsuarioModel {
//   int? id;
//   String? nome;
//   String? email;
//   String? senhaHash;
//   DateTime? dataCriacao;
//   int? status;

//   UsuarioModel({
//     this.id,
//     this.nome,
//     this.email,
//     String? senha,
//     DateTime? dataCriacao,
//     this.status,
//   })  : dataCriacao = dataCriacao ?? DateTime.now(),
//         senhaHash = senha != null ? _hashSenha(senha) : null;

//   factory UsuarioModel.fromJson(Map<String, dynamic> json) {
//     return UsuarioModel(
//       id: json['id'] as int? ?? 0,
//       nome: json['nome'] as String? ?? '',
//       email: json['email'] as String? ?? '',
//       senha: json['senha'] as String? ?? '',
//       dataCriacao: json['dataCriacao'] != null
//           ? DateTime.tryParse(json['dataCriacao']) ?? DateTime.now()
//           : DateTime.now(),
//       status: json['status'] as int? ?? 1,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id ?? 0,
//       'nome': nome ?? '',
//       'email': email ?? '',
//       'senhaHash': senhaHash ?? '',
//       'dataCriacao': (dataCriacao ?? DateTime.now()).toIso8601String(),
//       'status': status ?? 1,
//     };
//   }

//   static String _hashSenha(String senha) {
//     return BCrypt.hashpw(senha, BCrypt.gensalt());
//   }

//   bool verificarSenha(String senhaInformada) {
//     return senhaHash != null && BCrypt.checkpw(senhaInformada, senhaHash!);
//   }
// }
