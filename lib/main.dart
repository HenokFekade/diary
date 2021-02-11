import 'package:diary/editing_page.dart';
import 'package:diary/model/year.dart';
import 'package:diary/utility/utility.dart';
import 'package:flutter/material.dart';

import 'model/month.dart';
import 'model/diary.dart';
import 'model/month_year.dart';

void main() => runApp(DiaryApp());

class DiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _MyApp(),
    );
  }
}

class _MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<_MyApp> {
  List<Year> years = [];

  @override
  void initState() {
    super.initState();
    this._fetchData();
  }

  @override
  Widget build(BuildContext context) {
    int length = years.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diary',
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: length,
          itemBuilder: (context, index) =>
              this._yearWidget(years[index], context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditingPage(),
              ));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _yearWidget(Year year, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      child: ExpansionTile(
        title: Text(
          '${year.year}',
          style: TextStyle(
            fontFamily: 'Cookie',
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: this._monthWidgets(year, context),
      ),
    );
  }

  List<Widget> _monthWidgets(Year year, BuildContext context) {
    List<Widget> widgets = [];
    for (Month month in year.months) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 5.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            margin: EdgeInsets.all(0.0),
            child: ExpansionTile(
              title: Text(
                '${month.month}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
              children: this._diaryWidgets(month, context),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  List<Widget> _diaryWidgets(Month month, BuildContext context) {
    List<Widget> widgets = [];
    for (Diary diary in month.diaries) {
      String randomString = Utility.randomString(20);
      widgets.add(
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0.0, 0.0),
                spreadRadius: 0.0,
                blurRadius: 3.0,
              )
            ]),
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.all(0.0),
              elevation: 0.0,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 4.0, bottom: 4.0, top: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Hero(
                        tag: randomString,
                        child: Container(
                          width: double.infinity,
                          height: 20.0,
                          child: Text(
                            '${diary.diary}',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditingPage(
                            diary: diary,
                            randomString: randomString,
                          ),
                        ),
                      ).then((value) => _fetchData()),
                    ),
                    Container(
                      padding: EdgeInsets.all(0.0),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: FlatButton(
                              padding: EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              textColor: Colors.deepPurple,
                              child: Text(
                                'see more...',
                              ),
                              onPressed: () => this._onSeeMore(diary, context),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Text(
                                '${Utility.dateFormatter(diary.timestamp)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                  fontSize: 15.0,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return widgets.toList();
  }

  void _onSeeMore(Diary diary, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SimpleDialog(
        title: Text(
          '${Utility.dateFormatter(diary.timestamp)}',
        ),
        children: [
          Divider(),
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                child: Text(
                  '${diary.diary}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Divider(),
          SizedBox(
            height: 5.0,
          ),
          Container(
            padding: EdgeInsets.all(0.0),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    textColor: Colors.deepPurple,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditingPage(
                            diary: diary,
                          ),
                        ),
                      ).then((value) => _fetchData());
                    },
                    child: Text(
                      'yes',
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    textColor: Colors.deepPurple,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'no',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchData() async {
    var iterable = await this.organizer();
    setState(() {
      this.years.clear();
      this.years.addAll(iterable);
    });
  }

  Future<Map<int, Year>> _getYearMap() async {
    Map<int, Year> yearMap = {};
    List<Year> years = await Year().getAll();
    years.forEach((year) {
      yearMap[year.id] = year;
    });
    return yearMap;
  }

  Future<Map<int, Month>> _getMonthMap() async {
    Map<int, Month> monthMap = {};
    List<Month> months = await Month().getAll();
    months.forEach((month) {
      monthMap[month.id] = month;
    });
    return monthMap;
  }

  Future<Map<int, MonthYear>> _getMonthYearMap() async {
    Map<int, MonthYear> monthYearMap = {};
    List<MonthYear> monthYears = await MonthYear().getAll();
    monthYears.forEach((monthYear) {
      monthYearMap[monthYear.id] = monthYear;
    });
    return monthYearMap;
  }

  Future<List<Diary>> _getDiaries() async {
    return await Diary().getAll();
  }

  //add months in to each year, diaries to the month they belong
  Future<List<Year>> organizer() async {
    Map<int, Year> yearMap = await this._getYearMap();
    Map<int, Month> monthMap = await this._getMonthMap();
    Map<int, MonthYear> monthYearMap = await this._getMonthYearMap();
    List<Diary> diaries = await this._getDiaries();
    monthYearMap.forEach((monthYearId, monthYear) {
      Month month = monthMap[monthYear.monthId];
      Year year = yearMap[monthYear.yearId];
      if (!year.months.contains(month)) {
        yearMap[monthYear.yearId].months.add(month);
      }
    });
    for (Diary diary in diaries) {
      monthYearMap[diary.monthYearId].diaries.add(diary);
    }
    for (MonthYear monthYear in monthYearMap.values) {
      Year year = yearMap[monthYear.yearId];
      Month month = monthMap[monthYear.monthId];
      month.diaries.clear();
      month.diaries.addAll(monthYear.diaries);
      if (!year.months.contains(month)) {
        yearMap[monthYear.yearId].months.add(month);
      }
    }

    return yearMap.values.toList();
  }
}
