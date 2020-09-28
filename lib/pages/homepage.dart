import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../utilities/constants.dart';
import 'history.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;
  double _heightAnimated = 0;
  double screenHeight = 0;
  bool started = true;
  Timer _timer;
  int _start = 0;

  Widget _buildTitleBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Plank Sayacım', style: myStyle18boldD),
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoryScreen())),
            icon: Icon(Icons.assessment),
            color: Renkler.dark,
          ),
        ],
      ),
    );
  }

  Future<Map> _fillCategory() async {
    for (var i = 7; i >= 0; i--) {
      categories[getWeekday(DateTime.now().subtract(new Duration(days: i)))] =
          await read(
              dateToString(DateTime.now().subtract(new Duration(days: i))));
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

  Widget _buildCategoryCard(int index, String title, int count) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
        // height: 108.0,
        width: 100.0,
        decoration: BoxDecoration(
          color: Renkler.pink,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            _selectedCategoryIndex == index
                ? BoxShadow(
                    color: Colors.white, offset: Offset(0, 0), blurRadius: 3.0)
                : BoxShadow(color: Colors.transparent)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                title,
                style: myStyle16,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                count.toString() + " sn",
                style: myStyle16,
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
          itemCount: DateTime.now().weekday + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return SizedBox(width: 20.0);
            }
            return _buildCategoryCard(
                index - 1,
                categories.keys.toList()[index - 1],
                categories.values.toList()[index - 1]);
          },
        );
      },
      future: _fillCategory(),
    );
  }

  Widget _buildLastWeek() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Renkler.pinkD,
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
                  style: myStyle16,
                ),
              ),
            ),
            Container(
              height: 115.0,
              child: _buildFuture(),
            ),
          ],
        ),
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
            backgroundColor: Renkler.green,
            fontSize: 16.0),
        onLongPress: () {
          setState(() {
            started = !started;
            startTimer();
          });
        },
        color: Renkler.pinkD,
        splashColor: Renkler.beyaz,
        child: Text(
          'Başla',
          style: myStyle18bold,
        ),
        padding: EdgeInsets.all(screenHeight / 10),
        shape: CircleBorder(),
      ),
    );
  }

  Widget _buildPlankInfo() {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        color: started ? Renkler.pink : Renkler.greenL,
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: double.infinity,
      height: _heightAnimated - 20,
      child: Column(
        children: <Widget>[
          Container(
            height: ((_heightAnimated - 20) / 6) * 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FittedBox(
                    child: Text(
                      'Plank',
                      style: myStyle18bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image(
                    height: (((_heightAnimated - 20) / 6) * 2) - 10,
                    image: AssetImage('images/plank.png'),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: (_heightAnimated - 20) / 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: FittedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ayak parmaklarınız ve ön kolunuz zemin üzerinde yere uzanın.',
                    style: myStyle16,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: (_heightAnimated - 20) / 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: FittedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Yapabildiğiniz kadar vücudunuzu düz tutun ve bu pozisyonu koruyun.',
                    style: myStyle16,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: (_heightAnimated - 20) / 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: FittedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Core bölgesi kasları yani bel, kalça ve özellikle de karın kaslarınız güçlenir.',
                    style: myStyle16,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: (_heightAnimated - 20) / 6,
            child: Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: () {
                  launch('https://en.wikipedia.org/wiki/Plank_(exercise)');
                },
                child: Text(
                  'Detaylı bilgi için...',
                  style: myStyle12,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWarning() {
    return Container(
      decoration: BoxDecoration(
        color: Renkler.greenL,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Bu egzersiz sırasında belinizde ağrı hissetmemelisiniz.\n Çok ağrı yaşıyorsanız egzersizi bitirin.',
          style: myStyle16,
          textAlign: TextAlign.center,
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
          color: Renkler.greenL,
          child: Text(
            'İptal Etmek için uzun basınız',
            style: myStyle18,
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
                backgroundColor: Renkler.green,
                textColor: Renkler.beyaz,
                fontSize: 18.0);
            setState(() {
              save(_start);
              _start = 0;
              _timer.cancel();
              started = !started;
            });
          },
          color: Renkler.greenL,
          child: Text(
            'Kaydet ve Bitir',
            style: myStyle18,
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
          width: double.infinity,
          height: started
              ? _heightAnimated
              : MediaQuery.of(context).size.height - kToolbarHeight + 10,
          decoration: BoxDecoration(
            color: started ? Renkler.pinkD : Renkler.green,
            borderRadius: BorderRadius.circular(10.0),
          ),
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Offstage(
                    offstage: started,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                '$_start',
                                style: myStyle40bold,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            _buildWarning(),
                            SizedBox(height: 10.0),
                            _buildSaveButton(),
                          ],
                        ),
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
    _heightAnimated = MediaQuery.of(context).size.height / 4;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Renkler.background,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                child: Column(
                  children: <Widget>[
                    // SizedBox(height: 20.0),
                    _buildTitleBar(),
                    _buildLastWeek(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: _buildStartButton(),
              ),
              _buildStartedContainer(),
            ],
          ),
        ));
  }
}
