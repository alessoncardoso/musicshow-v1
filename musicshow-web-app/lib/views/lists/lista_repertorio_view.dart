import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/components/tiles/auth_utils.dart';
import 'package:musicshow/components/tiles/repertorio_tile.dart';
import 'package:musicshow/models/banda_model.dart';
import 'package:musicshow/providers/repertorio_provider.dart';
import 'package:musicshow/routes/app_routes.dart';
import 'package:provider/provider.dart';

class ListaRepertorioView extends StatelessWidget {
  const ListaRepertorioView({super.key});

  @override
  Widget build(BuildContext context) {
    final listaRepertorio = Provider.of<RepertorioProvider>(context);

    final arguments = ModalRoute.of(context)?.settings.arguments;
    final BandaModel? bandaModel = arguments is BandaModel ? arguments : null;

    final bool isMusico = AuthUtils.isMusico(context);

    if (bandaModel != null) {
      listaRepertorio.listarRepertoriosPorBanda(bandaModel);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(bandaModel?.nome ?? "Repertórios"),
        backgroundColor: Cores.vermelho,
        foregroundColor: Cores.branco,
        actions: [
          if (isMusico)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.REPERT_FORM,
                    arguments: bandaModel,
                  );
                },
                icon: const Icon(Icons.add),
                color: Cores.branco,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: listaRepertorio.count == 0
                ? const Center(
                    child:
                        Text("Nenhum repertório encontrado. Crie repertórios."),
                  )
                : ListView.builder(
                    itemCount: listaRepertorio.count,
                    itemBuilder: (ctx, i) =>
                        RepertorioTile(listaRepertorio.byIndex(i)),
                  ),
          ),
        ],
      ),
    );
  }
}
