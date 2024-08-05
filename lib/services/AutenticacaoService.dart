import 'dart:convert';

import 'package:gps_device_manager/services/AbstractService.dart';
import 'package:http/http.dart' as http;

import '../app-core/model/LoginModel.dart';
import '../app-core/model/UsuarioModel.dart';
import '../app-core/persistence/LoginPersistence.dart';

class AutenticacaoService extends AbstractService {
  static final AutenticacaoService _singleton = AutenticacaoService._internal();

  factory AutenticacaoService() {
    return _singleton;
  }

  late final Uri url = Uri.parse('$apiRest/login');
  UsuarioModel? usuarioLogado;

  UsuarioModel? getUsuarioLogado() {
    return usuarioLogado;
  }

  Future<bool> login(LoginModel dados) async {
    var response = await http.post(url,
        headers: headers, body: jsonEncode(dados.toJson()));

    if (response.statusCode == 200) {
      if (dados.salvarLogin) {
        await LoginPersistence().salvar(dados.login, dados.senha);
      }
      var usuarioJson = jsonDecode(response.body);
      usuarioLogado = UsuarioModel.fromJson(usuarioJson);
      print('Usuário logado: ' + getUsuarioLogado()!.nome);
      return true;
    }
    return false;
  }

  Future<bool> logout() async {
    var response = await http.get(Uri.parse('$url/logout'));

    if (response.statusCode == 200) {
      await LoginPersistence().logout();
      usuarioLogado = null;
      return true;
    }

    return false;
  }

  AutenticacaoService._internal();
}
