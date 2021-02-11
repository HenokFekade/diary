import 'package:diary/database/db_connector.dart';
import 'package:diary/utility/font_family.dart';
import 'package:sqflite/sqlite_api.dart';

class Diary {
  int _id;
  int _day;
  int _monthYearId;
  String _diary;
  int _fontSize;
  FontFamily _fontFamily;
  String _timestamp;
  Map<String, FontFamily> _fontFamilyMapper = {
    'FontFamily.Caveat': FontFamily.Caveat,
    'FontFamily.Cookie': FontFamily.Cookie,
    'FontFamily.Courgette': FontFamily.Courgette,
    'FontFamily.DancingScript': FontFamily.DancingScript,
    'FontFamily.IndieFlower': FontFamily.IndieFlower,
    'FontFamily.Lato': FontFamily.Lato,
    'FontFamily.LoversQuarrel': FontFamily.LoversQuarrel,
    'FontFamily.Montserrat': FontFamily.Montserrat,
    'FontFamily.Nunito': FontFamily.Nunito,
    'FontFamily.Pacifico': FontFamily.Pacifico,
    'FontFamily.PlayfairDisplay': FontFamily.PlayfairDisplay,
    'FontFamily.Roboto': FontFamily.Roboto,
    'FontFamily.Satisfy': FontFamily.Satisfy,
    'FontFamily.SourceSansPro': FontFamily.SourceSansPro,
    'FontFamily.Yellowtail': FontFamily.Yellowtail,
  };

  Diary(
      {int id,
      String diary,
      int day,
      String timestamp,
      int monthYearId,
      int fontSize,
      FontFamily fontFamily}) {
    this._diary = diary;
    this._id = id;
    this._day = day;
    this._timestamp = timestamp;
    this._monthYearId = monthYearId;
    this._fontFamily = fontFamily;
    this._fontSize = fontSize;
  }

  String get diary => this._diary;

  int get id => this._id;

  int get day => this._day;

  int get monthYearId => this._monthYearId;

  String get timestamp => this._timestamp;

  int get fontSize => this._fontSize;

  FontFamily get fontFamily => this._fontFamily;

  set diary(String value) {
    this._diary = value;
  }

  set fontSize(int value) {
    this._fontSize = value;
  }

  set fontFamily(FontFamily value) {
    this._fontFamily = value;
  }

  Future<Database> _getDBInstance() async {
    return await DBConnector().instance();
  }

  Map<String, dynamic> _toJson() {
    Map<String, dynamic> map = {
      'month_year_id': this._monthYearId,
      'day': this._day,
      'diary': this._diary,
      'font_size': this._fontSize,
      'font_family': this.fontFamily.toString(),
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
      fontSize: map['font_size'],
      fontFamily: this._fontFamilyMapper[map['font_family']],
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
        'SELECT id, month_year_id, day, diary, font_size, font_family, timestamp FROM diaries WHERE $where',
        whereArg);
    List<Diary> diaries = [];
    for (Map value in data) {
      Diary diary = Diary()._fromJson(value);
      print(diary.fontFamily);
      print(diary.fontSize);
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
    Map<String, dynamic> map = this._toJson();
    int id = await database
        .update('diaries', map, where: 'id = ?', whereArgs: [this._id]);
    await database.close();
    return id;
  }
}
