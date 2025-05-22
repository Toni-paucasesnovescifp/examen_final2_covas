import 'package:flutter/material.dart';
import '../models/models.dart';

// proveidor de formulari per gestionar l'estat del producte
class ProductFormProvider extends ChangeNotifier {
  // clau global per gestionar l'estat del formulari
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Product tempProduct; // objecte temporal de producte

  // constructor que inicialitza el proveidor amb un producte temporal
  ProductFormProvider(this.tempProduct);

  // mètode que verifica si el formulari és vàlid
  bool isValidForm() {
    print(tempProduct.nom);
    print(tempProduct.descripcio);
    print(tempProduct.disponible);

    // retorna un bool, segons si el formulari és valid o no
    return formKey.currentState?.validate() ?? false;
  }

  // mètode per actualitzar la disponibilitat del producte
  updateAvailability(bool value) {
    print(value);
    this.tempProduct.disponible = value;
    notifyListeners(); // notifica que hi ha hagut un canvi en l'estat del producte
  }
}
