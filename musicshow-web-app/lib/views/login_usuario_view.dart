import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/components/input.dart';
import 'package:musicshow/components/button.dart';
import 'package:musicshow/providers/usuario_provider.dart';
import 'package:musicshow/routes/app_routes.dart';
import 'package:provider/provider.dart';

class LoginUsuarioView extends StatefulWidget {
  const LoginUsuarioView({super.key});

  @override
  State<LoginUsuarioView> createState() => _LoginUsuarioViewState();
}

class _LoginUsuarioViewState extends State<LoginUsuarioView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _senhaController;
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _senhaController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);
    final usuarioLogado = await usuarioProvider.autenticarUsuario(
      _emailController.text.trim().toLowerCase(),
      _senhaController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (usuarioLogado != null && mounted) {
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.HOME,
        arguments: usuarioLogado,
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("E-mail ou senha inválidos."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
                  const SizedBox(height: 20),
                  Image.asset("assets/images/music-red-black.png", height: 150),
                  const SizedBox(height: 20),
                  const Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Cores.preto,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    decoration: getInputDecoration("E-mail"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Digite seu e-mail.";
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                          .hasMatch(value)) {
                        return "Digite um e-mail válido.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _senhaController,
                    decoration: getInputDecoration("Senha").copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Digite sua senha.";
                      }
                      if (value.length < 8) {
                        return "Senha muito curta. No mínimo 8 caracteres.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _login,
                          style: getButtonStyle(true),
                          child: const Text("Entrar"),
                        ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.USER_CADAS);
                    },
                    style: getTextButtonStyle(),
                    child:
                        const Text("Ainda não possui uma conta? Cadastre-se"),
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
