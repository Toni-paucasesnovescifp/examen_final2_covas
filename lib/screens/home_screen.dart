import 'package:examen_final2_covas/services/products_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:examen_final2_covas/preferences/preferences.dart';
import 'package:examen_final2_covas/screens/loading_screen.dart';
import 'package:examen_final2_covas/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../models/products.dart';
import '../services/services.dart';

// classe que representa la pantalla principal de l'aplicació
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final user = FirebaseAuth.instance.currentUser; // obté l'usuario autenticat
    final buttonBackgroundColor =
        Colors.grey[300]; // Color gris adaptado al diseño

    // mostra la pantalla de càrrega mentre es carreguen els productes
    if (productsService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50), // defineix l'altura del AppBar
        child: AppBar(
          title: Padding(
            padding:
                const EdgeInsets.only(top: 30), // Espaiat superior del títol
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Alineació a l'esquerra
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Alineació a la dreta
                  children: [
                    // Texte d'usuario
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        'User: ${user?.email ?? 'No disponible'}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    // Botó de logout
                    Container(
                      width: 40, // Mida del botó
                      height: 40,
                      decoration: BoxDecoration(
                        color: buttonBackgroundColor, // Fons gris
                        borderRadius:
                            BorderRadius.circular(20), // Bordes arrodonits
                        border: Border.all(
                            color: Colors.black, width: 2), // Borde negre
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero, // Sense padding interno
                        icon: Icon(Icons.logout,
                            color: Colors.black, size: 18), // Ícono de logout
                        onPressed: () async {
                          await FirebaseAuth.instance
                              .signOut(); // Tanca sessió de l'usuari
                          Preferences.email='';
                          Preferences.password='';
                          Navigator.pushReplacementNamed(
                              context, 'login'); // Torna a la pantalla de login
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8), // Espai entre productes
                Align(
                  alignment: Alignment.centerLeft, // Alienat a l'esquerra
                  child: Text(
                    'Productes', // Título
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ],
            ),
          ),
          automaticallyImplyLeading:
              false, // Evita el botón de tornar automàtic
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // alineació dels eleemnts
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0), // Espaiat del text
            child: Text(
              'Productes', // Títol en el cos de la pantalla
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  productsService.products.length, // nombre total de productes
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                child: ProductCard(
                  product: productsService
                      .products[index], // mostra el producte en una tarjeta
                ),
                onTap: () {
                  productsService.newPicture = null;
                  productsService.selectedProduct =
                      productsService.products[index].copy();
                  Navigator.of(context)
                      .pushNamed('product'); // navega a la pantalla de producte
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add), // icona per afegir un producte
        onPressed: () {
          // cream un producte amb valors predeterminats
          productsService.newPicture = null;
          productsService.selectedProduct = Product(
            disponible: true,
            nom: 'Producte nou',
            descripcio: '',
            tipus: '',
            restaurant: '',
            geo: '',
          );
          Navigator.of(context)
              .pushNamed('product'); // navega a la pantalla de producte
        },
      ),
    );
  }
}
