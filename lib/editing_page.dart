import 'package:diary/model/diary.dart';
import 'package:diary/model/month.dart';
import 'package:diary/model/month_year.dart';
import 'package:diary/model/year.dart';
import 'package:diary/utility/font_family.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditingPage extends StatelessWidget {
  Diary _diary;
  String _randomString;

  EditingPage({Diary diary, String randomString = 'not active'}) {
    this._diary = diary;
    this._randomString = randomString;
  }

  @override
  Widget build(BuildContext context) {
    return _MyApp(this._diary, this._randomString);
  }
}

class _MyApp extends StatefulWidget {
  Diary _diary;
  String _randomString;
  _MyApp(this._diary, this._randomString);
  @override
  State<StatefulWidget> createState() {
    return _MyAppState(this._diary, this._randomString);
  }
}

class _MyAppState extends State<_MyApp> {
  FontFamily _fontFamily = FontFamily.Cookie;
  bool _showFontFamilies = false;
  bool _showSlider = false;
  double _fontSize = 12.0;
  FontWeight _fontWeight;
  Diary _diary;
  String _randomString;
  TextEditingController _textEditingController;

  _MyAppState(this._diary, this._randomString) {
    if (this._diary != null) {
      this._textEditingController =
          TextEditingController(text: this._diary.diary);
      this._fontSize = this._diary.fontSize.toDouble();
      this._fontFamily = this._diary.fontFamily;
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
          IconButton(
            padding: EdgeInsets.zero,
            icon: Text(
              'save',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
                color: Colors.white,
                fontFamily: 'Lato',
              ),
            ),
            onPressed: () => _onSave(context),
          ),
          PopupMenuButton(
            offset: Offset(0.0, 0.0),
            onSelected: (value) => (value == 1)
                ? this._showFontFamilyList(true)
                : this._showFontSize(true),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                  'change font family',
                ),
                value: 1,
              ),
              PopupMenuItem(
                child: Text(
                  'change font size',
                ),
                value: 2,
              ),
            ],
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            SizedBox.expand(
              child: Hero(
                tag: this._randomString,
                child: TextField(
                  controller: _textEditingController,
                  maxLines: 99999,
                  style: TextStyle(
                    fontFamily: this._fontFamily.toString().split('.').last,
                    fontSize: this._fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: 'what happen today?',
                    hintStyle: TextStyle(
                      fontFamily: this._fontFamily.toString().split('.').last,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  autofocus: false,
                ),
              ),
            ),
            this._showFamilyListWidget(),
            this._showSliderWidget(),
          ],
        ),
      ),
    );
  }

  ///show list of available font families
  Widget _showFamilyListWidget() {
    if (this._showFontFamilies) {
      FocusScope.of(context).unfocus();
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black54.withOpacity(0.1),
        child: Center(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height / 2,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.blue),
                    child: Column(
                      children: [
                        this._getRadioButton(FontFamily.Caveat,
                            size: 30.0, weight: FontWeight.w700),
                        this._getRadioButton(FontFamily.Cookie,
                            size: 30.0, weight: FontWeight.w700),
                        this._getRadioButton(FontFamily.Courgette,
                            weight: FontWeight.w700),
                        this._getRadioButton(FontFamily.DancingScript,
                            weight: FontWeight.w900),
                        this._getRadioButton(FontFamily.IndieFlower,
                            size: 28.0, weight: FontWeight.w700),
                        this._getRadioButton(FontFamily.Lato,
                            size: 24.0, weight: FontWeight.w700),
                        this._getRadioButton(FontFamily.LoversQuarrel,
                            size: 32.0, weight: FontWeight.w900),
                        this._getRadioButton(FontFamily.Montserrat,
                            size: 24.0, weight: FontWeight.w900),
                        this._getRadioButton(FontFamily.Nunito,
                            size: 24.0, weight: FontWeight.w900),
                        this._getRadioButton(FontFamily.Pacifico),
                        this._getRadioButton(FontFamily.PlayfairDisplay,
                            size: 22.0, weight: FontWeight.w900),
                        this._getRadioButton(FontFamily.Roboto,
                            weight: FontWeight.w700),
                        this._getRadioButton(FontFamily.Satisfy,
                            weight: FontWeight.w700),
                        this._getRadioButton(FontFamily.SourceSansPro,
                            weight: FontWeight.w700),
                        this._getRadioButton(FontFamily.Yellowtail,
                            weight: FontWeight.w700),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: IconButton(
                    iconSize: 30.0,
                    color: Colors.red,
                    icon: Icon(Icons.close),
                    onPressed: () => this._showFontFamilyList(false),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  ///show font size changer
  Widget _showSliderWidget() {
    if (this._showSlider) {
      FocusScope.of(context).unfocus();
      return Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white70.withOpacity(0.9),
                ),
                width: (MediaQuery.of(context).size.width * 98) / 100,
                height: (MediaQuery.of(context).size.height * 20) / 100,
                child: Slider(
                  activeColor: Colors.lightBlue,
                  value: this._fontSize,
                  onChanged: (value) => this._changeSize(value),
                  divisions: 20,
                  label: this._fontSize.round().toString(),
                  min: 10,
                  max: 40,
                ),
              ),
              Positioned(
                top: 0.0,
                right: 0.0,
                child: IconButton(
                  color: Colors.red,
                  icon: Icon(
                    Icons.close,
                    size: 20.0,
                  ),
                  onPressed: () => this._showFontSize(false),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: 0.0,
        width: 0.0,
      );
    }
  }

  void _changeSize(double value) {
    value.round().isEven ? null : value = value + 1;
    setState(() {
      this._fontSize = value;
    });
  }

  ///
  RadioListTile _getRadioButton(FontFamily family,
      {double size = 23.0, FontWeight weight = FontWeight.w500}) {
    String fontFamily = family.toString().split('.').last;
    return RadioListTile(
      value: family,
      groupValue: this._fontFamily,
      activeColor: Colors.deepPurpleAccent,
      title: Text(
        '$fontFamily',
        style: TextStyle(
          color: Colors.deepPurple,
          fontFamily: '$fontFamily',
          fontSize: size,
          fontWeight: weight,
        ),
      ),
      onChanged: (fontFamily) {
        setState(() {
          this._fontFamily = fontFamily;
        });
      },
    );
  }

  void _showFontFamilyList(bool value) {
    setState(() {
      this._showSlider = false;
      this._showFontFamilies = value;
    });
  }

  void _showFontSize(bool value) {
    setState(() {
      this._showFontFamilies = false;
      this._showSlider = value;
    });
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
        this._fontSize = 20.0;
        this._fontFamily = FontFamily.Caveat;
      });
    } else {
      setState(() {
        this._textEditingController = TextEditingController(text: diary.diary);
        this._diary = diary;
        this._fontSize = this._diary.fontSize.toDouble();
        this._fontFamily = this._diary.fontFamily;
      });
      FocusScope.of(context).unfocus();

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
        this._diary.fontFamily = this._fontFamily;
        this._diary.fontSize = this._fontSize.toInt();
        await this._updateDiary(context);
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
      diary = Diary(
          monthYearId: monthYearId,
          day: DateTime.now().day,
          diary: text,
          fontFamily: this._fontFamily,
          fontSize: this._fontSize.toInt());
      monthYearId = await diary.create();
      Navigator.pop(context);
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Diary created successfully',
        timeInSecForIosWeb: 1,
      );
    } else {
      this._diary.diary = text;
      this._diary.fontFamily = this._fontFamily;
      this._diary.fontSize = this._fontSize.toInt();
      await this._updateDiary(context);
    }
  }

  Future<void> _updateDiary(BuildContext context) async {
    FocusScope.of(context).unfocus();
    this._showFontFamilyList(false);
    this._showFontSize(false);
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
