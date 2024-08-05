import 'package:flutter/material.dart';
import 'package:gps_device_manager/app-core/persistence/LoginPersistence.dart';
import 'package:gps_device_manager/services/AutenticacaoService.dart';
import 'package:http/http.dart' as http;

import '../../app-core/model/LoginModel.dart';
import '../home.dart';
import 'Cadastro.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String senha;
  bool salvarLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login"),
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
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (valor) => email = valor ?? '',
                    validator: (valor) =>
                        valor?.isEmpty ?? true ? 'Digite um email válido' : null,
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
                    validator: (valor) =>
                        valor?.isEmpty ?? true ? 'Digite uma senha válida' : null,
                    obscureText: true,
                  ),
                ),
                CheckboxListTile(
                  title: const Text("Manter conectado"),
                  value: salvarLogin,
                  onChanged: (newValue) {
                    setState(() {
                      salvarLogin = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.all(15),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _login();
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
                          MaterialPageRoute(builder: (_) => const Cadastro()));
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Future<void> _login() async {
    if (await AutenticacaoService().login(LoginModel(login: email, senha: senha, salvarLogin: salvarLogin))) {

      if (mounted) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Home()), (route) => false);
        _showMessage("Login efetuado com sucesso");
      }

    } else {
      _showMessage("Erro no login. Tente novamente");
    }
  }
}
