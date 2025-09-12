import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musicshow/models/banda_musica_model.dart';
import 'package:musicshow/models/repertorio_model.dart';

class BandaMusicaProvider with ChangeNotifier {
  static const _baseUrl = "http://localhost:8080/banda-musica";

  final Map<int, BandaMusicaModel> _items = {};

  List<BandaMusicaModel> get all => [..._items.values];

  BandaMusicaModel byIndex(int i) => _items.values.elementAt(i);

  int get count => _items.length;

  Future<void> listarMusicasPorRepertorio(
      RepertorioModel repertorioModel) async {
    final url = Uri.parse("$_baseUrl/listar/${repertorioModel.id}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _items.clear();

        for (var item in data) {
          final bandaMusica = BandaMusicaModel.fromJson(item);
          _items[bandaMusica.id!] = bandaMusica;
        }

        notifyListeners();
      } else {
        _handleError("Erro ao listar músicas por repertório", response.body);
      }
    } catch (e) {
      _handleError("Erro ao listar músicas por repertório", e);
    }
  }

  Future<bool> adicionarMusica(BandaMusicaModel bandaMusicaModel) async {
    final url = Uri.parse("$_baseUrl/adicionar-musica");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(bandaMusicaModel.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _items[bandaMusicaModel.id!] = bandaMusicaModel;
        notifyListeners();
        return true;
      } else {
        _handleError("Erro ao adicionar música", response.body);
        return false;
      }
    } catch (e) {
      _handleError("Erro ao adicionar música", e);
      return false;
    }
  }

  Future<void> removerMusica(BandaMusicaModel bandaMusicaModel) async {
    final url = Uri.parse("$_baseUrl/remover-musica");
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bandaMusicaModel.toJson()),
      );
      if (response.statusCode == 200) {
        _items.remove(bandaMusicaModel.id);
        notifyListeners();
      } else {
        _handleError("Erro ao remover música", response.body);
      }
    } catch (e) {
      _handleError("Erro ao remover música", e);
    }
  }

  Future<void> salvarBandaMusica(BandaMusicaModel bandaMusicaModel) async {
    final url = bandaMusicaModel.id == null || bandaMusicaModel.id == 0
        ? Uri.parse("$_baseUrl/cadastrar")
        : Uri.parse("$_baseUrl/atualizar/${bandaMusicaModel.id}");

    try {
      final response = bandaMusicaModel.id == null || bandaMusicaModel.id == 0
          ? await http.post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(bandaMusicaModel.toJson()),
            )
          : await http.put(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(bandaMusicaModel.toJson()),
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _items[bandaMusicaModel.id!] = bandaMusicaModel;
        notifyListeners();
      } else {
        _handleError("Erro ao salvar banda música", response.body);
      }
    } catch (e) {
      _handleError("Erro ao salvar banda música", e);
    }
  }

  Future<void> removerBandaMusica(BandaMusicaModel bandaMusicaModel) async {
    final url = Uri.parse("$_baseUrl/deletar/${bandaMusicaModel.id}");
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        _items.remove(bandaMusicaModel.id);
        notifyListeners();
      } else {
        _handleError("Erro ao remover banda música", response.body);
      }
    } catch (e) {
      _handleError("Erro ao remover banda música", e);
    }
  }

  Future<void> reordenarMusicas(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final List<BandaMusicaModel> musicasReordenadas = List.from(_items.values);

    final item = musicasReordenadas.removeAt(oldIndex);
    musicasReordenadas.insert(newIndex, item);

    for (int i = 0; i < musicasReordenadas.length; i++) {
      musicasReordenadas[i] = musicasReordenadas[i].copyWith(ordem: i + 1);
    }

    _items.clear();
    for (var musica in musicasReordenadas) {
      _items[musica.id!] = musica;
    }
    notifyListeners();

    final url = Uri.parse("$_baseUrl/reordenar-musica");
    final List<Map<String, dynamic>> ordemAtualizada =
        musicasReordenadas.map((m) => {'id': m.id, 'ordem': m.ordem}).toList();

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(ordemAtualizada),
      );

      if (response.statusCode != 200) {
        _handleError("Erro ao atualizar ordem da música", response.body);
      }
    } catch (e) {
      _handleError("Erro ao atualizar ordem da música", e);
    }
  }

  void _handleError(String message, dynamic error) {
    debugPrint("$message: $error");
  }
}
