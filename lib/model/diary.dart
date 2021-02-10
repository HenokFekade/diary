import 'package:diary/database/db_connector.dart';
import 'package:sqflite/sqlite_api.dart';

class Diary {
  int _id;
  int _day;
  int _monthYearId;
  String _diary;
  String _timestamp;

  Diary({int id, String diary, int day, String timestamp, int monthYearId}) {
    this._diary = diary;
    this._id = id;
    this._day = day;
    this._timestamp = timestamp;
    this._monthYearId = monthYearId;
  }

  String get diary => this._diary;

  int get id => this._id;

  int get day => this._day;

  int get monthYearId => this._monthYearId;

  String get timestamp => this._timestamp;

  set diary(String value) {
    _diary = value;
  }

  Future<Database> _getDBInstance() async {
    return await DBConnector().instance();
  }

  Map<String, dynamic> _toJson() {
    Map<String, dynamic> map = {
      'month_year_id': this._monthYearId,
      'day': this._day,
      'diary': this._diary
    };
    return map;
  }

  Diary _fromJson(Map<String, dynamic> map) {
    return Diary(
      id: map['id'],
      diary: map['diary'],
      monthYearId: map['month_year_id'],
      day: map['day'],
      timestamp: map['timestamp'],
    );
  }

  Future<List<Diary>> getAll() async {
    Database database = await this._getDBInstance();
    List<Map<String, dynamic>> data = await database.query('diaries');
    List<Diary> diaries = [];
    for (Map map in data) {
      Diary diary = this._fromJson(map);
      diaries.add(diary);
    }
    await database.close();
    return diaries;
  }

  Future<List<Diary>> get(String where, List whereArg) async {
    Database database = await this._getDBInstance();
    List<Map<String, dynamic>> data = await database.rawQuery(
        'SELECT id, month_year_id, day, diary, timestamp FROM diaries WHERE $where',
        whereArg);
    List<Diary> diaries = [];
    for (Map value in data) {
      Diary diary = Diary()._fromJson(value);
      diaries.add(diary);
    }
    await database.close();
    return diaries;
  }

  Future<int> create() async {
    Database database = await this._getDBInstance();
    int id = await database.insert('diaries', this._toJson());
    await database.close();
    return id;
  }

  Future<int> update() async {
    Database database = await this._getDBInstance();
    print(this._diary);
    Map<String, dynamic> map = {'diary': this._diary};
    int id = await database
        .update('diaries', map, where: 'id = ?', whereArgs: [this._id]);
    print(this._diary);
    await database.close();
    return id;
  }
}
