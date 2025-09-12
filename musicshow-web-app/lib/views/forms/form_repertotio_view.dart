import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/components/input.dart';
import 'package:musicshow/models/banda_model.dart';
import 'package:musicshow/models/repertorio_model.dart';
import 'package:musicshow/providers/repertorio_provider.dart';
import 'package:provider/provider.dart';

class FormRepertorioView extends StatefulWidget {
  const FormRepertorioView({super.key});

  @override
  State<FormRepertorioView> createState() => _FormRepertorioViewState();
}

class _FormRepertorioViewState extends State<FormRepertorioView> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  void _loadFormData(RepertorioModel repertorioModel) {
    _formData["id"] = repertorioModel.id;
    _formData["idBanda"] = repertorioModel.idBanda;
    _formData["nome"] = repertorioModel.nome;
    _formData["qtdMusica"] = repertorioModel.qtdMusica;
    _formData["status"] = repertorioModel.status;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is RepertorioModel) {
      _loadFormData(arguments);
    } else if (arguments is BandaModel) {
      _formData["idBanda"] = arguments.id;
    }
  }

  void _salvarFormulario() {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      _formKey.currentState?.save();

      final repertorioProvider =
          Provider.of<RepertorioProvider>(context, listen: false);

      final repertorioModel = RepertorioModel(
        id: _formData["id"] ?? 0,
        idBanda: _formData["idBanda"] ?? 0,
        nome: _formData["nome"] ?? "",
        qtdMusica: _formData["qtdMusica"] ?? 0,
        dataCriacao: _formData["dataCriacao"] ?? DateTime.now(),
        status: _formData["status"] ?? 1,
      );

      repertorioProvider.salvarRepertorio(repertorioModel);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.branco,
      appBar: AppBar(
        title: const Text("Formulário de Repertório"),
        backgroundColor: Cores.vermelho,
        foregroundColor: Cores.branco,
        actions: [
          IconButton(
            onPressed: _salvarFormulario,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 32),
              TextFormField(
                initialValue: (_formData["nome"] as String?) ?? "",
                decoration: getInputFormDecoration("Nome do Repertório"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nome inválido.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData["nome"] = value ?? "";
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
