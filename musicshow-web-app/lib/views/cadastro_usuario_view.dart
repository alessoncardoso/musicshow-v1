import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/components/input.dart';
import 'package:musicshow/components/button.dart';
import 'package:musicshow/models/usuario_model.dart';
import 'package:musicshow/providers/usuario_provider.dart';
import 'package:musicshow/routes/app_routes.dart';
import 'package:provider/provider.dart';

class CadastroUsuarioView extends StatefulWidget {
  const CadastroUsuarioView({super.key});

  @override
  State<CadastroUsuarioView> createState() => _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState extends State<CadastroUsuarioView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _isLoading = false;

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);

    final sucesso = await usuarioProvider.cadastrarUsuario(
      UsuarioModel(
        id: 0,
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text.trim(),
        dataCriacao: DateTime.now(),
        status: 1,
      ),
    );

    setState(() {
      _isLoading = false;
    });

    if (sucesso) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Erro ao cadastrar. Verifique os dados e tente novamente."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.branco,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Image.asset("assets/images/music-red-black.png", height: 150),
                  SizedBox(height: 20),
                  Text(
                    "Cadastro",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Cores.preto,
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _nomeController,
                    decoration: getInputDecoration("Nome"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Nome inválido.";
                      }
                      if (value.trim().length < 3) {
                        return "Nome muito curto. No mínimo 3 letras.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: getInputDecoration("E-mail"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "E-mail inválido.";
                      }
                      if (!value.contains("@")) {
                        return "Digite um e-mail válido.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _senhaController,
                    decoration: getInputDecoration("Senha"),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Senha inválida.";
                      }
                      if (value.length < 8) {
                        return "Senha muito curta. No mínimo 8 caracteres.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _cadastrar,
                          style: getButtonStyle(true),
                          child: Text("Cadastrar"),
                        ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.LOGIN);
                    },
                    style: getTextButtonStyle(),
                    child: Text("Já possui uma conta? Entre"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
