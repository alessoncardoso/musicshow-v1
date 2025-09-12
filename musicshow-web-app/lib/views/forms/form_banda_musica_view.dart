import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/components/input.dart';
import 'package:musicshow/models/banda_model.dart';
import 'package:musicshow/models/banda_musica_model.dart';
import 'package:musicshow/models/musica_model.dart';
import 'package:musicshow/models/repertorio_model.dart';
import 'package:musicshow/providers/banda_musica_provider.dart';
import 'package:provider/provider.dart';

class FormBandaMusicaView extends StatefulWidget {
  const FormBandaMusicaView({super.key});

  @override
  State<FormBandaMusicaView> createState() => _FormBandaMusicaViewState();
}

class _FormBandaMusicaViewState extends State<FormBandaMusicaView> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {};

  void _loadFormData(BandaMusicaModel bandaMusicaModel) {
    _formData["id"] = bandaMusicaModel;
    _formData["id_banda"] = bandaMusicaModel.idBanda;
    _formData["id_musica"] = bandaMusicaModel.idMusica;
    _formData["id_repertorio"] = bandaMusicaModel.idRepertorio;
    _formData["ordem"] = bandaMusicaModel.ordem;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is BandaMusicaModel) {
      _loadFormData(arguments);
    } else if (arguments is BandaModel) {
      _formData["idBanda"] = arguments.id;
    } else if (arguments is MusicaModel) {
      _formData["idMusica"] = arguments.id;
    } else if (arguments is RepertorioModel) {
      _formData["idRepertorio"] = arguments.id;
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

  // Future<void> selecionarArquivo() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );
  //   if (result != null && result.files.single.path != null) {
  //     final file = File(result.files.single.path!);
  //     final bytes =
  //         await file.readAsBytes(); // Carrega o arquivo como Uint8List
  //     setState(() {
  //       _formData["arquivo"] = bytes; // Armazena o BLOB
  //     });
  //   }
  // }

  void _salvarFormulario() {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (isValid && _formData["arquivo"] != null) {
      _formKey.currentState?.save();

      final musicaProvider =
          Provider.of<BandaMusicaProvider>(context, listen: false);

      final bandaMusicaModel = BandaMusicaModel(
        id: _formData["id"] ?? 0,
        idBanda: _formData["idBanda"] ?? 0,
        idMusica: _formData["idMusica"] ?? 0,
        idRepertorio: _formData["idRepertorio"] ?? 0,
        ordem: _formData["idOrdem"] ?? 0,
        titulo: _formData["titulo"] ?? "",
        arquivo: _formData["arquivo"] ?? "",
      );

      musicaProvider.salvarBandaMusica(bandaMusicaModel);

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
        title: Text("Formulário de Música na Banda"),
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
        padding: EdgeInsets.all(20),
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
