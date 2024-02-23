import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:prueba/controls/servicio_back/FacadeService.dart';
import 'package:prueba/controls/utiles/Utiles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SessionView(),
    );
  }
}

class SessionView extends StatefulWidget {
  const SessionView({Key? key}) : super(key: key);

  @override
  _SessionViewState createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final usuario = _emailController.text;
    final clave = _passwordController.text;

    if (usuario.isEmpty || clave.isEmpty) {
      SnackBar snackBar = SnackBar(
        content: const Text('Por favor, ingrese correo y contraseña'),
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // Validar correo y clave aquí
    if (!_isValidEmail(usuario)) {
      SnackBar snackBar = SnackBar(
        content: const Text('Por favor, ingrese un correo válido'),
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    FacadeService fs = FacadeService();
    Map<String, String> mapa = {
      "correo": usuario,
      "clave": clave,
    };
    fs.inicioSesion(mapa).then((value) async {
      if (value.code == 200) {
        Utiles utilidades = Utiles();
        utilidades.saveValue('token', value.datos['token']);
        utilidades.saveValue('usuario', value.datos['usuario']);
        FacadeService fs = FacadeService();
      } else {
        SnackBar snackBar = SnackBar(
          content: Text(value.tag),
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sitios',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Sitios unicos aquí!',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                suffixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: Icon(Icons.password),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Iniciar Sesión'),
                ),
                const SizedBox(width: 16.0),
                const Text("¿No tienes cuenta? "),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/registrarse");
                  },
                  child: const Text('Registrarse'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
