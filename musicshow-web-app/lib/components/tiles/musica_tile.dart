import 'package:flutter/material.dart';
import 'package:musicshow/models/musica_model.dart';
import 'package:musicshow/providers/musica_provider.dart';
import 'package:musicshow/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';

class MusicaTile extends StatelessWidget {
  final MusicaModel musicaModel;

  const MusicaTile(this.musicaModel, {super.key});

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(child: Icon(Icons.music_note));

    return InkWell(
      onTap: () {
        if (musicaModel.arquivo != null && musicaModel.arquivo!.isNotEmpty) {
          OpenFile.open(musicaModel.arquivo);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erro ao abrir o PDF.")),
          );
        }
      },
      child: ListTile(
        leading: avatar,
        title: Text(musicaModel.titulo ?? ""),
        subtitle: Text(musicaModel.dataCriacao.toString()),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.MUSICA_FORM,
                    arguments: musicaModel,
                  );
                },
                icon: Icon(Icons.edit),
                color: Colors.orange,
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Excluir Música"),
                      content: Text("Tem certeza que quer excluir?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text("Não"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text("Sim"),
                        ),
                      ],
                    ),
                  ).then((confirmed) {
                    if (confirmed == true && context.mounted) {
                      Provider.of<MusicaProvider>(context, listen: false)
                          .removerMusica(musicaModel);
                    }
                  });
                },
                icon: Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
