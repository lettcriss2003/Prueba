import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:prueba/controls/servicio_back/FacadeService.dart';
import 'package:validators/validators.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController claveController = TextEditingController();

  void _register() {
    if (_formkey.currentState!.validate()) {
      Map<String, String> data = {
        "correo": correoController.text,
        "nombre": nombreController.text,
        "clave": claveController.text,
      };

      // Aquí llamas a tu servicio para registrar al usuario
      FacadeService().registro(data).then((response) {
        if (response.code == 200) {
          // Registro exitoso, puedes manejarlo aquí
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro exitoso, Inicie sesión para continuar'),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pushNamed(context, '/home');
        } else {
          // Manejar errores de registro aquí
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.msg),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "LAS MEJORES NOTICIAS",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Regístrese",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: correoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese su correo";
                  }
                  if (!isEmail(value)) {
                    return "Por favor, ingrese un correo válido";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  suffixIcon: Icon(Icons.email),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: nombreController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese su nombre";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  suffixIcon: Icon(Icons.person),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: claveController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese una clave";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Clave',
                  suffixIcon: Icon(Icons.lock),
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: _register,
                child: const Text('Registrar'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("¿Ya tienes una cuenta?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
