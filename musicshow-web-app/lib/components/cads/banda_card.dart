import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';
import 'package:musicshow/models/banda_model.dart';
import 'package:musicshow/routes/app_routes.dart';

class BandaCard extends StatelessWidget {
  final BandaModel bandaModel;

  const BandaCard(this.bandaModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Cores.branco,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    bandaModel.nome ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.USER_BANDA_LIST,
                            arguments: bandaModel,
                          );
                        },
                        icon: Icon(Icons.person, color: Cores.cinzaEscuro),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Repertórios: ${bandaModel.qtdRepertorio ?? 0}"),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.REPERT_LIST,
                            arguments: bandaModel,
                          );
                        },
                        icon:
                            Icon(Icons.arrow_forward, color: Cores.cinzaEscuro),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
