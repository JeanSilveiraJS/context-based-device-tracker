import 'package:flutter/material.dart';
import 'package:gps_device_manager/screens/autenticacao/Login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen, secondary: Colors.lightGreenAccent),
          useMaterial3: true,
        ),
        home: const Login()
    );
  }
}

class Globals {
  //TODO: modificar para o ip da máquina / servidor
  static const String httpServerUrl = 'http://10.0.2.2:8080';
}