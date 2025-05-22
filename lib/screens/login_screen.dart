import 'package:flutter/material.dart';
import 'package:examen_final2_covas/preferences/preferences.dart';
import 'package:examen_final2_covas/providers/login_form_provider.dart';
import 'package:examen_final2_covas/ui/input_decorations.dart';
import 'package:examen_final2_covas/widgets/widgets.dart';
import 'package:provider/provider.dart';

// classe que representa la pantalla d'inici de s4essió
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250), // espaiat superior
              CardContainer(
                // contenidor de la targeta amb el formulari
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Login', // titol de la pantalla
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 30),
                    ChangeNotifierProvider(
                      // proveidor per gestionar l'estat del formulari
                      create: (_) => LoginFormProvider(),
                      child:
                          _LoginForm(), // component que conté el formulari de login
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              GestureDetector(
                // enllaç per anar a la pantalla de registre
                onTap:
                    () => Navigator.pushReplacementNamed(context, 'register'),
                child: Text(
                  'Crear un nou compte',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// classe privada que conté el formulari d'inici de sessió
class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(
      context,
    ); // obté el proveidor del formulari

    if (Preferences.email.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, 'home');
      });
    }

    //    WidgetsBinding.instance.addPostFrameCallback((_)  {
    //     loginForm.email = loginForm.emailController.text;
    //     loginForm.password = loginForm.passwordController.text;
    //     loginForm.notifyListeners();

    // no d'executa, hi ha un condicional 7==8
    //   if ( Preferences.email.isNotEmpty) {
    //      FocusScope.of(context).unfocus();
    // Executar login
    //      loginForm.loginWithFirebase(context);

    //    }
    //   });

    return Container(
      child: Form(
        key: loginForm.formKey, // clau global per validar el formulari
        autovalidateMode:
            AutovalidateMode
                .onUserInteraction, // validació automàtica en interacció
        child: Column(
          children: [
            TextFormField(
              // camp de correu electrònic
              autocorrect: false,
              controller: loginForm.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_outlined,
              ),
              onChanged: (value) {
                loginForm.email = value;
                loginForm.notifyListeners(); // Notifica els canvis
              },

              validator: (value) {
                String pattern =
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$'; // Patró simplificat per email
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : value!.isNotEmpty
                    ? 'No es un correo válido'
                    : '';
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              // camp de contrasenya
              controller: loginForm.passwordController,
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) {
                loginForm.password = value;
                loginForm.notifyListeners(); // Notifica els canvis
              },
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : (value!.isNotEmpty)
                    ? 'La contraseña debe tener al menos 6 caracteres'
                    : '';
              },
            ),
            SizedBox(height: 30), // botó d'inici de sessió
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey, // Botón deshabilitat
              elevation: 0,
              color: Colors.deepPurple, // Botón habilitat
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading ? 'Espere...' : 'Iniciar sesión',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              // S' adapta perquè estigui deshabilitat si els camps no són vàl.lids
              onPressed:
                  loginForm.isLoading || !loginForm.isValidForm()
                      ? null
                      : () async {
                        // tanca el teclat virtual
                        FocusScope.of(context).unfocus();
                        // Executar login
                        await loginForm.loginWithFirebase(context);
                      },
            ),
          ],
        ),
      ),
    );
  }
}
