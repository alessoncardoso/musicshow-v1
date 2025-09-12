import 'package:flutter/material.dart';
import 'package:musicshow/models/usuario_model.dart';
import 'package:musicshow/providers/usuario_provider.dart';
import 'package:musicshow/routes/app_routes.dart';
import 'package:provider/provider.dart';

class UsuarioTile extends StatelessWidget {
  final UsuarioModel usuarioModel;

  const UsuarioTile(this.usuarioModel, {super.key});

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(child: Icon(Icons.person));
    return ListTile(
      leading: avatar,
      title: Text(usuarioModel.nome ?? ""),
      subtitle: Text(usuarioModel.email ?? ""),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.USER_FORM,
                  arguments: usuarioModel,
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
                    title: Text("Excluir Conta"),
                    content: Text("Tem certeza que quer excluir sua conta?"),
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
                    Provider.of<UsuarioProvider>(context, listen: false)
                        .removerUsuario(usuarioModel);
                  }
                });
              },
              icon: Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
