import 'package:flutter/material.dart';

// classe que gestiona el poder crear una decoració d'input personalitzada
class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText, // text suggerit dins el camp
    required String labelText, // etiqueta del camp
    IconData? prefixIcon,   // Icona prefix, no sempre és proporcionada
  }) {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.deepPurple, // color del borde quan no està seleccionada
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.deepPurple,  // color del bore quan està seleccionat
          width: 2,
        ),
      ),
      hintText: hintText,
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey),  // estil de l'etiqueta
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: Colors.deepPurple)
          : null,
    );
  }
}
