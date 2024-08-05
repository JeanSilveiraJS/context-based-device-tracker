class AgenteModel {
  final int id;
  final int id_situacao;
  final String nome;
  final String descricao;
  final double latitude;
  final double longitude;

  AgenteModel({
    required this.id,
    required this.id_situacao,
    required this.nome,
    required this.descricao,
    required this.latitude,
    required this.longitude,
  });

  AgenteModel.criar({
    required this.id_situacao,
    required this.nome,
    required this.descricao,
    required this.latitude,
    required this.longitude,
  }) : id = 0;


  factory AgenteModel.fromJson(Map<String, dynamic> json, [int? idSituacao]) {
    return AgenteModel(
      id: json['id'],
      id_situacao: idSituacao ?? json['id_situacao'],
      nome: json['nome'],
      descricao: json['descricao'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_situacao': id_situacao,
      'nome': nome,
      'descricao': descricao,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return 'AgenteModel{id: $id, nome: $nome, descricao: $descricao, latitute: $latitude, longitude: $longitude}';
  }
}
