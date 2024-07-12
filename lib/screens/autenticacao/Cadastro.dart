import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gps_device_manager/screens/autenticacao/Login.dart';

import '../../main.dart';
import '../Home.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  final _formKey = GlobalKey<FormState>();

  String nome = '';
  String email = '';
  String senha = '';

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 15),
                  child:  TextFormField(
                    autofocus: true,
                    onSaved: (valor){
                      nome = valor!;
                    },
                    validator: (valor){
                      if(valor == null || valor.isEmpty){
                        return 'Digite um nome válido';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome',
                        hintText: 'Nome Sobrenome'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15),
                  child:  TextFormField(
                    onSaved: (valor){
                      email = valor!;
                    },
                    validator: (valor){
                      if(valor == null || valor.isEmpty){
                        return 'Digite um email válido';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'nome@mail.com'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom:15),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child:  TextFormField(
                    onSaved: (valor){
                      senha = valor!;
                    },
                    validator: (valor){
                      if(valor == null || valor.isEmpty){
                        return 'Digite uma senha';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Senha'),
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
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _formKey.currentState!.save();
                        _cadastrar(nome, email, senha);
                      }
                    },
                    child: Text(
                      'Cadastrar',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text(
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
  _cadastrar(String nome, String login, String senha) async {
    var url = Uri.parse('${Globals.httpServerUrl}/usuario');
    var response = await http.post(url, body: {
      'nome': nome,
      'login': login,
      'senha': senha,
    });

    if(response.statusCode == 200){
      // Cadastro bem-sucedido, redirecionar para a tela de login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        (route) => false,
      );
    } else {
      // Cadastro mal-sucedido, exibir mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar usuário'),
        ),
      );
    }
  }
}