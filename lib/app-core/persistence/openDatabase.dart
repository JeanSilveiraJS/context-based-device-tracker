import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gps_device_manager/app-core/persistence/LoginPersistence.dart';

Future<Database> getDatabase() async {
  return openDatabase(join(await getDatabasesPath(), 'gps_manager.db'),
      onCreate: (db, version) async {
    List<String> queryes = [LoginPersistence.createTabelaUsuario];

    print('getDatabasesPath(): ' + getDatabasesPath().toString());
    for (String sql in queryes) {
      print('sql: ' + sql);

      db.execute(sql);
    }
  }, version: 1);
}
