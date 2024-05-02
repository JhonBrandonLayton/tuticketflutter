import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tuticket/inicio_sesion.dart';
import 'package:tuticket/textfield_personalizado.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Registrarse',
      home: SignupForm(), 
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _numeroController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _numeroController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bienvenido a TUTICKET',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Compra, reserva y disfruta eventos de todo tipo',
              style: TextStyle(fontSize: 14.0, color: Color.fromARGB(255, 117, 117, 13)),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFieldPersonalizado(labelText: 'Nombres', controller: _nombresController),
            const SizedBox(height: 20.0),
            TextFieldPersonalizado(labelText: 'Apellidos', controller: _apellidosController),
            const SizedBox(height: 20.0),
            TextFieldPersonalizado(labelText: 'Numero', controller: _numeroController),
            const SizedBox(height: 20.0),
            TextFieldPersonalizado(labelText: 'Correo', controller: _emailController),
            const SizedBox(height: 20.0),
            TextFieldPersonalizado(labelText: 'Contraseña', controller: _passwordController),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  String nombres = _nombresController.text.trim();
                  String apellidos = _apellidosController.text.trim();
                  String numero = _numeroController.text.trim();
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();

                  // Replace with your own validation logic
                  if (email.isEmpty ||
                      password.isEmpty ||
                      nombres.isEmpty ||
                      apellidos.isEmpty ||
                      numero.isEmpty) {
                    throw Exception('Ingresa toda la info.');
                  }

                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Registro exitoso!'),
                    ),
                  );
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'email-already-in-use') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email ya en uso.'),
                      ),
                    );
                  } else if (e.code == 'invalid-email') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Formato de email incorrecto.'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Fallo en el registro. Intente de nuevo.'),
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
              child: const Text('REGISTRARSE'),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ya tienes cuenta?',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                  },
                  child: const Text('INICIAR SESIÓN'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
