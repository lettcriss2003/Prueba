import 'package:flutter/material.dart';

import 'package:prueba/views/admin_view.dart';
import 'package:prueba/views/comentarioView.dart';
import 'package:prueba/views/comentariosListarView.dart';
import 'package:prueba/views/editAdmin.dart';
import 'package:prueba/views/editUser.dart';
import 'package:prueba/views/exception/Page404.dart';
import 'package:prueba/views/mapView.dart';
import 'package:prueba/views/mapViewInd.dart';

import 'package:prueba/views/registerView.dart';
import 'package:prueba/views/sessionView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SessionView(),
      initialRoute: "/",
      routes: {
        "/home": (context) => const SessionView(),
        "/registrarse": (context) => const RegisterView(),
        "/comments": (context) => const ComentarioView(),
        "/principal": (context) => NoticiasView(),
        "/editarPerfil": (context) => EditarPerfilScreen(),
        "/editarAdmin": (context) => EditarAdminScreen(),
        "/mapa": (context) => MapaComentariosView(),
        "/mapaInd": (context) => MapViewInd(),
        "/adminView": (context) => AdminView(),
      },
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => const Page404(),
      ),
    );
  }
}
