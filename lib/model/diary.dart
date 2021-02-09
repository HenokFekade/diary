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

  Future<Database> _getDBInstance() async {
    return await DBConnector().instance();
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
    List<Diary> diarys = [];
    for (Map map in data) {
      Diary diary = this._fromJson(map);
      diarys.add(diary);
    }
    await database.close();
    return diarys;
  }
}
