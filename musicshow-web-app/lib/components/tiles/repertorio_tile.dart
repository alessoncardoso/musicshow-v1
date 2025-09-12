import 'package:flutter/material.dart';
import 'package:musicshow/models/repertorio_model.dart';
import 'package:musicshow/providers/repertorio_provider.dart';
import 'package:musicshow/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'auth_utils.dart';

class RepertorioTile extends StatelessWidget {
  final RepertorioModel repertorioModel;

  const RepertorioTile(this.repertorioModel, {super.key});

  @override
  Widget build(BuildContext context) {
    final avatar = const CircleAvatar(child: Icon(Icons.crop_original));

    final bool isMusico = AuthUtils.isMusico(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.BANDA_MUSICA_LIST,
          arguments: repertorioModel,
        );
      },
      child: ListTile(
        leading: avatar,
        title: Text(repertorioModel.nome ?? ""),
        subtitle: Text("Músicas: ${repertorioModel.qtdMusica ?? 0}"),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isMusico) ...[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.REPERT_FORM,
                      arguments: repertorioModel,
                    );
                  },
                  icon: const Icon(Icons.edit),
                  color: Colors.orange,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Excluir Repertório"),
                        content: const Text("Tem certeza que quer excluir?"),
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
                        Provider.of<RepertorioProvider>(context, listen: false)
                            .deletarRepertorio(repertorioModel);
                      }
                    });
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
