import 'package:gps_device_manager/services/AutenticacaoService.dart';

import 'AgenteModel.dart';

class SituacaoModel {
  final int id;
  final int? idUsuario;
  final String nome;
  final String descricao;
  final DateTime dataInicio;
  final DateTime dataFim;
  final List<AgenteModel> agentes;

  SituacaoModel({
    required this.id,
    this.idUsuario,
    required this.nome,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    required this.agentes,
  });

  SituacaoModel.criar(
      {required this.nome,
      required this.descricao,
      required this.dataInicio,
      required this.dataFim,
      int? id,
      int? idUsuario,
      AgenteModel? agente})
      : id = id ?? 0,
        idUsuario = AutenticacaoService().getUsuarioLogado()?.id,
        agentes = agente != null ? [agente] : [];

  factory SituacaoModel.fromJson(Map<String, dynamic> json, int idUsuario) {
    return SituacaoModel(
      id: json['id'],
      idUsuario: idUsuario,
      nome: json['nome'],
      descricao: json['descricao'],
      dataInicio: DateTime.parse(json['data_inicio']),
      dataFim: DateTime.parse(json['data_fim']),
      agentes: List<AgenteModel>.from(
          json['agentes'].map((x) => AgenteModel.fromJson(x, json['id']))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_usuario': idUsuario,
      'nome': nome,
      'descricao': descricao,
      'data_inicio': dataInicio.toIso8601String(),
      'data_fim': dataFim.toIso8601String(),
      'agentes': List<dynamic>.from(agentes.map((x) => x.toJson())),
    };
  }

  @override
  String toString() {
    return 'SituacaoModel{'
        'id: $id, '
        'id_usuario: $idUsuario, '
        'nome: $nome, '
        'descricao: $descricao, '
        'dataInicio: $dataInicio, '
        'dataFim: $dataFim, '
        'agentes: $agentes}';
  }
}
