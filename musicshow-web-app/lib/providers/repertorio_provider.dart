import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musicshow/models/banda_model.dart';
import 'package:musicshow/models/repertorio_model.dart';

class RepertorioProvider with ChangeNotifier {
  static const _baseUrl = "http://localhost:8080/repertorios";

  final Map<int, RepertorioModel> _items = {};

  RepertorioModel byIndex(int i) => _items.values.elementAt(i);

  List<RepertorioModel> get all => [..._items.values];

  int get count => _items.length;

  Future<void> listarRepertoriosPorBanda(BandaModel bandaModel) async {
    final url = Uri.parse("$_baseUrl/listar/${bandaModel.id}");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _items.clear();
        for (var item in data) {
          final repertorio = RepertorioModel.fromJson(item);
          _items[repertorio.id!] = repertorio;
        }
        notifyListeners();
      } else {
        _handleError("Erro ao listar repertórios por banda", response.body);
      }
    } catch (e) {
      _handleError("Erro ao listar repertórios por banda", e);
    }
  }

  Future<void> listarRepertorioPorNome(String nome) async {
    final url = Uri.parse("$_baseUrl/listar/nome/$nome");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _items.clear();
        for (var item in data) {
          final repertorio = RepertorioModel.fromJson(item);
          _items[repertorio.id!] = repertorio;
        }
        notifyListeners();
      } else {
        _handleError("Erro ao listar repertório por nome", response.body);
      }
    } catch (e) {
      _handleError("Erro ao listar repertório por nome", e);
    }
  }

  Future<void> salvarRepertorio(RepertorioModel repertorioModel) async {
    final url = repertorioModel.id == null || repertorioModel.id == 0
        ? Uri.parse("$_baseUrl/cadastrar")
        : Uri.parse("$_baseUrl/atualizar/${repertorioModel.id}");

    try {
      final response = repertorioModel.id == null || repertorioModel.id == 0
          ? await http.post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(repertorioModel.toJson()),
            )
          : await http.put(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(repertorioModel.toJson()),
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _items[repertorioModel.id!] = repertorioModel;
        notifyListeners();
      } else {
        _handleError("Erro ao salvar repertório", response.body);
      }
    } catch (e) {
      _handleError("Erro ao salvar repertório", e);
    }
  }

  Future<void> deletarRepertorio(RepertorioModel repertorioModel) async {
    final url = Uri.parse("$_baseUrl/deletar");
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(repertorioModel.toJson()),
      );
      if (response.statusCode == 200) {
        _items.remove(repertorioModel.id);
        notifyListeners();
      } else {
        _handleError("Erro ao deletar repertório", response.body);
      }
    } catch (e) {
      _handleError("Erro ao deletar repertório", e);
    }
  }

  void _handleError(String message, dynamic error) {
    debugPrint("$message: $error");
  }
}
