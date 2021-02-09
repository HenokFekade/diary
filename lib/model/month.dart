import 'package:diary/database/db_connector.dart';
import 'package:sqflite/sqflite.dart';

class Month {
  int _id;
  String _month;
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
}
