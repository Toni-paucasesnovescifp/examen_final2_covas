import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:examen_final2_covas/preferences/preferences.dart';
import 'package:examen_final2_covas/screens/mapa_screen.dart';
import 'firebase_options.dart'; // Asegúrate de importar este archivo
import 'screens/screens.dart';
import 'services/products_service.dart';
import 'package:provider/provider.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inicialitza Flutter correctament abans de Firebase
  await Preferences.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Inicializació adaptada segons la plataforma
  );
  runApp(AppState());
}

// widget per gestionar l'estat global amb MultiProvider
class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductsService(),
        ),
      ],
      child: MyApp(),  // executa el widget principal de l'aplicació
    );
  }
}

// widget principal de l'aplicació
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ocula la bandera de depuració
      title: 'Productes App',
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginScreen(),
        'home': (_) => HomeScreen(),
        'register': (_) => RegisterScreen(),
        'product': (_) => ProductScreen(),
        'mapa': (_) => MapaScreen(),

      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300], 
      ),
    );
  }
}
