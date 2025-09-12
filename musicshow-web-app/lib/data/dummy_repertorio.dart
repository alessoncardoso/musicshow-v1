import 'package:musicshow/models/repertorio_model.dart';

Map<int, RepertorioModel> dummyRepertorios = {
  1: RepertorioModel(
    id: 1,
    idBanda: 101,
    nome: 'Repertorio',
    qtdMusica: 10,
    dataCriacao: DateTime(2020, 5, 15),
    status: 1, 
  ),
  2: RepertorioModel(
    id: 2,
    idBanda: 102,
    nome: 'Repertorio',
    qtdMusica: 8,
    dataCriacao: DateTime(2021, 8, 20),
    status: 1,
  ),
};
