import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musicshow/models/banda_model.dart';
import 'package:musicshow/models/usuario_model.dart';

class BandaProvider with ChangeNotifier {
  static const _baseUrl = "http://localhost:8080/bandas";

  final Map<int, BandaModel> _bandasComoMusico = {};
  final Map<int, BandaModel> _bandasComoMembro = {};

  List<BandaModel> get allBandasComoMusico => [..._bandasComoMusico.values];
  List<BandaModel> get allbBandasComoMembro => [..._bandasComoMembro.values];

  BandaModel byIndexMusico(int i) => _bandasComoMusico.values.elementAt(i);
  BandaModel byIndexMembro(int i) => _bandasComoMembro.values.elementAt(i);

  int get countMusico => _bandasComoMusico.length;
  int get countMembro => _bandasComoMembro.length;

  Future<void> listarBandasComoMusico(UsuarioModel usuarioModel) async {
    try {
      if (usuarioModel.id! <= 0) return;

      final url = Uri.parse("$_baseUrl/musico/${usuarioModel.id}");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _bandasComoMusico.clear();
        for (var item in data) {
          final banda = BandaModel.fromJson(item);
          _bandasComoMusico[banda.id!] = banda;
        }
        notifyListeners();
      } else {
        _handleError("Erro ao listar bandas como músico", response.body);
      }
    } catch (e) {
      _handleError("Erro ao listar bandas como músico", e);
    }
  }

  Future<void> listarBandasComoMembro(UsuarioModel usuarioModel) async {
    try {
      if (usuarioModel.id! <= 0) return;

      final url = Uri.parse("$_baseUrl/membro/${usuarioModel.id}");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _bandasComoMembro.clear();
        for (var item in data) {
          final banda = BandaModel.fromJson(item);
          _bandasComoMembro[banda.id!] = banda;
        }
        notifyListeners();
      } else {
        _handleError("Erro ao listar bandas como membro", response.body);
      }
    } catch (e) {
      _handleError("Erro ao listar bandas como membro", e);
    }
  }

  Future<void> listarBandas() async {
    final url = Uri.parse("$_baseUrl/listar");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _bandasComoMembro.clear();

        for (var item in data) {
          final banda = BandaModel.fromJson(item);
          _bandasComoMembro[banda.id!] = banda;
        }

        notifyListeners();
      } else {
        _handleError("Erro ao listar bandas", response.body);
      }
    } catch (e) {
      _handleError("Erro ao listar bandas", e);
    }
  }

  Future<void> listarBandaPorNome(String nome) async {
    final url = Uri.parse("$_baseUrl/listar/nome/$nome");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _bandasComoMusico.clear();
        for (var item in data) {
          final banda = BandaModel.fromJson(item);
          _bandasComoMusico[banda.id!] = banda;
        }
        notifyListeners();
      } else {
        _handleError("Erro ao listar banda por nome", response.body);
      }
    } catch (e) {
      _handleError("Erro ao listar banda por nome", e);
    }
  }

  Future<void> salvarBanda(BandaModel bandaModel) async {
    final url = bandaModel.id == null || bandaModel.id == 0
        ? Uri.parse("$_baseUrl/cadastrar")
        : Uri.parse("$_baseUrl/atualizar/${bandaModel.id}");

    try {
      final response = bandaModel.id == null || bandaModel.id == 0
          ? await http.post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(bandaModel.toJson()),
            )
          : await http.put(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(bandaModel.toJson()),
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _bandasComoMusico[bandaModel.id!] = bandaModel;
        notifyListeners();
      } else {
        _handleError("Erro ao salvar banda", response.body);
      }
    } catch (e) {
      _handleError("Erro ao salvar banda", e);
    }
  }

  Future<void> removerBanda(BandaModel bandaModel) async {
    try {
      final url = Uri.parse("$_baseUrl/deletar/${bandaModel.id}");
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        _bandasComoMusico.remove(bandaModel.id);
        notifyListeners();
      } else {
        _handleError("Erro ao remover banda", response.body);
      }
    } catch (e) {
      _handleError("Erro ao remover banda", e);
    }
  }

  void _handleError(String message, dynamic error) {
    debugPrint("$message: $error");
  }
}
