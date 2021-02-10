import 'package:diary/database/db_connector.dart';
import 'package:sqflite/sqflite.dart';

import 'diary.dart';

class Month {
  int _id;
  String _month;
  List<Diary> diaries = [];
  static List<String> monthsList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  Month({int id, String month}) {
    this._id = id;
    this._month = month;
  }

  int get id => this._id;

  String get month => this._month;

  Future<Database> _getDBInstance() async {
    return await DBConnector().instance();
  }

  Month _fromJson(Map<String, dynamic> map) {
    return Month(
      id: map['id'],
      month: map['month'],
    );
  }

  Map<String, dynamic> _toJson() {
    return {
      'month': this.month,
    };
  }

  Future<List<Month>> getAll() async {
    Database database = await this._getDBInstance();
    List<Map<String, dynamic>> data = await database.query('months');
    List<Month> months = [];
    for (Map map in data) {
      Month month = this._fromJson(map);
      months.add(month);
    }
    await database.close();
    return months;
  }

  Future<List<Month>> get(String where, List<dynamic> whereArg) async {
    Database database = await this._getDBInstance();
    List<Map<String, dynamic>> data = await database.query(
      'months',
      where: where,
      whereArgs: whereArg,
    );
    List<Month> months = [];
    for (Map map in data) {
      Month month = this._fromJson(map);
      months.add(month);
    }
    await database.close();
    return months;
  }

  Future<int> create() async {
    Database database = await this._getDBInstance();
    int id = await database.insert('months', this._toJson());
    await database.close();
    return id;
  }
}
