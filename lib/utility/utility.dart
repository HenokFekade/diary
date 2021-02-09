import 'package:diary/database/db_connector.dart';
import 'package:sqflite/sqlite_api.dart';

class Utility {
  static Future<void> dropAllTables() async {
    Database database = await DBConnector().instance();
    await database.execute('DROP TABLE IF EXISTS diaries');
    await database.execute('DROP TABLE IF EXISTS month_years');
    await database.execute('DROP TABLE IF EXISTS months');
    await database.execute('DROP TABLE IF EXISTS years');
    print('all table droped successfuly');
    await database.close();
  }
}
