import 'package:flutter/material.dart';
import 'package:musicshow/views/lists/lista_musica_view.dart';
import 'package:musicshow/views/login_usuario_view.dart';
import 'package:musicshow/views/cadastro_usuario_view.dart';
import 'package:musicshow/views/forms/form_banda_musica_view.dart';
import 'package:musicshow/views/forms/form_banda_view.dart';
import 'package:musicshow/views/forms/form_musica_view.dart';
import 'package:musicshow/views/forms/form_repertotio_view.dart';
import 'package:musicshow/views/forms/form_usuario_banda_view.dart';
import 'package:musicshow/views/forms/form_usuario_view.dart';
import 'package:musicshow/views/home_view.dart';
import 'package:musicshow/views/lists/lista_banda_musica_view.dart';
import 'package:musicshow/views/lists/lista_banda_view.dart';
import 'package:musicshow/views/lists/lista_repertorio_view.dart';
import 'package:musicshow/views/lists/lista_usuario_banda_view.dart';
import 'package:musicshow/views/lists/lista_usuario_view.dart';
import 'package:musicshow/views/pdf_musica_view.dart';

class AppRoutes {
  static const HOME = "/home";

  static const LOGIN = "/login";
  static const PDF_MUSICA = "/pdf-musica";
  static const USER_CADAS = "/cadastrar";

  static const USER_LIST = "/listar-usuarios";
  static const USER_FORM = "/formulario-usuario";

  static const BANDA_LIST = "/listar-bandas";
  static const BANDA_FORM = "/formulario-banda";

  static const REPERT_LIST = "/listar-repertorios";
  static const REPERT_FORM = "/formulario-repertorio";

  static const MUSICA_LIST = "/listar-musicas";
  static const MUSICA_FORM = "/formulario-musica";

  static const USER_BANDA_LIST = "/listar-usuario-banda";
  static const USER_BANDA_FORM = "/formulario-usuario-banda";

  static const BANDA_MUSICA_LIST = "/listar-banda-musica";
  static const BANDA_MUSICA_FORM = "/formulario-banda-musica";
}

Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.HOME: (_) => HomeView(),
  AppRoutes.LOGIN: (_) => LoginUsuarioView(),
  AppRoutes.PDF_MUSICA: (_) => PdfMusicaView(),
  AppRoutes.USER_CADAS: (_) => CadastroUsuarioView(),
  AppRoutes.USER_LIST: (_) => ListaUsuarioView(),
  AppRoutes.USER_FORM: (_) => FormUsuarioView(),
  AppRoutes.BANDA_LIST: (_) => ListaBandaView(),
  AppRoutes.BANDA_FORM: (_) => FormBandaView(),
  AppRoutes.REPERT_LIST: (_) => ListaRepertorioView(),
  AppRoutes.REPERT_FORM: (_) => FormRepertorioView(),
  AppRoutes.MUSICA_LIST: (_) => ListaMusicaView(),
  AppRoutes.MUSICA_FORM: (_) => FormMusicaView(),
  AppRoutes.USER_BANDA_LIST: (_) => ListaUsuarioBandaView(),
  AppRoutes.USER_BANDA_FORM: (_) => FormUsuarioBandaView(),
  AppRoutes.BANDA_MUSICA_LIST: (_) => ListaBandaMusicaView(),
  AppRoutes.BANDA_MUSICA_FORM: (_) => FormBandaMusicaView(),
};
