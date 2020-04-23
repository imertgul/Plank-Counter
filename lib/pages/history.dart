import 'package:flutter/material.dart';
import '../utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  void exit() {
    Navigator.pop(context);
  }


  Future<Map> _fillHistory() async {
    for (int i = 0; i < 50; i++) {
      if (await read(
              dateToString(DateTime.now().subtract(new Duration(days: i)))) !=
          0) {
        history[dateToString(DateTime.now().subtract(new Duration(days: i)))] = await read(
            dateToString(DateTime.now().subtract(new Duration(days: i))));
      }
    }
    return history;
  }

  Widget _buildTitleBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: () => exit(),
            icon: Icon(Icons.arrow_back_ios),
            color: Renkler.textOnP,
          ),
          Text(
            'Geçmiş Kayıtlar',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Renkler.textOnP,
            ),
          ),
          IconButton(
            onPressed: () => launch('https://github.com/imertgul/Plank-Counter.git'), //saveSample(),
            icon: Icon(Icons.info),
            color: Renkler.textOnP,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(String date, String weekday, int record) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        //height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Renkler.sDark,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              color: Renkler.secondary,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  // // // // // padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        date + '  ' + weekday,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        record.toString() + ' sn',
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Renkler.textOnP,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFutureList(){
    return Container(
                    height: MediaQuery.of(context).size.height - kToolbarHeight -30,
                    child: FutureBuilder(
                      future: _fillHistory(),
                      builder: (context, projectSnap) {
                        if (projectSnap.connectionState == ConnectionState.none &&
                            projectSnap.hasData == null) {
                          //print('project snapshot data is: ${projectSnap.data}');
                          return Container();//Todo data null
                        }
                        return ListView.builder(
                          itemCount: projectSnap.data.length +1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Container();
                            }
                            return _buildHistoryCard(
                                history.keys.toList()[index - 1] ,
                                getWeekday(new DateFormat('yyyy-MM-dd').parse(history.keys.toList()[index - 1])),                               
                                history.values.toList()[index - 1]
                                );
                          },
                        );
                      },
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
              color: Renkler.pLight,
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
                  _buildFutureList(),                 
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
