import 'package:flutter/material.dart';
import 'package:musicshow/providers/banda_musica_provider.dart';
import 'package:musicshow/providers/banda_provider.dart';
import 'package:musicshow/providers/musica_provider.dart';
import 'package:musicshow/providers/repertorio_provider.dart';
import 'package:musicshow/providers/usuario_banda_provider.dart';
import 'package:musicshow/providers/usuario_provider.dart';
import 'package:musicshow/routes/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => UsuarioProvider()),
        ChangeNotifierProvider(create: (ctx) => BandaProvider()),
        ChangeNotifierProvider(create: (ctx) => MusicaProvider()),
        ChangeNotifierProvider(create: (ctx) => RepertorioProvider()),
        ChangeNotifierProvider(create: (ctx) => BandaMusicaProvider()),
        ChangeNotifierProvider(create: (ctx) => UsuarioBandaProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music Show',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.LOGIN,
        routes: appRoutes,
      ),
    );
  }
}
