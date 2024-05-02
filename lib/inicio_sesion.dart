// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuticket/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          children: [
            const Text(
              'Para continuar, ingresa tus credenciales:',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                hintText: 'ejemplo@correo.com',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                hintText: 'Ingresa tu contraseña',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    throw Exception('Ingresa toda la info.');
                  }

                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email, password: password
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Inicio de sesión exitoso!'),
                    ),
                  );
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('email incorrecto'),
                      ),
                    );
                  } else if (e.code == 'wrong-password') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contraseña incorrecta'),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
              child: const Text('INICIAR SESIÓN'),
            ),
          ],
        ),
      ),
    );
  }
}


