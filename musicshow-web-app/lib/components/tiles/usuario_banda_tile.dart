import 'package:flutter/material.dart';
import 'package:musicshow/components/tiles/auth_utils.dart';
import 'package:musicshow/models/usuario_banda_model.dart';
import 'package:musicshow/providers/usuario_banda_provider.dart';
import 'package:provider/provider.dart';

class UsuarioBandaTile extends StatelessWidget {
  final UsuarioBandaModel usuarioBandaModel;

  const UsuarioBandaTile(this.usuarioBandaModel, {super.key});

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(child: Icon(Icons.person));

    final bool isMusico = AuthUtils.isMusico(context);

    final isMusicoDaBanda = usuarioBandaModel.papelUser == "Musico";

    return Container(
      color: isMusicoDaBanda ? Colors.green.shade100 : Colors.transparent,
      child: ListTile(
        leading: avatar,
        title: Text(usuarioBandaModel.nome ?? ""),
        subtitle: Text(usuarioBandaModel.papelUser ?? ""),
        trailing: SizedBox(
          width: 100,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (!isMusicoDaBanda)
              if (isMusico)
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Remover Membro"),
                        content: Text("Tem certeza que quer remover?"),
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
                        Provider.of<UsuarioBandaProvider>(context,
                                listen: false)
                            .removerMembro(usuarioBandaModel);
                      }
                    });
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                ),
          ]),
        ),
      ),
    );
  }
}
