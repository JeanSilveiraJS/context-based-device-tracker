import 'package:flutter/material.dart';
import 'package:gps_device_manager/services/AutenticacaoService.dart';

import 'screens/home.dart';
import 'screens/autenticacao/Login.dart';

import 'app-core/persistence/LoginPersistence.dart';

import 'app-core/model/UsuarioModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LoginPersistence().checkLoginAuto();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gerenciador de Dispositivos GPS',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.lightGreen, secondary: Colors.lightGreenAccent),
          useMaterial3: true,
        ),
        home: AutenticacaoService().getUsuarioLogado() == null ? const Login() : const Home());
  }
}
