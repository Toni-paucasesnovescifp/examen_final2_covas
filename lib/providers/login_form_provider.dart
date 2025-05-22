import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:examen_final2_covas/preferences/preferences.dart';

// Clase que actúa com a proveidor d' estat pel formulario de login
class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordController;

  String email = '';
  String password = '';

  bool _isLoading =
      false; // se controla l'estat de càrrega per mostrar indicadors de progrés
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // notifica als listeners quan canvia l'estat de càrrega
  }


    LoginFormProvider() {
    // Inicializar los controladores con valores desde Preferences
    emailController = TextEditingController(text: Preferences.email);
    passwordController = TextEditingController(text: Preferences.password);
  }

  // verifica si el formulari és vàlid
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<void> loginWithFirebase(BuildContext context) async {
    if (!isValidForm()) return;

    isLoading = true;

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Usuario autenticado: ${userCredential.user?.email}');

          Preferences.email=email;
          Preferences.password=password;


      Navigator.pushReplacementNamed(context, 'home'); // Navega al home
    } on FirebaseAuthException catch (e) {
      print('Error en la autenticación: ${e.message}');
      // Mostra un SnackBar per informar d'usuari incorrecte
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Usuario incorrecto'),
          backgroundColor: Colors.red, // Color del fons del SnackBar
        ),
      );
    } finally {
      isLoading = false;
    }
  }
  // mètode per registrar un nou usuari a Firebase Autentication
  Future<void> registerWithFirebase(BuildContext context) async {
    if (!isValidForm()) return; // Verifica si el formulari es vàlid

    isLoading = true; // Indica que s'està carregant

    try {
      // Crea un nou usuari amb Firebase Authentication
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Usuario registrado: ${userCredential.user?.email}');
      // Navega al home després d'el registre exitós
      Navigator.pushReplacementNamed(context, 'home');
    } on FirebaseAuthException catch (e) {
      // mostra un missatge per pantalla i un snackbar si hi ha error
      print('Error en el registre: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error en el registre: ${e.message}'),
          backgroundColor: Colors.red, // Color del fons del SnackBar
        ),
      );
    } finally {
      isLoading = false; // Finalitza l'estado de carga
    }
  }
}
