import 'package:diary/database/db_connector.dart';
import 'package:diary/model/month.dart';
import 'package:sqflite/sqlite_api.dart';

class Year {
  int _id;
  int _year;
  List<Month> months = [];

  Year({int id, int year}) {
    this._year = year;
    this._id = id;
  }

  int get year => this._year;

  int get id => this._id;

  Future<Database> _getDBInstance() async {
    return await DBConnector().instance();
  }

  Year _fromJson(Map<String, dynamic> map) {
    return Year(
      id: map['id'],
      year: map['year'],
    );
  }

  Future<List<Year>> getAll() async {
    Database database = await this._getDBInstance();
    List<Map<String, dynamic>> data = await database.query('years');
    List<Year> years = [];
    for (Map map in data) {
      Year year = this._fromJson(map);
      years.add(year);
    }
    await database.close();
    return years;
  }
}
