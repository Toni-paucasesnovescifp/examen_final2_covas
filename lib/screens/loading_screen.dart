import 'package:flutter/material.dart';

// classe que gestiona una pantalla de càrrega
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productes'),
      ),
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.indigo, // indicador de càrrega amb color índigo
        ),
      ),
    );
  }
}
