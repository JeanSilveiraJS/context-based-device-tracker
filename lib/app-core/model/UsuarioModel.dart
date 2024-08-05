import 'package:gps_device_manager/app-core/model/SituacaoModel.dart';

class UsuarioModel {
  final int id;
  final String nome;
  final String login;
  final String senha;
  final List<SituacaoModel>? situacoes;

  UsuarioModel({
    required this.id,
    required this.nome,
    required this.login,
    required this.senha,
    this.situacoes,
  });

  UsuarioModel.persistence({
    required this.nome,
    required this.login,
    required this.senha
  }) : id = 0, situacoes = [];

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      nome: json['nome'],
      login: json['login'],
      senha: json['senha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'login': login,
      'senha': senha,
      'situacoes': situacoes?.map((i) => i.toJson()).toList(),
    };
  }

  Map<String, dynamic> persistenceToJson() {
    return {
      'nome': nome,
      'login': login,
      'senha': senha,
    };
  }

  @override
  String toString() {
    return 'UsuarioModel{id: $id, nome: $nome, login: $login, senha: $senha, situacoes: $situacoes}';
  }
}
