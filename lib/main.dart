import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tuticket/inicio_sesion.dart';
import 'package:tuticket/textfield_personalizado.dart';
import 'firebase_options.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Registrarse',
      home: SignupForm(),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _numeroController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  double _buttonWidth = 160.0; // Ancho inicial del botón
  bool _isLoading = false; // Para controlar la visibilidad del SpinKit

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
        child: Stack(
          children: [
            Column(
              children: [
                TextField(
                  controller: _nombresController,
                  decoration: InputDecoration(labelText: 'Nombres'),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _apellidosController,
                  decoration: InputDecoration(labelText: 'Apellidos'),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _numeroController,
                  decoration: InputDecoration(labelText: 'Número'),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Correo'),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                ),
                const SizedBox(height: 30.0),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: _buttonWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[400], // Color de fondo del botón
                  ),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        _isLoading = true; // Mostrar SpinKit al iniciar acción
                      });

                      try {
                        String nombres = _nombresController.text.trim();
                        String apellidos = _apellidosController.text.trim();
                        String numero = _numeroController.text.trim();
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();

                        // Reemplaza con tu lógica de validación
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
                              content: Text('Fallo en el registro. Intente de nuevo.'),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      } finally {
                        setState(() {
                          _isLoading = false; // Ocultar SpinKit al finalizar acción
                        });
                      }
                    },
                    onTapDown: (_) {
                      setState(() {
                        _buttonWidth = 220.0; // Ancho más grande al presionar
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        _buttonWidth = 200.0; // Volver al ancho inicial al cancelar el toque
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _buttonWidth = 200.0; // Volver al ancho inicial al soltar el toque
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      child: Text(
                        'REGISTRARSE',
                        style: TextStyle(
                          color: Colors.white, // Color del texto del botón
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ya tienes cuenta?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: _buttonWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Color.fromARGB(255, 204, 180, 42), // Color de fondo del botón
                      ),
                      child: InkWell(
                        onTap: () async {
                          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                          setState(() {
                            _isLoading = true; // Mostrar SpinKit al iniciar acción
                          });

                          // Simula una operación de inicio de sesión
                          await Future.delayed(Duration(seconds: 2));

                          // Restaura el estado del botón
                          setState(() {
                            _isLoading = false; // Ocultar SpinKit al finalizar acción
                          });
                        },
                        onTapDown: (_) {
                          setState(() {
                            _buttonWidth = 220.0; // Ancho más grande al presionar
                          });
                        },
                        onTapCancel: () {
                          setState(() {
                            _buttonWidth = 200.0; // Volver al ancho inicial al cancelar el toque
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            _buttonWidth = 200.0; // Volver al ancho inicial al soltar el toque
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                          child: Text(
                            'INICIAR SESIÓN',
                            style: TextStyle(
                              color: Colors.white, // Color del texto del botón
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Image.asset(
                  '../assets/tiqueta5.png',
                  width: 280, // Ancho deseado
                  height: 280, // Alto deseado
                ),
              ],
            ),
            if (_isLoading)
              Container(
                color: Color.fromARGB(255, 238, 255, 0).withOpacity(0.50),
                child: Center(
                  child: SpinKitSpinningLines(
                    color: Color.fromARGB(255, 180, 19, 159),
                    size: 50.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
