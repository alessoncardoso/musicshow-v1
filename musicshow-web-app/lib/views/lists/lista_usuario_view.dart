import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/components/tiles/usuario_tile.dart';
import 'package:musicshow/providers/usuario_provider.dart';
import 'package:provider/provider.dart';

class ListaUsuarioView extends StatelessWidget {
  const ListaUsuarioView({super.key});

  @override
  Widget build(BuildContext context) {
    final listaUsuario = Provider.of<UsuarioProvider>(context);

    Future.delayed(Duration.zero, () {
      listaUsuario.getUsuarioLogado();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        backgroundColor: Cores.vermelho,
        foregroundColor: Cores.branco,
      ),
      body: Column(
        children: [
          Expanded(
            child: listaUsuario.usuarioLogado == null
                ? Center(
                    child: Text("Nenhum usuário logado."),
                  )
                : UsuarioTile(listaUsuario.usuarioLogado!),
          ),
        ],
      ),
    );
  }
}
