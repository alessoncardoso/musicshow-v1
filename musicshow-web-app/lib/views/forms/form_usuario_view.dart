import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/components/input.dart';
import 'package:musicshow/models/usuario_model.dart';
import 'package:musicshow/providers/usuario_provider.dart';
import 'package:provider/provider.dart';

class FormUsuarioView extends StatefulWidget {
  const FormUsuarioView({super.key});

  @override
  State<FormUsuarioView> createState() => _FormUsuarioViewState();
}

class _FormUsuarioViewState extends State<FormUsuarioView> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  void _loadFormData(UsuarioModel usuarioModel) {
    _formData["id"] = usuarioModel.id;
    _formData["nome"] = usuarioModel.nome;
    _formData["email"] = usuarioModel.email;
    _formData["senha"] = usuarioModel.senha;
    _formData["status"] = usuarioModel.status;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final UsuarioModel? usuarioModel =
        ModalRoute.of(context)?.settings.arguments as UsuarioModel?;

    if (_formData.isEmpty && usuarioModel != null) {
      _loadFormData(usuarioModel);
    }
  }

  void _salvarFormulario() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      _formKey.currentState?.save();

      final usuarioExiste =
          await Provider.of<UsuarioProvider>(context, listen: false)
              .atualizarUsuario(
        UsuarioModel(
          id: _formData["id"] ?? 0,
          nome: _formData["nome"] ?? "",
          email: _formData["email"] ?? "",
          senha: _formData["senha"] ?? "",
          dataCriacao: _formData["dataCriacao"] ?? DateTime.now(),
          status: _formData["status"] ?? 1,
        ),
      );
      if (usuarioExiste) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.branco,
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        backgroundColor: Cores.vermelho,
        foregroundColor: Cores.branco,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              onPressed: _salvarFormulario,
              icon: const Icon(Icons.save),
            ),
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
                initialValue: _formData["nome"] as String?,
                decoration: getInputFormDecoration("Nome"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nome inválido.";
                  }
                  if (value.trim().length < 3) {
                    return "Nome inválido. No mínimo 3 letras.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData["nome"] = value ?? "";
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _formData["email"] as String?,
                decoration: getInputFormDecoration("E-mail"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "E-mail inválido.";
                  }
                  if (!value.contains("@")) {
                    return "Digite um e-mail válido.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData["email"] = value ?? "";
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _formData["senha"] as String?,
                decoration: getInputFormDecoration("Senha"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Senha inválida.";
                  }
                  if (value.length < 8) {
                    return "Senha muito curta.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData["senha"] = value ?? "";
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
