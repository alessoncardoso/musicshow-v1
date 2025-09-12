import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/components/input.dart';
import 'package:musicshow/models/banda_model.dart';
import 'package:musicshow/models/usuario_banda_model.dart';
import 'package:musicshow/models/usuario_model.dart';
import 'package:musicshow/providers/usuario_banda_provider.dart';
import 'package:provider/provider.dart';

class FormUsuarioBandaView extends StatefulWidget {
  const FormUsuarioBandaView({super.key});

  @override
  State<FormUsuarioBandaView> createState() => _FormUsuarioBandaViewState();
}

class _FormUsuarioBandaViewState extends State<FormUsuarioBandaView> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  void _loadFormData(UsuarioBandaModel usuarioBanda) {
    _formData["id"] = usuarioBanda.id;
    _formData["idBanda"] = usuarioBanda.idBanda;
    _formData["idUsuario"] = usuarioBanda.idUsuario;
    _formData["papelUser"] = usuarioBanda.papelUser;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is UsuarioBandaModel) {
      _loadFormData(arguments);
    } else if (arguments is BandaModel) {
      _formData["idBanda"] = arguments.id;
    } else if (arguments is UsuarioModel) {
      _formData["idUsuario"] = arguments.id;
    }
  }

  void _salvarFormulario() {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      _formKey.currentState?.save();

      final usuarioBandaProvider =
          Provider.of<UsuarioBandaProvider>(context, listen: false);

      final usuarioBandaModel = UsuarioBandaModel(
        idBanda: _formData["idBanda"] ?? 0,
        idUsuario: _formData["idUsuario"] ?? 0,
        papelUser: _formData["papelUser"] ?? 0,
        dataInclusao: _formData["dataInclusao"] ?? DateTime.now(),
      );

      usuarioBandaProvider.salvarUsuarioBanda(usuarioBandaModel);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.branco,
      appBar: AppBar(
        title: const Text("Formulário de Usuário na Banda"),
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
                initialValue: (_formData["idBanda"] as int?)?.toString() ?? "",
                decoration: getInputFormDecoration("ID da Banda"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "ID da Banda inválido.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData["idBanda"] = int.tryParse(value ?? "0") ?? 0;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue:
                    (_formData["idUsuario"] as int?)?.toString() ?? "",
                decoration: getInputFormDecoration("ID do Usuário"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "ID do Usuário inválido.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData["idUsuario"] = int.tryParse(value ?? "0") ?? 0;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue:
                    (_formData["papelUser"] as int?)?.toString() ?? "",
                decoration: getInputFormDecoration("Papel do Usuário"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Papel inválido.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData["papelUser"] = int.tryParse(value ?? "0") ?? 0;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
