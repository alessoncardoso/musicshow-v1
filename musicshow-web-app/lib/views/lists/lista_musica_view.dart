import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/components/tiles/musica_tile.dart';
import 'package:musicshow/providers/musica_provider.dart';
import 'package:musicshow/providers/usuario_provider.dart';
import 'package:musicshow/routes/app_routes.dart';
import 'package:provider/provider.dart';

class ListaMusicaView extends StatelessWidget {
  const ListaMusicaView({super.key});

  @override
  Widget build(BuildContext context) {
    final listaMusica = Provider.of<MusicaProvider>(context);

    final usuarioProvider = Provider.of<UsuarioProvider>(context);

    Future.delayed(Duration.zero, () {
      listaMusica.listarMusicas(usuarioProvider.getUsuarioLogado()!);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Músicas"),
        backgroundColor: Cores.vermelho,
        foregroundColor: Cores.branco,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.MUSICA_FORM,
                  arguments: usuarioProvider.usuarioLogado,
                );
              },
              icon: Icon(Icons.add),
              color: Cores.branco,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: listaMusica.count == 0
                ? const Center(
                    child: Text("Nenhum música encontrada. Crie músicas."),
                  )
                : ListView.builder(
                    itemCount: listaMusica.count,
                    itemBuilder: (ctx, i) => MusicaTile(listaMusica.byIndex(i)),
                  ),
          ),
        ],
      ),
    );
  }
}
