import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/models/banda_musica_model.dart';

class PdfMusicaView extends StatelessWidget {
  const PdfMusicaView({super.key});

  @override
  Widget build(BuildContext context) {
    final BandaMusicaModel? bandaMusicaModel =
        ModalRoute.of(context)?.settings.arguments as BandaMusicaModel?;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${bandaMusicaModel?.ordem ?? 0} - ${bandaMusicaModel?.titulo ?? ""}"),
        backgroundColor: Cores.vermelho,
        foregroundColor: Cores.branco,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              _voltarPdf(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              _avancarPdf(context);
            },
          ),
        ],
      ),
      body: Center(
        child: HtmlWidget(
          '<iframe src="${bandaMusicaModel?.arquivo ?? ""}" width="412px" height="900px" style="border: none;"></iframe>',
        ),
      ),
    );
  }

  void _voltarPdf(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Voltar PDF")),
    );
  }

  void _avancarPdf(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Avançar PDF")),
    );
  }
}
