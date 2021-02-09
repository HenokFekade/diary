import 'package:diary/database/db_connector.dart';
import 'package:sqflite/sqflite.dart';

class MonthYear {
  int _id;
  int _monthId;
  int _yearId;
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
}
