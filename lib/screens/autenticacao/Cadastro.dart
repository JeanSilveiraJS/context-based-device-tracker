import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gps_device_manager/services/UsuarioService.dart';
import 'package:http/http.dart' as http;

import 'package:gps_device_manager/screens/autenticacao/Login.dart';

import '../../app-core/model/UsuarioModel.dart';
import '../../main.dart';
import '../home.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _formKey = GlobalKey<FormState>();

  late String nome;
  late String email;
  late String senha;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Cadastro"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (valor) => nome = valor ?? '',
                    validator: (valor) =>
                        valor?.isEmpty ?? true ? 'Digite um nome válido' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (valor) => email = valor ?? '',
                    validator: (valor) => valor?.isEmpty ?? true
                        ? 'Digite um email válido'
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (valor) => senha = valor ?? '',
                    validator: (valor) => valor?.isEmpty ?? true
                        ? 'Digite uma senha válida'
                        : null,
                    obscureText: true,
                  ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.all(15),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _cadastrar();
                      }
                    },
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: const Text(
                    'Já tenho uma conta',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _cadastrar() async {
    final response = await UsuarioService().cadastrar(UsuarioModel.persistence(nome: nome, login: email, senha: senha));

    if (response != null) {
      _showMessage('Cadastro realizado com sucesso');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } else {
      _showMessage('Erro ao realizar cadastro');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
