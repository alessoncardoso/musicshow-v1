import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/components/cads/banda_card.dart';
import 'package:musicshow/models/usuario_model.dart';
import 'package:musicshow/routes/app_routes.dart';
import 'package:musicshow/providers/banda_provider.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bandaProvider = Provider.of<BandaProvider>(context, listen: false);
    final UsuarioModel? usuarioModel =
        ModalRoute.of(context)?.settings.arguments as UsuarioModel?;

    if (usuarioModel != null) {
      Future.delayed(Duration.zero, () {
        bandaProvider.listarBandasComoMembro(usuarioModel);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Cores.vermelho,
        foregroundColor: Cores.branco,
      ),
      body: Consumer<BandaProvider>(
        builder: (context, bandaProvider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Bandas",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: bandaProvider.countMembro == 0
                    ? const Center(
                        child: Text("Você não é integrante de nenhuma banda."),
                      )
                    : ListView.builder(
                        itemCount: bandaProvider.countMembro,
                        itemBuilder: (ctx, i) =>
                            BandaCard(bandaProvider.byIndexMembro(i)),
                      ),
              ),
            ],
          );
        },
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                color: Cores.vermelho,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        const AssetImage('assets/images/musica-white.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Music Show",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              context,
              "Perfil",
              AppRoutes.USER_LIST,
              arguments: usuarioModel,
            ),
            _buildDrawerItem(
              context,
              "Bandas",
              AppRoutes.BANDA_LIST,
              arguments: usuarioModel,
            ),
            _buildDrawerItem(
              context,
              "Músicas",
              AppRoutes.MUSICA_LIST,
              arguments: usuarioModel,
            ),
            // _buildDrawerItem(
            //     context, "Banda Musica", AppRoutes.BANDA_MUSICA_LIST),
            // _buildDrawerItem(
            //     context, "Usuario Banda", AppRoutes.USER_BANDA_LIST),
            _buildDrawerItem(context, "Sair", AppRoutes.LOGIN),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, String route,
      {Object? arguments}) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.of(context).pushNamed(route, arguments: arguments);
      },
    );
  }
}
