import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musicshow/models/musica_model.dart';
import 'package:musicshow/models/usuario_model.dart';

class MusicaProvider with ChangeNotifier {
  static const _baseUrl = "http://localhost:8080/musicas";

  final Map<int, MusicaModel> _items = {};

  MusicaModel byIndex(int i) => _items.values.elementAt(i);

  List<MusicaModel> get all => [..._items.values];

  int get count => _items.length;

  Future<void> listarMusicas(UsuarioModel usuarioModel) async {
    final url = Uri.parse("$_baseUrl/listar/${usuarioModel.id}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _items.clear();
        for (var item in data) {
          final musica = MusicaModel.fromJson(item);
          _items[musica.id!] = musica;
        }
        notifyListeners();
      } else {
        _handleError("Erro ao listar músicas", response.body);
      }
    } catch (e) {
      _handleError("Erro ao listar músicas", e);
    }
  }

  Future<List<MusicaModel>> buscarMusicaPorTitulo(
      int idUsuario, String titulo) async {
    final url = Uri.parse("$_baseUrl/usuario/$idUsuario/titulo/$titulo");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => MusicaModel.fromJson(item)).toList();
      } else {
        _handleError("Erro ao buscar música por título", response.body);
        return [];
      }
    } catch (e) {
      _handleError("Erro ao buscar música por título", e);
      return [];
    }
  }

  Future<void> salvarMusica(MusicaModel musicaModel) async {
    final url = musicaModel.id == null || musicaModel.id == 0
        ? Uri.parse("$_baseUrl/cadastrar")
        : Uri.parse("$_baseUrl/atualizar/${musicaModel.id}");
    try {
      final response = musicaModel.id == null || musicaModel.id == 0
          ? await http.post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(musicaModel.toJson()),
            )
          : await http.put(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(musicaModel.toJson()),
            );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _items[musicaModel.id!] = musicaModel;
        notifyListeners();
      } else {
        _handleError("Erro ao salvar música", response.body);
      }
    } catch (e) {
      _handleError("Erro ao salvar música", e);
    }
  }

  Future<void> removerMusica(MusicaModel musicaModel) async {
    final url = Uri.parse("$_baseUrl/deletar/${musicaModel.id}");
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        _items.remove(musicaModel.id);
        notifyListeners();
      } else {
        _handleError("Erro ao remover música", response.body);
      }
    } catch (e) {
      _handleError("Erro ao remover música", e);
    }
  }

  void _handleError(String message, dynamic error) {
    debugPrint("$message: $error");
  }
}
