import 'dart:convert';

import 'package:gps_device_manager/app-core/model/SituacaoModel.dart';

import '../app-core/model/AgenteModel.dart';

import 'package:http/http.dart' as http;

import 'AbstractService.dart';

class AgenteService extends AbstractService {
  late final Uri url = Uri.parse('$apiRest/agente');

  Future<AgenteModel> criar(AgenteModel agente) async {
    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(agente.toJson()),
    );

    if (response.statusCode == 201) {
      return AgenteModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao crair agente');
    }
  }

  Future<List<AgenteModel>> listar(SituacaoModel situacao) async {
    var response = await http.get(
      Uri.parse('$url?id_situacao=${situacao.id}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var agentesJson = jsonDecode(response.body) as List;
      return agentesJson
          .map((agente) => AgenteModel.fromJson(agente))
          .toList();
    } else {
      throw Exception('Falha ao listar agentes');
    }
  }

  Future<AgenteModel> editar(AgenteModel agente) async {
    var response = await http.put(
      Uri.parse('$url/${agente.id}'),
      headers: headers,
      body: jsonEncode(agente.toJson()),
    );

    if (response.statusCode == 200) {
      return AgenteModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao editar agente');
    }
  }

  Future<bool> excluir(AgenteModel agente) async {
    var response =
        await http.delete(Uri.parse('$url/${agente.id}'), headers: headers);

    return response.statusCode == 200 ? true : false;
  }
}
