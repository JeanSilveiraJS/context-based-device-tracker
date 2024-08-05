import 'dart:convert';

import 'package:gps_device_manager/services/AutenticacaoService.dart';
import 'package:http/http.dart' as http;

import '../app-core/model/SituacaoModel.dart';
import '../app-core/model/UsuarioModel.dart';
import 'AbstractService.dart';

class SituacaoService extends AbstractService {
  late final url = Uri.parse('$apiRest/situacao');

  Future<List<SituacaoModel>?> listar(UsuarioModel usuario) async {
    var response = await http.get(Uri.parse('$url?id_usuario=${usuario.id}'),
        headers: headers);

    if (response.statusCode == 200) {
      var situacoesJson = jsonDecode(response.body) as List;
      return situacoesJson
          .map((situacao) =>
              SituacaoModel.fromJson(
                  situacao,
                  AutenticacaoService().getUsuarioLogado()!.id))
          .toList();
    } else {
      return null;
    }
  }

  Future<SituacaoModel> cadastrar(SituacaoModel situacao) async {
    var situacaoJson = jsonEncode(situacao.toJson());

    var response = await http.post(url, headers: headers, body: situacaoJson);

    if (response.statusCode == 200) {
      return SituacaoModel.fromJson(jsonDecode(response.body),
          AutenticacaoService().getUsuarioLogado()!.id);
    } else {
      throw Exception('Falha ao adicionar situação');
    }
  }

  Future<bool> editar(SituacaoModel situacao) async {
    var situacaoJson = situacao.toJson();
    var response =
        await http.put(url, headers: headers, body: jsonEncode(situacaoJson));

    if (response.statusCode != 200) {
      throw Exception('Falha ao editar situação');
    }
    return true;
  }

  Future<bool> deletar(List<SituacaoModel> situacoes, int index) async {
    var response = await http.delete(url);

    return response.statusCode == 200 ? true : false;
  }
}
