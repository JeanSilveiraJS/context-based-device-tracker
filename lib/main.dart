import 'package:flutter/material.dart';
import 'package:gps_device_manager/screens/Login.dart';

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