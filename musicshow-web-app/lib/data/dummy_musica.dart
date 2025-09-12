import 'package:musicshow/models/musica_model.dart';

Map<int, MusicaModel> dummyMusicas = {
  1: MusicaModel(
    id: 1,
    idUsuario: 1,
    titulo: 'Musica',
    arquivo: 'arquivo.pdf',
    dataCriacao: DateTime(2023, 10, 5),
    status: 1,
  ),
  2: MusicaModel(
    id: 2,
    idUsuario: 2,
    titulo: 'Musica',
    arquivo: 'arquivo.pdf',
    dataCriacao: DateTime(2024, 1, 12),
    status: 1,
  ),
};
