import 'dart:io';

import 'package:flutter/material.dart';

// Widget per mostrar la imatge del producte
class ProductImage extends StatelessWidget {
  final String? url;
  const ProductImage({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(right: 10, left: 10, top: 10), // espaiat exterior
      child: Container(
        decoration: _buildBoxDecoration(),
        width: double.infinity,
        height: 450, // mida de la imatge
        child: Opacity(
          opacity: 0.9, // lleugera transparència
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25)), // cantonades arrodonides
              child: getImage(url) // obtenció de la imatge
              ),
        ),
      ),
    );
  }

  // mètode per definir la decoració del contenidor de la imatge
  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.black, // color de fons
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25)), // cantonades arrodonides
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10, // difuminació de l'ombra
              offset: Offset(0, 5), // posició de l'ombra
            )
          ]);

// mètode per determinar quina imatge mostrar
Widget getImage(String? url) {
  return FadeInImage(
    placeholder: AssetImage('assets/jar-loading.gif'), // Imagen de carga
    image: (url != null && url.isNotEmpty) 
      ? NetworkImage(url) // Imagen obtenida de la URL si está disponible
      : AssetImage('assets/jar-loading.gif') as ImageProvider, // Si la URL está vacía, solo muestra el placeholder
    fit: BoxFit.cover,
  );
}}
