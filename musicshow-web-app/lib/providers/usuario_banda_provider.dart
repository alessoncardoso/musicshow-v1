import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musicshow/models/banda_model.dart';
import 'package:musicshow/models/usuario_banda_model.dart';

class UsuarioBandaProvider with ChangeNotifier {
  static const _baseUrl = "http://localhost:8080/usuario-banda";

  final Map<int, UsuarioBandaModel> _items = {};

  UsuarioBandaModel byIndex(int i) => _items.values.elementAt(i);

  List<UsuarioBandaModel> get all => [..._items.values];

  int get count => _items.length;
  
  Future<String?> getPapelUser(int bandaId, int usuarioId) async {
    final url = Uri.parse("$_baseUrl/papel/$bandaId/$usuarioId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<void> listarUsuarioBanda() async {
    final url = Uri.parse("$_baseUrl/listar");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _items.clear();

        for (var item in data) {
          final usuarioBanda = UsuarioBandaModel.fromJson(item);
          _items[usuarioBanda.id!] = usuarioBanda;
        }

        notifyListeners();
      } else {
        _handleError("Erro ao listar usuários de banda", response.body);
      }
    } catch (e) {
      _handleError("Erro ao listar usuários de banda", e);
    }
  }

  Future<void> listarUsuariosPorBanda(BandaModel bandaModel) async {
    final url = Uri.parse("$_baseUrl/listar/${bandaModel.id}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _items.clear();

        for (var item in data) {
          final usuarioBanda = UsuarioBandaModel.fromJson(item);
          _items[usuarioBanda.id!] = usuarioBanda;
        }

        notifyListeners();
      } else {
        _handleError("Erro ao listar usuários por banda", response.body);
      }
    } catch (e) {
      _handleError("Erro ao listar usuários por banda", e);
    }
  }

  Future<bool> adicionarMembro(UsuarioBandaModel usuarioBandaModel) async {
    final url = Uri.parse("$_baseUrl/adicionar-membro");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(usuarioBandaModel.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _items[usuarioBandaModel.id!] = usuarioBandaModel;
        notifyListeners();
        return true;
      } else {
        _handleError("Erro ao adicionar membro", response.body);
        return false;
      }
    } catch (e) {
      _handleError("Erro ao adicionar membro", e);
      return false;
    }
  }

  Future<void> removerMembro(UsuarioBandaModel usuarioBandaModel) async {
    final url = Uri.parse("$_baseUrl/remover-membro");
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(usuarioBandaModel.toJson()),
      );
      if (response.statusCode == 200) {
        _items.remove(usuarioBandaModel.id);
        notifyListeners();
      } else {
        _handleError("Erro ao remover membro", response.body);
      }
    } catch (e) {
      _handleError("Erro ao remover membro", e);
    }
  }

  Future<void> salvarUsuarioBanda(UsuarioBandaModel usuarioBandaModel) async {
    final url = usuarioBandaModel.id == null || usuarioBandaModel.id == 0
        ? Uri.parse("$_baseUrl/cadastrar")
        : Uri.parse("$_baseUrl/atualizar/${usuarioBandaModel.id}");

    try {
      final response = usuarioBandaModel.id == null || usuarioBandaModel.id == 0
          ? await http.post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(usuarioBandaModel.toJson()),
            )
          : await http.put(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(usuarioBandaModel.toJson()),
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _items[usuarioBandaModel.id!] = usuarioBandaModel;
        notifyListeners();
      } else {
        _handleError("Erro ao salvar usuário de banda", response.body);
      }
    } catch (e) {
      _handleError("Erro ao salvar usuário de banda", e);
    }
  }

  Future<void> removerUsuarioBanda(UsuarioBandaModel usuarioBandaModel) async {
    final url = Uri.parse("$_baseUrl/deletar/${usuarioBandaModel.id}");
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        _items.remove(usuarioBandaModel.id);
        notifyListeners();
      } else {
        _handleError("Erro ao remover usuário de banda", response.body);
      }
    } catch (e) {
      _handleError("Erro ao remover usuário de banda", e);
    }
  }

  void _handleError(String message, dynamic error) {
    debugPrint("$message: $error");
  }
}
