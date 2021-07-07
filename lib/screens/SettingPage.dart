import 'dart:async';
import 'package:covid19_tracker/model/constants.dart';
import 'package:covid19_tracker/model/config.dart';
import 'package:covid19_tracker/screens/slot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:covid19_tracker/main.dart';
import 'Countries.dart';
import 'Indian.dart';
import 'package:covid19_tracker/services/networking.dart';
import 'dashboard.dart';
import 'graphsline.dart';
import 'newsPage.dart';
import 'package:covid19_tracker/model/config.dart';
import 'package:covid19_tracker/model/constants.dart';
import 'package:covid19_tracker/model/covid19_dashboard.dart';
import 'package:covid19_tracker/screens/Countries.dart';
import 'package:covid19_tracker/screens/Indian.dart';
import 'package:covid19_tracker/screens/SettingPage.dart';
import 'package:covid19_tracker/screens/graphsline.dart';
import 'package:covid19_tracker/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_nav_bar/google_nav_bar.dart';
import 'slot.dart';

class SettingPage extends StatefulWidget {
  _SettingPage createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
  bool isSwitched = true;

  Future<bool> Savesettings(bool swit) async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSwitched', isSwitched);

    return prefs.commit();
  }
  //
  Future<bool> Getsettiegs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isSwitched = prefs.getBool('isSwitched');
    return isSwitched;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  FutureOr update(bool value) {
    if (value == null) {
      isSwitched = true;
    } else {
      isSwitched = value;
    }
    setState(() {

    });
  }



  @override
  Widget build(BuildContext context) {
    IconData blub2 = Icons.lightbulb;
    IconData blub = Icons.highlight;

    if(currentTheme.currentTheme().toString() == "ThemeMode.dark"  )
    {
      constant.navbar = Color(0xff202c3b);
      constant.downbar = Colors.cyan;

      constant.confirmed = Colors.white;
    }
    else
    {

      constant.navbar = Colors.white;
      constant.downbar = Color(0xff202c3b);
      constant.confirmed = Colors.black;

    }
    setState(() {

    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Concure'),
        centerTitle:  true,
      ),
      body: SingleChildScrollView(
          child: Container(
        child: Column(

          children: [
            Card(
              elevation: 3,
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Set Dark Mode",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: GestureDetector(
                      child: Icon(
                        isSwitched ? blub : blub2,
                        size: 35,
                      ),
                      onTap: () {
                        print("switch : "+isSwitched.toString());
                        if (isSwitched == false) {

                          isSwitched = true;
                          constant.navbar = Colors.white;
                          constant.downbar = Color(0xff202c3b);


                          setState(() {});
                        } else {
                          isSwitched = false;

                          constant.navbar = Color(0xff202c3b);
                          constant.downbar = Colors.cyan;


                          // constant().setcolor(Colors.white, Colors.cyan);
                          setState(() {});
                        }
                        currentTheme.switchTheme();
                        Savesettings(isSwitched);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            clickbutton(
              'Graphical Data',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GraphsLine()),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            clickbutton('Covid News', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            }),
            SizedBox(
              height: 10,
            ),
            clickbutton('Vaccinator', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VaccinebyPin()),
              );
            }),
            SizedBox(
              height: 10,
            ),
            clickbutton('Donate', () {
              launch('https://covid19responsefund.org/en/');
            }),
            SizedBox(
              height: 10,
            ),
            clickbutton(
              'Myth Busters',
              () {
                launch(
                    'https://www.who.int/emergencies/diseases/novel-coronavirus-2019/advice-for-public/myth-busters');
              },
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: constant.navbar,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              // rippleColor: Colors.black87,
              // hoverColor: Colors.yellow,
              gap: 8,
              // activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              // tabBackgroundColor: Colors.yellow,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: Icons.apps,
                  iconSize: 30,
                  text: 'Home',
                  backgroundColor: Colors.red[100],
                  textColor: Colors.red,
                  iconActiveColor: Colors.red,
                  iconColor: Colors.red,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(),
                      ),
                    );
                  },
                ),
                GButton(
                    icon: Icons.find_in_page,
                    iconColor: Colors.purpleAccent,
                    text: 'Countries',
                    backgroundColor: Colors.purple[100],
                    textColor: Colors.purple,
                    iconActiveColor: Colors.purpleAccent[200],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Cont()),
                      );
                    }),
                GButton(
                  icon: Icons.countertops,
                  text: 'States',
                  iconColor: Colors.pink,
                  backgroundColor: Colors.pink[100],
                  textColor: Colors.pink,
                  iconActiveColor: Colors.redAccent,
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Indian()));
//
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => MytestApp()),
                    // );
                  },
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                  iconColor: Colors.blue,
                  backgroundColor: Colors.blue[100],
                  textColor: Colors.blue[500],
                  iconActiveColor: Colors.blue[600],
                  onPressed: () {
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => MytestApp()),
                    // );
                  },
                ),
              ],
              selectedIndex: 3,
              // onTabChange: (index) {
              //   setState(() {
              //     _selectedIndex = index;
              //   });
              // },
            ),
          ),
        ),
      ),
    );
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  Widget clickbutton(String title, fuction()) {
    return GestureDetector(
      onTap: fuction,
      child: Container(
        decoration: BoxDecoration(
            color: constant.downbar, borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('  ' + title,
                style: TextStyle(
                  // letterSpacing: 0
                  fontSize: 23,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                )),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 27,
            ),
          ],
        ),
      ),
    );
  }
}
