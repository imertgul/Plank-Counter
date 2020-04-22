import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../utilities/constants.dart';
import 'history.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;
  double _widthAnimated = double.infinity;
  double _heightAnimated = 280;
  bool started = true;
  Timer _timer;
  int _start = 0;

  Future<int> _read(String day) async {
    final prefs = await SharedPreferences.getInstance();
    final key = day;
    final value = prefs.getInt(key) ?? 0;
    print('read: $value  --- $day');
    return value;
  }

  _save(int record) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _todayToString();
    final value = record;
    prefs.setInt(key, value);
    print('saved $value');
  }

  String _todayToString() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    return formatted;
  }

  String _dateToString(DateTime date) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(date);
    return formatted;
  }

  String _getWeekday(DateTime date) {
    String formatted = gunler[date.weekday -1];
    return formatted;
  }

  Future<Map> _fillCategory() async {
    for (var i = 7; i >= 0; i--) {
      categories[_getWeekday(DateTime.now().subtract(new Duration(days: i)))] =
          await _read(
              _dateToString(DateTime.now().subtract(new Duration(days: i))));
    }
    return categories;
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () => _start++,
      ),
    );
  }

  Widget _buildTitleBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Plank Sayacım',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: Renkler.textOnP,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoryScreen())),
            icon: Icon(Icons.assessment),
            color: Renkler.textOnP,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(int index, String title, int count) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
        height: 108.0,
        width: 96.0,
        decoration: BoxDecoration(
          color: Renkler.secondary,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            _selectedCategoryIndex == index
                ? BoxShadow(
                    color: Colors.white, offset: Offset(0, 0), blurRadius: 3.0)
                : BoxShadow(color: Colors.transparent)
          ],
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Renkler.textOnS, //Color(0XFFAFB4C6)
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                count.toString() + " sn",
                style: TextStyle(
                  color: Renkler.textOnS,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFuture() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return SizedBox(width: 20.0);
            }
            return _buildCategoryCard(
                index - 1,
                categories.keys.toList()[index -1],
                categories.values.toList()[index -1]);
          },
        );
      },
      future: _fillCategory(),
    );
  }

  Widget _buildLastWeek() {
    return Container(
      // height: 162.0,
      decoration: BoxDecoration(
        color: Renkler.primary,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15.0, top: 15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Bu Hafta',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Renkler.textOnP,
                ),
              ),
            ),
          ),
          Container(
            height: 114.0,
            child: _buildFuture(),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      alignment: Alignment.center,
      child: MaterialButton(
        onPressed: () => Fluttertoast.showToast(
            msg: "Başlamak için uzun basınız...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Renkler.secondary,
            textColor: Renkler.textOnS,
            fontSize: 16.0),
        onLongPress: () {
          setState(() {
            started = !started;
            startTimer();
          });
        },
        color: Renkler.pLight,
        splashColor: Renkler.sDark,
        child: Text(
          'Başla',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
            color: Renkler.textOnP,
          ),
        ),
        padding: EdgeInsets.all(100),
        shape: CircleBorder(),
      ),
    );
  }

  Widget _buildPlankInfo() {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        color: started ? Renkler.pLight : Renkler.sLight,
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: double.infinity,
      height: _heightAnimated - 30,
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 15.0, left: 15.0, top: 10.0, bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Plank',
                          // textAlign: TextAlign.end,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                            color: Renkler.textOnP,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Image(
                            height: 45,
                            image: AssetImage('images/plank.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Ayak parmaklarınız ve ön kolunuz zemin üzerinde yere uzanın.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Yapabildiğiniz kadar vücudunuzu düz tutun ve bu pozisyonu koruyun.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Core bölgesi kasları yani bel, kalça ve özellikle de karın kaslarınız güçlenir.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        launch('https://en.wikipedia.org/wiki/Plank_(exercise)');
                      },
                      child: Text(
                        'Detaylı bilgi için...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarning() {
    return Container(
      decoration: BoxDecoration(
        color: Renkler.sDark,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          'Bu egzersiz sırasında belinizde ağrı hissetmemelisiniz çok ağrı yaşıyorsanız egzersizi bitirin.',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white60,
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Offstage(
        offstage: started,
        child: RaisedButton(
          onPressed: () => print('pressed'),
          onLongPress: () {
            setState(() {
              _timer.cancel();
              _start = 0;
              started = !started;
            });
          },
          color: Renkler.pLight,
          child: Text(
            'İptal Etmek için uzun basınız',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Renkler.textOnP,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Offstage(
        offstage: started,
        child: RaisedButton(
          onPressed: () {
            Fluttertoast.showToast(
                msg: "$_start saniye Plank tamamlandı ve kaydedildi",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Renkler.secondary,
                textColor: Renkler.textOnS,
                fontSize: 18.0);
            setState(() {
              _save(_start);
              _start = 0;
              _timer.cancel();
              started = !started;
            });
          },
          color: Renkler.sLight,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Kaydet ve Bitir',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
                color: Renkler.textOnP,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartedContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: AnimatedContainer(
          width: _widthAnimated,
          height: started
              ? _heightAnimated
              : MediaQuery.of(context).size.height - kToolbarHeight,
          decoration: BoxDecoration(
            color: started ? Renkler.primary : Renkler.secondary,
            borderRadius: BorderRadius.circular(10.0),
          ),
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Offstage(
                    offstage: started,
                    child: Container(
                      height: 257,
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              '$_start',
                              style: TextStyle(
                                fontSize: 55.0,
                                fontWeight: FontWeight.bold,
                                color: Renkler.textOnP,
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          _buildWarning(),
                          SizedBox(height: 30.0),
                          _buildSaveButton(),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildCancelButton(),
                _buildPlankInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Renkler.pLight,
                Renkler.pDark,
              ],
              stops: [0.1, 0.9],
            ),
          ),
        ),
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                _buildTitleBar(),
                SizedBox(height: 10.0),
                _buildLastWeek(),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: _buildStartButton(),
        ),
        _buildStartedContainer(),
      ],
    ));
  }
}
