import 'package:diary/model/diary.dart';
import 'package:diary/model/month.dart';
import 'package:diary/model/month_year.dart';
import 'package:diary/model/year.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditingPage extends StatelessWidget {
  Diary _diary;

  EditingPage({Diary diary}) {
    this._diary = diary;
  }

  @override
  Widget build(BuildContext context) {
    return _MyApp(this._diary);
  }
}

class _MyApp extends StatefulWidget {
  Diary _diary;
  _MyApp(this._diary);
  @override
  State<StatefulWidget> createState() {
    return _MyAppState(this._diary);
  }
}

class _MyAppState extends State<_MyApp> {
  Diary _diary;
  TextEditingController _textEditingController;

  _MyAppState(this._diary) {
    if (this._diary != null) {
      this._textEditingController =
          TextEditingController(text: this._diary.diary);
    } else {
      this._initializeController();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit your diary',
        ),
        actions: [
          FlatButton(
            child: Text(
              'save',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'Roboto_Condensed',
              ),
            ),
            onPressed: () => _onSave(context),
          ),
          PopupMenuButton(
            onSelected: (value) {},
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                  'change font',
                ),
                value: 1,
              ),
            ],
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SizedBox.expand(
          child: TextField(
            controller: _textEditingController,
            maxLines: 99999,
            style: TextStyle(
              fontFamily: 'Caveat',
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8.0),
              hintText: 'what happen today?',
              hintStyle: TextStyle(
                fontFamily: 'Caveat',
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            keyboardType: TextInputType.multiline,
            autofocus: false,
          ),
        ),
      ),
    );
  }

/*
 *check if their is a diary in this day and then
 *if their is initialize the _textEditingController initial value with the diary
 *else initialize the _textEditingController initial value of null
 */
  Future<void> _initializeController() async {
    Diary diary = await this._checkDiaryExist();
    if (diary == null) {
      setState(() {
        this._textEditingController = TextEditingController();
      });
    } else {
      setState(() {
        this._textEditingController = TextEditingController(text: diary.diary);
        this._diary = diary;
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            'Do you want to update today\'s diary?',
            textAlign: TextAlign.center,
          ),
          content: Text(
            'You already have a diary on this day. please select "yes" if you want to update it.',
            textAlign: TextAlign.center,
          ),
          actions: [
            FlatButton(
              onPressed: () async {
                await this._diary.update();
                Navigator.pop(context);
              },
              child: Text(
                'yes',
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'no',
              ),
            ),
          ],
        ),
      );
    }
  }

  /// check todays diary exist return diary of today or null
  Future<Diary> _checkDiaryExist() async {
    int monthYearId = await this._getMonthYearId();
    Diary diary = await Diary().get('month_year_id = ? AND day = ?',
        [monthYearId, DateTime.now().day]).then((value) {
      if (value.isNotEmpty) return value.first;
      return null;
    });
    return diary;
  }

  Future<void> _onSave(BuildContext context) async {
    if (this._diary == null) {
      //for new diary to save
      if (this._textEditingController.text.trim().isNotEmpty) {
        String text = this._textEditingController.text;
        int monthYearId = await this._getMonthYearId();
        await this._createDiary(monthYearId, text, context);
      } else {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: 'No Diary written!',
          timeInSecForIosWeb: 1,
        );
      }
    } else {
      if (this._textEditingController.text.trim().isNotEmpty) {
        String text = this._textEditingController.text;
        this._diary.diary = text;
        await this._updateDiary(context);
        print('update method finished');
      } else {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: 'Diary is empty Nothing to Update!',
          timeInSecForIosWeb: 1,
        );
      }
    }
  }

  Future<void> _createDiary(
      int monthYearId, String text, BuildContext context) async {
    Diary diary = await Diary().get('month_year_id = ? AND day = ?',
        [monthYearId, DateTime.now().day]).then((value) {
      if (value.isNotEmpty) return value.first;
      return null;
    });
    if (diary == null) {
      diary =
          Diary(monthYearId: monthYearId, day: DateTime.now().day, diary: text);
      monthYearId = await diary.create();
      Navigator.pop(context);
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Diary created successfully',
        timeInSecForIosWeb: 1,
      );
    } else {
      this._diary.diary = text;
      await this._updateDiary(context);
    }
  }

  Future<void> _updateDiary(BuildContext context) async {
    print('update method start');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Do you want to update today\'s diary?',
          textAlign: TextAlign.center,
        ),
        content: Text(
          'You already have a diary on this day. please select "yes" if you want to update it.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FlatButton(
            onPressed: () async {
              await this._diary.update();
              Fluttertoast.cancel();
              Fluttertoast.showToast(
                msg: 'Diary updated successfully',
                timeInSecForIosWeb: 1,
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'yes',
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'no',
            ),
          ),
        ],
      ),
    );
    print('update method finished inside the method print');
  }

  Future<int> _getMonthId(String monthName) async {
    Month month = await Month().get('month = ?', [monthName]).then((value) {
      if (value.isNotEmpty) return value.first;
      return null;
    });
    int monthId;
    if (month == null) {
      monthId = await Month(month: monthName).create();
    } else {
      monthId = month.id;
    }
    return monthId;
  }

  Future<int> _getYearId(int theYear) async {
    Year year = await Year().get('year = ?', [theYear]).then((value) {
      if (value.isNotEmpty) return value.first;
      return null;
    });
    int yearId;
    if (year == null) {
      year = Year(year: theYear);
      yearId = await year.create();
    } else {
      yearId = year.id;
    }
    return yearId;
  }

  Future<int> _getMonthYearId() async {
    DateTime dateTime = DateTime.now();
    String monthName = Month.monthsList[dateTime.month - 1];
    int monthId = await _getMonthId(monthName);
    int yearId = await _getYearId(dateTime.year);
    MonthYear monthYear = await MonthYear()
        .get('month_id = ? AND year_id = ?', [monthId, yearId]).then((value) {
      if (value.isNotEmpty) return value.first;
      return null;
    });
    int monthYearId;
    if (monthYear == null) {
      monthYear = MonthYear(monthId: monthId, yearId: yearId);
      monthYearId = await monthYear.create();
    } else {
      monthYearId = monthYear.id;
    }
    return monthYearId;
  }

  @override
  void dispose() {
    this._textEditingController.dispose();
    super.dispose();
  }
}
