import 'package:diary/database/db_connector.dart';
import 'package:sqflite/sqflite.dart';
import 'diary.dart';

class MonthYear {
  int _id;
  int _monthId;
  int _yearId;
  List<Diary> diaries = [];
  MonthYear({
    int id,
    int monthId,
    int yearId,
  }) {
    this._id = id;
    this._monthId = monthId;
    this._yearId = yearId;
  }

  int get id => this._id;

  int get monthId => this._monthId;

  int get yearId => this._yearId;

  Future<Database> _getDBInstance() async {
    return await DBConnector().instance();
  }

  Map<String, dynamic> _toJson() {
    return {'month_id': this._monthId, 'year_id': this._yearId};
  }

  MonthYear _fromJson(Map<String, dynamic> map) {
    return MonthYear(
      id: map['id'],
      monthId: map['month_id'],
      yearId: map['year_id'],
    );
  }

  Future<List<MonthYear>> getAll() async {
    Database database = await this._getDBInstance();
    List<Map<String, dynamic>> data = await database.query('month_years');
    List<MonthYear> monthYears = [];
    for (Map map in data) {
      MonthYear monthYear = this._fromJson(map);
      monthYears.add(monthYear);
    }
    await database.close();
    return monthYears;
  }

  Future<List<MonthYear>> get(String where, List whereArg) async {
    Database database = await this._getDBInstance();
    ;
    List<Map<String, dynamic>> data = await database.rawQuery(
        'SELECT id, month_id, year_id FROM month_years WHERE $where', whereArg);
    List<MonthYear> monthYears = [];
    for (Map map in data) {
      MonthYear monthYear = this._fromJson(map);
      monthYears.add(monthYear);
    }
    await database.close();
    return monthYears;
  }

  Future<int> create() async {
    Database database = await this._getDBInstance();
    int lastId = await database
        .query('month_years', columns: ['id'], orderBy: 'id DESC')
        .then((value) {
      if (value.isNotEmpty) return value.first['id'];
      return null;
    });
    Map<String, dynamic> map = this._toJson();
    map['id'] = (lastId == null) ? 1 : lastId + 1;
    int id = await database.insert('month_years', map);
    await database.close();
    return id;
  }
}
