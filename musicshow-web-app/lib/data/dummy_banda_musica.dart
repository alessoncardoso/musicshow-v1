import 'package:musicshow/models/banda_musica_model.dart';

Map<int, BandaMusicaModel> dummyBandasMusica = {
  1: BandaMusicaModel(
    id: 1,
    idBanda: 1,
    idMusica: 101,
    idRepertorio: 201,
    dataInclusao: DateTime(2023, 5, 5),
    ordem: 1,
    titulo: "Primeira Canção",
    arquivo: "primeira_cancao.mp3",
  ),
  2: BandaMusicaModel(
    id: 2,
    idBanda: 1,
    idMusica: 102,
    idRepertorio: 201,
    dataInclusao: DateTime(2023, 5, 6),
    ordem: 2,
    titulo: "Segunda Canção",
    arquivo: "segunda_cancao.mp3",
  ),
};
