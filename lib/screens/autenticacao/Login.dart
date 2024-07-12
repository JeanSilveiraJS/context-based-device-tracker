import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gps_device_manager/main.dart';
import 'package:http/http.dart' as http;

import '../Home.dart';
import 'Cadastro.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String senha = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    onSaved: (valor) {
                      email = valor!;
                    },
                    autofocus: true,
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Digite um email válido';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'exemplo@email.com'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Digite uma senha';
                      }
                      return null;
                    },
                    onSaved: (valor) {
                      senha = valor!;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Senha'),
                  ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.all(15),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _login(email, senha);
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Cadastro()));
                    },
                    child: const Text(
                      'Crie sua conta',
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login(String login, String senha) async {
    var url = Uri.parse('${Globals.httpServerUrl}/login');
    var request = http.MultipartRequest('POST', url)
      ..fields['login'] = login
      ..fields['senha'] = senha;

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    //TODO: Tratar o retorno do servidor
    switch (response.statusCode) {
      case 200: // Sucesso
      case 302: // Redirecionamento, tratar conforme necessário
        //Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));
      _showSnackBar("LOGIN OK.");
        break;
      case 400: // Requisição inválida
        _showSnackBar("Requisição inválida.");
        break;
      case 401: // Não autorizado
      case 403: // Proibido
        _showSnackBar("Acesso negado.");
        break;
      case 404: // Não encontrado
        _showSnackBar("Serviço não encontrado.");
        break;
      case 500: // Erro interno do servidor
        _showSnackBar("Erro interno do servidor.");
        break;
      default: // Outros códigos não tratados especificamente
        _showSnackBar("Erro desconhecido: ${response.statusCode}");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
