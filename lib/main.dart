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
          itemBuilder: (context, index) => this._yearWidget(years[index]),
        ),
      ),
    );
  }

  Widget _yearWidget(Year year) {
    return ExpansionTile(
      title: Text(
        '${year.year}',
      ),
      children: this._monthWidgets(year),
    );
  }

  List<Widget> _monthWidgets(Year year) {
    List<Widget> widgets = [];
    for (Month month in year.months) {
      widgets.add(
        Container(
          child: ExpansionTile(
            title: Text(
              '${month.month}',
            ),
            children: this._diaryWidgets(month),
          ),
        ),
      );
    }
    return widgets;
  }

  List<Widget> _diaryWidgets(Month month) {
    List<Widget> widgets = [];
    for (Diary diary in month.diaries) {
      widgets.add(
        Container(
          child: Text(
            '${diary.diary}',
          ),
        ),
      );
    }
    return widgets.toList();
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
