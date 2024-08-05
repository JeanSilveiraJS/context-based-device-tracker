import 'dart:convert';

import 'package:gps_device_manager/services/AbstractService.dart';

import '../app-core/model/UsuarioModel.dart';
import 'package:http/http.dart' as http;

class UsuarioService extends AbstractService {
  late final Uri url = Uri.parse('$apiRest/usuario');

  Future<UsuarioModel?> cadastrar(UsuarioModel usuario) async {
    var response = await http.post(url, headers: headers, body: jsonEncode(usuario));

    return response.statusCode == 201
        ? UsuarioModel.fromJson(jsonDecode(response.body))
        : null;
  }

  Future<UsuarioModel?> editar(UsuarioModel usuario) async {
    var response = await http.put(
      Uri.parse('$url/${usuario.id}'),
      headers: headers,
      body: jsonEncode(usuario),
    );

    return response.statusCode == 200
        ? UsuarioModel.fromJson(jsonDecode(response.body))
        : null;
  }

  Future<bool> excluir(UsuarioModel usuario) async {
    var response = await http.delete(Uri.parse('$url/${usuario.id}'), headers: headers);

    return response.statusCode == 200;
  }
}
