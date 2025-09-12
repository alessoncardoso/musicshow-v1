import 'package:flutter/material.dart';
import 'package:musicshow/models/banda_musica_model.dart';
import 'package:musicshow/providers/banda_musica_provider.dart';
import 'package:musicshow/routes/app_routes.dart';
import 'package:provider/provider.dart';

class BandaMusicaTile extends StatelessWidget {
  final BandaMusicaModel bandaMusicaModel;

  const BandaMusicaTile(this.bandaMusicaModel, {super.key});

  @override
  Widget build(BuildContext context) {
    final avatar = const CircleAvatar(child: Icon(Icons.music_note));
    return InkWell(
      onTap: () {
         Navigator.of(context).pushNamed(
          AppRoutes.PDF_MUSICA,
          arguments: bandaMusicaModel,
        );
      },
      child: ListTile(
        leading: avatar,
        title: Text(
            "${bandaMusicaModel.ordem ?? 0} - ${bandaMusicaModel.titulo ?? ""}"),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Excluir Música"),
                      content: const Text("Tem certeza que quer remover?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Não"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Sim"),
                        ),
                      ],
                    ),
                  ).then((confirmed) {
                    if (confirmed == true && context.mounted) {
                      Provider.of<BandaMusicaProvider>(context, listen: false)
                          .removerMusica(bandaMusicaModel);
                    }
                  });
                },
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
