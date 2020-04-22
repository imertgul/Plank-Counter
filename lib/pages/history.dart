import 'package:flutter/material.dart';
import '../utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  void exit() {
    Navigator.pop(context);
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
            onPressed: () => launch('https://github.com/imertgul/Plank-Takip'),
            icon: Icon(Icons.info),
            color: Renkler.textOnP,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(String date, String weekday, String record) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Renkler.primary,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Renkler.pLight,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      date + '  ' + weekday,
                      style: TextStyle(fontSize: 20.0, color: Colors.white70),
                    ),
                    Text(
                      record + ' sn',
                      style: TextStyle(fontSize: 25.0, color: Renkler.textOnP),
                    ),
                  ],
                ),
              )
            ],
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
                  SizedBox(height: 20.0),
                  _buildHistoryCard('21.04.20', 'Salı', '55'),
                  SizedBox(height: 5.0),
                  _buildHistoryCard('20.04.20', 'Pazartesi', '45'),
                  SizedBox(height: 5.0),
                  _buildHistoryCard('19.04.20', 'Pazar', '42'),
                  SizedBox(height: 5.0),
                  _buildHistoryCard('18.04.20', 'Cumartesi', '40'),
                  SizedBox(height: 5.0),
                  _buildHistoryCard('17.04.20', 'Cuma', '37'),
                  SizedBox(height: 5.0),
                  _buildHistoryCard('16.04.20', 'Perşembe', '35'),
                  SizedBox(height: 5.0),
                  _buildHistoryCard('15.04.20', 'Çarşamba', '35'),
                  SizedBox(height: 5.0),
                  _buildHistoryCard('14.04.20', 'Salı', '32'),
                  SizedBox(height: 5.0),
                  _buildHistoryCard('13.04.20', 'Pazartesi', '30'),
                  SizedBox(height: 5.0),
                  _buildHistoryCard('12.04.20', 'Pazar', '27'),
                  SizedBox(height: 5.0),
                  _buildHistoryCard('11.04.20', 'Cumartesi', '24'),
                  SizedBox(height: 5.0),
                  _buildHistoryCard('10.04.20', 'Cuma', '21'),
                  SizedBox(height: 5.0),
                  _buildHistoryCard('9.04.20', 'Perşembe', '18'),
                  SizedBox(height: 5.0),
                  _buildHistoryCard('8.04.20', 'Çarşamba', '15'),
                  SizedBox(height: 5.0),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
