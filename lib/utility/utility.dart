import 'dart:convert';
import 'dart:math';

import 'package:diary/database/db_connector.dart';
import 'package:intl/intl.dart';
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

  static String dateFormatter(String dateTime) {
    DateTime _dateTime = DateTime.parse(dateTime);
    DateFormat dateFormat = DateFormat('EEE,  dd  MMM  yyyy');
    return dateFormat.format(_dateTime);
  }

  static String randomString(int length) {
    return Utility._randGenerateFirst(length) +
        Utility._randGenerateSecond(length);
  }

  static String _randGenerateFirst(int length) {
    var random = Random.secure();
    var values = List<int>.generate(length, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  static String _randGenerateSecond(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
