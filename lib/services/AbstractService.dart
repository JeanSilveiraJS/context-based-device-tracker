import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

import '../app-core/model/UsuarioModel.dart';
import '../app-core/persistence/LoginPersistence.dart';
import '../main.dart';

import 'package:http/http.dart' as http;

import '../screens/autenticacao/Login.dart';

abstract class AbstractService {
  //TODO: modificar para o ip da máquina / servidor
  //final String apiRest = 'http://10.0.2.2:8080';
  //final String apiRest = 'http://172.16.9.210:8080';
  final String apiRest = 'http://192.168.0.11:8080';

  final Map<String, String> headers = <String,String>{
    'Content-type':'application/json',
  };
}
