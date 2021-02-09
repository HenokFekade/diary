import 'package:diary/model/year.dart';
import 'package:diary/utility/utility.dart';
import 'package:flutter/material.dart';

import 'model/month.dart';
import 'model/month_year.dart';

void main() => runApp(Diary());

class Diary extends StatelessWidget {
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
      widgets.add(ExpansionTile(
        title: Text(
          '${month.month}',
        ),
      ));
    }
    return widgets;
  }

  Future<void> _fetchData() async {
    var iterable = await this.organizer();
    setState(() {
      this.years.clear();
      this.years.addAll(iterable);
    });
  }

  Future<Map<int, Year>> getYearMap() async {
    Map<int, Year> yearMap = {};
    List<Year> years = await Year().getAll();
    years.forEach((year) {
      yearMap[year.id] = year;
    });
    return yearMap;
  }

  Future<Map<int, Month>> getMonthMap() async {
    Map<int, Month> monthMap = {};
    List<Month> months = await Month().getAll();
    months.forEach((month) {
      monthMap[month.id] = month;
    });
    return monthMap;
  }

  Future<Map<int, MonthYear>> getMonthYearMap() async {
    Map<int, MonthYear> monthYearMap = {};
    List<MonthYear> monthYears = await MonthYear().getAll();
    monthYears.forEach((monthYear) {
      monthYearMap[monthYear.id] = monthYear;
    });
    return monthYearMap;
  }

  //add months in to each year, diaries to the month they belong
  Future<List<Year>> organizer() async {
    Map<int, Year> yearMap = await this.getYearMap();
    Map<int, Month> monthMap = await this.getMonthMap();
    Map<int, MonthYear> monthYearMap = await this.getMonthYearMap();
    monthYearMap.forEach((monthYearId, monthYear) {
      Month month = monthMap[monthYear.monthId];
      Year year = yearMap[monthYear.yearId];
      if (!year.months.contains(month)) {
        yearMap[monthYear.yearId].months.add(month);
      }
    });
    return yearMap.values.toList();
  }
}
