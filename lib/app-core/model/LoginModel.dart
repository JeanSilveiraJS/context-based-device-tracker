class LoginModel {
  String login;
  String senha;
  bool salvarLogin;

  LoginModel({required this.login, required this.senha, required this.salvarLogin});

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'senha': senha,
    };
  }

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      login: json['login'],
      senha: json['senha'],
      salvarLogin: json['salvarLogin'] == false,
    );
  }
}
