import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/components/tiles/banda_tile.dart';
import 'package:musicshow/models/usuario_model.dart';
import 'package:musicshow/providers/banda_provider.dart';
import 'package:musicshow/routes/app_routes.dart';
import 'package:provider/provider.dart';

class ListaBandaView extends StatelessWidget {
  const ListaBandaView({super.key});

  @override
  Widget build(BuildContext context) {
    final bandaProvider = Provider.of<BandaProvider>(context);

    final UsuarioModel? usuarioModel =
        ModalRoute.of(context)?.settings.arguments as UsuarioModel?;

    Future.delayed(Duration.zero, () {
      bandaProvider.listarBandasComoMusico(usuarioModel!);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Bandas"),
        backgroundColor: Cores.vermelho,
        foregroundColor: Cores.branco,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.BANDA_FORM,
                  arguments: usuarioModel,
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
            child: bandaProvider.countMusico == 0
                ? const Center(
                    child: Text("Nenhuma banda encontrada. Crie bandas."),
                  )
                : ListView.builder(
                    itemCount: bandaProvider.countMusico,
                    itemBuilder: (ctx, i) =>
                        BandaTile(bandaProvider.byIndexMusico(i)),
                  ),
          ),
        ],
      ),
    );
  }
}
