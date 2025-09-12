import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/components/input.dart';
import 'package:musicshow/models/musica_model.dart';
import 'package:musicshow/models/usuario_model.dart';
import 'package:musicshow/providers/musica_provider.dart';
import 'package:provider/provider.dart';

class FormMusicaView extends StatefulWidget {
  const FormMusicaView({super.key});

  @override
  State<FormMusicaView> createState() => _FormMusicaViewState();
}

class _FormMusicaViewState extends State<FormMusicaView> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  void _loadFormData(MusicaModel musica) {
    _formData["id"] = musica.id;
    _formData["titulo"] = musica.titulo;
    _formData["idUsuario"] = musica.idUsuario;
    _formData["arquivo"] = musica.arquivo;
    _formData["status"] = musica.status;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is MusicaModel) {
      _loadFormData(arguments);
    } else if (arguments is UsuarioModel) {
      _formData["idUsuario"] = arguments.id;
    }
  }

  Future<void> selecionarArquivo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _formData["arquivo"] = result.files.single.path;
      });
    }
  }

  void _salvarFormulario() {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (isValid && _formData["arquivo"] != null) {
      _formKey.currentState?.save();

      final musicaProvider =
          Provider.of<MusicaProvider>(context, listen: false);

      final musicaModel = MusicaModel(
        id: _formData["id"] ?? 0,
        titulo: _formData["titulo"] ?? "",
        idUsuario: _formData["idUsuario"] ?? 0,
        arquivo: _formData["arquivo"] ?? "",
        dataCriacao: DateTime.now(),
        status: _formData["status"] ?? 1,
      );

      musicaProvider.salvarMusica(musicaModel);

      Navigator.of(context).pop();
      
    } else if (_formData["arquivo"] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, selecione um arquivo PDF."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.branco,
      appBar: AppBar(
        title: const Text("Cadastro de Música"),
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
                initialValue: _formData["titulo"]?.toString(),
                decoration: getInputFormDecoration("Título"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Título inválido.";
                  }
                  return null;
                },
                onSaved: (value) => _formData["titulo"] = value ?? "",
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: selecionarArquivo,
                icon: const Icon(Icons.attach_file),
                label: const Text("Selecionar PDF"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Cores.vermelho,
                  foregroundColor: Cores.branco,
                ),
              ),
              if (_formData["arquivo"] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Arquivo: PDF selecionado",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
