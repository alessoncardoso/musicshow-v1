import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/components/tiles/banda_musica_tile.dart';
import 'package:musicshow/models/banda_musica_model.dart';
import 'package:musicshow/models/musica_model.dart';
import 'package:musicshow/models/repertorio_model.dart';
import 'package:musicshow/providers/banda_musica_provider.dart';
import 'package:musicshow/providers/musica_provider.dart';
import 'package:musicshow/providers/usuario_provider.dart';
import 'package:musicshow/routes/app_routes.dart';
import 'package:provider/provider.dart';

class ListaBandaMusicaView extends StatelessWidget {
  ListaBandaMusicaView({super.key});

  final TextEditingController _tituloController = TextEditingController();
  final ValueNotifier<List<MusicaModel>> _musicasEncontradas =
      ValueNotifier([]);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  Future<void> _pesquisarMusicaPorTitulo(BuildContext context) async {
    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);

    final titulo = _tituloController.text.trim();
    final idUsuario = usuarioProvider.usuarioLogado!.id;

    if (titulo.isNotEmpty) {
      _isLoading.value = true;
      final musicaProvider =
          Provider.of<MusicaProvider>(context, listen: false);
      final List<MusicaModel> musicasEncontradas =
          await musicaProvider.buscarMusicaPorTitulo(idUsuario!, titulo);

      if (musicasEncontradas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Nenhuma música encontrada com o título fornecido.")),
        );
      } else {
        _musicasEncontradas.value = musicasEncontradas;
      }

      _isLoading.value = false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, insira um título válido.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bandaMusicaProvider = Provider.of<BandaMusicaProvider>(context);

    final RepertorioModel? repertorioModel =
        ModalRoute.of(context)?.settings.arguments as RepertorioModel?;

    if (repertorioModel != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        bandaMusicaProvider.listarMusicasPorRepertorio(repertorioModel);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(repertorioModel?.nome ?? ""),
        backgroundColor: Cores.vermelho,
        foregroundColor: Cores.branco,
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(
          //       AppRoutes.BANDA_MUSICA_FORM,
          //       arguments: repertorioModel,
          //     );
          //   },
          //   icon: const Icon(Icons.add),
          //   color: Cores.branco,
          // ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _tituloController,
              decoration: InputDecoration(
                labelText: "Adicionar música",
                hintText: "Digite o título da música",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _pesquisarMusicaPorTitulo(context),
                ),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: _isLoading,
              builder: (context, isLoading, _) {
                return isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ValueListenableBuilder<List<MusicaModel>>(
                        valueListenable: _musicasEncontradas,
                        builder: (context, musicas, _) {
                          if (musicas.isNotEmpty) {
                            return ListView.builder(
                              itemCount: musicas.length,
                              itemBuilder: (context, index) {
                                final musicaModel = musicas[index];
                                return ListTile(
                                  title: Text(musicaModel.titulo ?? ""),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      final bandaMusicaProvider =
                                          Provider.of<BandaMusicaProvider>(
                                              context,
                                              listen: false);

                                      final sucesso = await bandaMusicaProvider
                                          .adicionarMusica(
                                        BandaMusicaModel(
                                          id: 0,
                                          idBanda: repertorioModel!.idBanda,
                                          idMusica: musicaModel.id,
                                          idRepertorio: repertorioModel.id,
                                          dataInclusao: DateTime.now(),
                                        ),
                                      );

                                      if (sucesso) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Música adicionada com sucesso!"),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Erro ao adicionar música."),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                      //remover isso
                                      await Future.delayed(
                                          const Duration(seconds: 1));

                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                        AppRoutes.BANDA_MUSICA_LIST,
                                        arguments: repertorioModel,
                                      );
                                      //
                                    },
                                    icon: const Icon(Icons.add_circle),
                                    color: Colors.green,
                                  ),
                                );
                              },
                            );
                          } else {
                            return bandaMusicaProvider.count == 0
                                ? const Center(
                                    child: Text(
                                        "Nenhuma música encontrada. Adicione músicas."))
                                : ReorderableListView.builder(
                                    itemCount: bandaMusicaProvider.count,
                                    onReorder:
                                        bandaMusicaProvider.reordenarMusicas,
                                    itemBuilder: (ctx, i) => BandaMusicaTile(
                                      key: ValueKey(
                                          bandaMusicaProvider.byIndex(i).id),
                                      bandaMusicaProvider.byIndex(i),
                                    ),
                                  );
                          }
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
