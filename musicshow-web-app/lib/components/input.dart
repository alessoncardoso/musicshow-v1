import 'package:flutter/material.dart';
import 'package:musicshow/colors/cores.dart';

InputDecoration getInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    fillColor: Cores.branco,
    //filled: true,
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: Cores.preto),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Cores.cinzaEscuro, width: 1.5),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Cores.preto, width: 2),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Cores.vermelhoClaro, width: 1.5),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Cores.vermelho, width: 2),
    ),
    errorStyle: TextStyle(color: Cores.vermelho),
    contentPadding: EdgeInsets.zero,
  );
}

InputDecoration getInputFormDecoration(String label) {
  return InputDecoration(
    labelText: label,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    fillColor: Cores.branco,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Cores.preto),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Cores.preto, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Cores.vermelho),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Cores.vermelho, width: 2),
    ),
    errorStyle: TextStyle(color: Cores.vermelho),
  );
}
