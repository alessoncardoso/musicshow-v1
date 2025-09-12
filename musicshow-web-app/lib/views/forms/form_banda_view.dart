import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/components/input.dart';
import 'package:musicshow/models/banda_model.dart';
import 'package:musicshow/models/usuario_model.dart';
import 'package:musicshow/providers/banda_provider.dart';
import 'package:musicshow/routes/app_routes.dart';
import 'package:provider/provider.dart';

class FormBandaView extends StatefulWidget {
  const FormBandaView({super.key});

  @override
  State<FormBandaView> createState() => _FormBandaViewState();
}

class _FormBandaViewState extends State<FormBandaView> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  void _loadFormData(BandaModel bandaModel) {
    _formData["id"] = bandaModel.id;
    _formData["idUsuario"] = bandaModel.idUsuario;
    _formData["nome"] = bandaModel.nome;
    _formData["qtdIntegrante"] = bandaModel.qtdIntegrante;
    _formData["qtdRepertorio"] = bandaModel.qtdRepertorio;
    _formData["status"] = bandaModel.status;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is BandaModel) {
      _loadFormData(arguments);
    } else if (arguments is UsuarioModel) {
      _formData["idUsuario"] = arguments.id;
    }
  }

  void _salvarFormulario() {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      _formKey.currentState?.save();

      final bandaProvider = Provider.of<BandaProvider>(context, listen: false);

      final bandaModel = BandaModel(
        id: _formData["id"] ?? 0,
        idUsuario: _formData["idUsuario"] ?? 0,
        nome: _formData["nome"] ?? "",
        qtdIntegrante: _formData["qtdIntegrante"] ?? 0,
        qtdRepertorio: _formData["qtdRepertorio"] ?? 0,
        dataCriacao: _formData["dataCriacao"] ?? DateTime.now(),
        status: _formData["status"] ?? 1,
      );

      bandaProvider.salvarBanda(bandaModel);

      Navigator.of(context).pop(
        AppRoutes.BANDA_LIST,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.branco,
      appBar: AppBar(
        title: const Text("Formulário de Banda"),
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
                initialValue: _formData["nome"] as String? ?? "",
                decoration: getInputFormDecoration("Nome da Banda"),
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
            ],
          ),
        ),
      ),
    );
  }
}
