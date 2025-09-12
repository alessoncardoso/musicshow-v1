import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/components/tiles/usuario_banda_tile.dart';
import 'package:musicshow/components/tiles/auth_utils.dart';
import 'package:musicshow/models/banda_model.dart';
import 'package:musicshow/models/usuario_banda_model.dart';
import 'package:musicshow/models/usuario_model.dart';
import 'package:musicshow/providers/usuario_banda_provider.dart';
import 'package:musicshow/providers/usuario_provider.dart';
import 'package:musicshow/routes/app_routes.dart';
import 'package:provider/provider.dart';

class ListaUsuarioBandaView extends StatelessWidget {
  ListaUsuarioBandaView({super.key});

  final TextEditingController _emailController = TextEditingController();
  final ValueNotifier<UsuarioModel?> _usuarioEncontrado = ValueNotifier(null);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  Future<void> _pesquisarUsuarioPorEmail(BuildContext context) async {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      _isLoading.value = true;
      final usuarioProvider =
          Provider.of<UsuarioProvider>(context, listen: false);
      final usuarioEncontrado =
          await usuarioProvider.buscarUsuarioPorEmail(email);
      _usuarioEncontrado.value = usuarioEncontrado;
      _isLoading.value = false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um email válido.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioBandaProvider = Provider.of<UsuarioBandaProvider>(context);

    final arguments = ModalRoute.of(context)?.settings.arguments;
    final BandaModel? bandaModel = arguments is BandaModel ? arguments : null;

    final bool isMusico = AuthUtils.isMusico(context);

    if (bandaModel != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        usuarioBandaProvider.listarUsuariosPorBanda(bandaModel);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(bandaModel?.nome ?? ""),
        backgroundColor: Cores.vermelho,
        foregroundColor: Cores.branco,
        actions: [
          if (isMusico)
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.USER_BANDA_FORM,
                  arguments: bandaModel,
                );
              },
              icon: const Icon(Icons.add),
              color: Cores.branco,
            ),
        ],
      ),
      body: Column(
        children: [
          if (isMusico)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Adicionar integrante",
                  hintText: "Digite o email do integrante",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _pesquisarUsuarioPorEmail(context),
                  ),
                ),
              ),
            ),
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: _isLoading,
              builder: (context, isLoading, _) {
                return isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ValueListenableBuilder<UsuarioModel?>(
                        valueListenable: _usuarioEncontrado,
                        builder: (context, usuarioModel, _) {
                          if (usuarioModel != null) {
                            return ListView(
                              children: [
                                ListTile(
                                  title: Text(usuarioModel.nome ?? ""),
                                  subtitle: Text(usuarioModel.email ?? ""),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      final usuarioBandaProvider =
                                          Provider.of<UsuarioBandaProvider>(
                                              context,
                                              listen: false);

                                      final sucesso = await usuarioBandaProvider
                                          .adicionarMembro(
                                        UsuarioBandaModel(
                                          id: 0,
                                          idBanda: bandaModel!.id,
                                          idUsuario: usuarioModel.id,
                                          dataInclusao: DateTime.now(),
                                        ),
                                      );

                                      if (sucesso) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Membro adicionado com sucesso!"),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Erro ao adicionar membro."),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                      await Future.delayed(
                                          const Duration(seconds: 1));

                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                        AppRoutes.USER_BANDA_LIST,
                                        arguments: bandaModel,
                                      );
                                    },
                                    icon: const Icon(Icons.add_circle),
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return usuarioBandaProvider.count == 0
                                ? const Center(
                                    child: Text(
                                        "Nenhum integrante encontrado. Adicione integrantes."),
                                  )
                                : ListView.builder(
                                    itemCount: usuarioBandaProvider.count,
                                    itemBuilder: (ctx, i) => UsuarioBandaTile(
                                      usuarioBandaProvider.byIndex(i),
                                    ),
                                  );
                          }
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
