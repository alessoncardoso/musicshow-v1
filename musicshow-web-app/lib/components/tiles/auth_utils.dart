import 'package:flutter/material.dart';
import 'package:musicshow/models/banda_model.dart';
import 'package:musicshow/providers/usuario_provider.dart';
import 'package:provider/provider.dart';

class AuthUtils {
  static bool isMusico(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    final BandaModel? bandaModel = arguments is BandaModel ? arguments : null;

    if (bandaModel == null) {
      return false;
    }

    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);
    return bandaModel.idUsuario == usuarioProvider.getUsuarioLogado()?.id;
  }
}
