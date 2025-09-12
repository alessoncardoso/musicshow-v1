import 'package:flutter/material.dart';
import 'package:musicshow/models/banda_model.dart';
import 'package:musicshow/providers/banda_provider.dart';
import 'package:musicshow/routes/app_routes.dart';
import 'package:provider/provider.dart';

class BandaTile extends StatelessWidget {
  final BandaModel bandaModel;

  const BandaTile(this.bandaModel, {super.key});

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(child: Icon(Icons.person));

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.REPERT_LIST,
          arguments: bandaModel,
        );
      },
      child: ListTile(
        leading: avatar,
        title: Text(bandaModel.nome ?? ""),
        subtitle: Text("Repertórios: ${bandaModel.qtdRepertorio ?? 0}"),
        trailing: SizedBox(
          width: 120,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.USER_BANDA_LIST,
                    arguments: bandaModel,
                  );
                },
                icon: Icon(Icons.person_add),
                color: Colors.blue,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.BANDA_FORM,
                    arguments: bandaModel,
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
                      title: Text("Excluir Banda"),
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
                      Provider.of<BandaProvider>(context, listen: false)
                          .removerBanda(bandaModel);
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
