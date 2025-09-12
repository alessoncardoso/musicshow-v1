import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musicshow/data/dummy_usuario.dart';
import 'package:musicshow/models/banda_model.dart';
import 'package:musicshow/models/usuario_model.dart';

class UsuarioProvider with ChangeNotifier {
  static const _baseUrl = "http://localhost:8080/usuarios";

  final Map<int, UsuarioModel> _items = {...dummyUsuarios};

  UsuarioModel byIndex(int i) => _items.values.elementAt(i);

  List<UsuarioModel> get all => [..._items.values];

  int get count => _items.length;

  UsuarioModel? _usuarioLogado;

  UsuarioModel? get usuarioLogado => _usuarioLogado;

  UsuarioModel? getUsuarioLogado() {
    if (_usuarioLogado == null) {
      throw Exception("Nenhum usuário logado.");
    }
    return _usuarioLogado;
  }

  Future<UsuarioModel?> buscarUsuarioPorEmail(String email) async {
    final url = Uri.parse("$_baseUrl/email/$email");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final usuario = UsuarioModel.fromJson(data);
        _items[usuario.id!] = usuario;
        notifyListeners();
        return usuario;
      } else {
        _handleError("Erro ao buscar usuário por email", response.body);
        return null;
      }
    } catch (e) {
      _handleError("Erro ao buscar usuário por email", e);
      return null;
    }
  }

  Future<void> listarUsuariosPorBanda(BandaModel bandaModel) async {
    final url = Uri.parse("$_baseUrl/listar-usuarios/${bandaModel.id}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _items.clear();
        for (var item in data) {
          final usuario = UsuarioModel.fromJson(item);
          _items[usuario.id!] = usuario;
        }
        notifyListeners();
      } else {
        _handleError("Erro ao listar usuários por banda", response.body);
      }
    } catch (e) {
      _handleError("Erro ao listar usuários por banda", e);
    }
  }

  Future<bool> cadastrarUsuario(UsuarioModel usuarioModel) async {
    final url = Uri.parse("$_baseUrl/cadastrar");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(usuarioModel.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        notifyListeners();
        return true;
      } else {
        _handleError("Erro ao cadastrar usuário", response.body);
        return false;
      }
    } catch (e) {
      _handleError("Erro ao cadastrar usuário", e);
      return false;
    }
  }

  Future<UsuarioModel?> autenticarUsuario(String email, String senha) async {
    try {
      final url = Uri.parse("$_baseUrl/autenticar");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"email": email, "senha": senha}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        _usuarioLogado = UsuarioModel.fromJson(data);
        return UsuarioModel.fromJson(data);
      } else {
        _handleError("Erro ao autenticar usuário", response.body);
        return null;
      }
    } catch (e) {
      _handleError("Erro ao autenticar usuário", e);
      return null;
    }
  }

  Future<bool> atualizarUsuario(UsuarioModel usuarioModel) async {
    final url = Uri.parse("$_baseUrl/atualizar/${usuarioModel.id}");
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({usuarioModel.toJson()}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _items[usuarioModel.id!] = usuarioModel;
        notifyListeners();
        return true;
      } else {
        _handleError("Erro ao atualizar usuário", response.body);
        return false;
      }
    } catch (e) {
      _handleError("Erro ao atualizar usuário", e);
      return false;
    }
  }

  Future<void> removerUsuario(UsuarioModel usuarioModel) async {
    final url = Uri.parse("$_baseUrl/deletar/${usuarioModel.id}");
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        _items.remove(usuarioModel.id);
        notifyListeners();
      } else {
        _handleError("Erro ao remover usuário", response.body);
      }
    } catch (e) {
      _handleError("Erro ao remover usuário", e);
    }
  }

  void _handleError(String message, dynamic error) {
    debugPrint("$message: $error");
  }
}
