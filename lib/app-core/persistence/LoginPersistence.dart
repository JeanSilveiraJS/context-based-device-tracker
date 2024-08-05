import 'package:gps_device_manager/app-core/model/LoginModel.dart';
import 'package:gps_device_manager/services/AutenticacaoService.dart';
import 'package:sqflite/sqflite.dart';

import 'openDatabase.dart';

class LoginPersistence {
  static const _tabela = 'usuario';
  static const _col_login = 'login';
  static const _col_senha = 'senha';

  static const String createTabelaUsuario = '''
    CREATE TABLE $_tabela (
      id INTEGER PRIMARY KEY,
      $_col_login TEXT NOT NULL UNIQUE,
      $_col_senha TEXT NOT NULL
    )
  ''';

  salvar(String login, String senha) async {
    final db = await getDatabase();

    await db.insert(
        _tabela,
        {
          _col_login: login,
          _col_senha: senha,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> logout() async {
    final db = await getDatabase();
    await db.delete(_tabela);
  }

  checkLoginAuto() async {
    final db = await
    getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tabela);

    if (maps.isNotEmpty) {
      await AutenticacaoService().login(LoginModel.fromJson(maps.first));
      print('Usuário logado: ' + AutenticacaoService().getUsuarioLogado()!.nome);
    }
  }
}
