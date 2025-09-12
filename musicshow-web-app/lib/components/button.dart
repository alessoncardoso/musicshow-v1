import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';

ButtonStyle getButtonStyle(bool elevated) {
  return ElevatedButton.styleFrom(
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    backgroundColor: Cores.preto,
    foregroundColor: Cores.branco,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

ButtonStyle getTextButtonStyle() {
  return TextButton.styleFrom(
    textStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    foregroundColor: Cores.cinzaEscuro,
  );
}
