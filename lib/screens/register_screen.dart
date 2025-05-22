import 'package:examen_final2_covas/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:examen_final2_covas/providers/login_form_provider.dart';
import 'package:examen_final2_covas/ui/input_decorations.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart';

// classe que representa la pantalla de registre d'un nou usuari
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // permet desplaçar-se si el contingut és llarg
        child: Column(
          children: [
            const SizedBox(height: 250), // espaiat superior
            CardContainer(
              // contenidor estilitzat per mostrar el formulari
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Registro',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 30),
                  ChangeNotifierProvider(
                    // proveidor per gestionar l'estat del formulari
                    create: (_) => LoginFormProvider(),
                    child:
                        const _RegisterForm(), // component que conté el formulari de registre
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              // text que si feim click ens permet anar a la pantalla de login
              onTap: () => Navigator.pushReplacementNamed(context, 'login'),
              child: const Text(
                '¿Ya tienes cuenta? Inicia sesión',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// classe privada que conté el formulari de registre
class _RegisterForm extends StatelessWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(
        context); // obté el proveidor del formulari

    return Container(
      child: Form(
        key: loginForm.formKey, // clau global per validar el formulari
        autovalidateMode: AutovalidateMode
            .onUserInteraction, // activa la validació automàtica en interacció
        child: Column(
          children: [
            TextFormField(
              // camp de correu electrònic
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_outlined,
              ),
              onChanged: (value) {
                loginForm.email = value;
                loginForm.notifyListeners(); // Actualiza el estado dinámico
              },
              validator: (value) {
                const pattern =
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$'; // patró de validació de correu electrònic
                final regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'No es un correo válido';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              // camp de contrasenya
              autocorrect: false,
              obscureText: true, // oculta el text intorduit per seguretat
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) {
                loginForm.password = value;
                loginForm.notifyListeners(); // notifica els canvis
              },
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe tener al menos 6 caracteres';
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey, // color quan el botó està desactivat
              elevation: 0,
              color: Colors.deepPurple, // color quan el botó està activat
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading ? 'Espere...' : 'Registrar',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              onPressed: loginForm.isLoading || !loginForm.isValidForm()
                  ? null
                  : () async {
                      FocusScope.of(context)
                          .unfocus(); // amaga el teclat virtual
                      await loginForm.registerWithFirebase(
                          context); // executa el registre de l'usuari a Firebase
                    },
            ),
          ],
        ),
      ),
    );
  }
}
