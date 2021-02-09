import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBConnector {
  final String _dbName = 'diary.db';

  Future<Database> instance() async {
    return await this._init();
  }

  Future<String> _getPath() async {
    return join(await getDatabasesPath(), _dbName);
  }

  Future<Database> _init() async {
    String path = await this._getPath();
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: ((db, version) async {
        db.execute(
            'CREATE TABLE IF NOT EXISTS years (id INTEGER PRIMARY KEY  AUTOINCREMENT, year INTEGER NOT NULL UNIQUE)');
        db.execute(
            'CREATE TABLE IF NOT EXISTS months (id INTEGER PRIMARY KEY AUTOINCREMENT, month String NOT NULL UNIQUE)');
        db.execute(
            'CREATE TABLE IF NOT EXISTS month_years (id INTEGER NOT NULL UNIQUE, month_id INTEGER NOT NULL, year_id INTEGER NOT NULL, PRIMARY KEY (year_id, month_id), FOREIGN KEY (year_id) REFERENCES years (id) ON DELETE CASCADE, FOREIGN KEY (month_id) REFERENCES months (id) ON DELETE CASCADE)');
        db.execute(
            'CREATE TABLE IF NOT EXISTS diaries (id INTEGER PRIMARY KEY AUTOINCREMENT, month_year_id INTEGER NOT NULL, day INTEGER NOT NULL, diary TEXT NOT NULL, timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, FOREIGN KEY (month_year_id) REFERENCES month_years (id) ON DELETE CASCADE)');

        //insert sample datas to each tables
        List<int> monthIds = [];
        List<int> yearIds = [];
        List<int> monthYearIds = [];
        List<String> monthsList = [
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

        for (String month in monthsList) {
          int id = await db.insert('months', {'month': month});
          monthIds.add(id);
        }
        print('months inserted successfully!');

        for (int i = 0; i < 40; i++) {
          int id = await db.insert('years', {'year': 2000 + i});
          yearIds.add(id);
        }

        print('years inserted successfully!');

        for (int yearId in yearIds) {
          for (int monthId in monthIds) {
            int oldId = await db
                .query('month_years', columns: ['id'], orderBy: 'id DESC')
                .then((value) {
              if (value.isEmpty) {
                return 0;
              } else {
                return value.first['id'];
              }
            });
            int id = await db.insert(
              'month_years',
              {'month_id': monthId, 'year_id': yearId, 'id': oldId + 1},
            );
            monthYearIds.add(id);
          }
        }

        print('monthYears inserted successfully!');

        for (int monthYearId in monthYearIds) {
          for (int i = 0; i < 30; i++) {
            db.insert(
              'diaries',
              {
                'month_year_id': monthYearId,
                'day': i + 1,
                'diary':
                    'diary day ${i + 1} Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ab adipisci architecto asperiores at atque autem, blanditiis consectetur deserunt dignissimos dolorem enim error excepturi explicabo id illum incidunt inventore pariatur placeat porro quibusdam quis quo reprehenderit saepe similique tempora tempore veritatis voluptatem. Blanditiis commodi dolorem facilis ipsa laudantium nostrum quidem temporibus',
              },
            );
          }
        }

        print('diaries inserted successfully!');
      }),
    );
    return database;
  }
}
