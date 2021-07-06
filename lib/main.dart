import 'dart:async';
import 'package:covid19_tracker/services/networking.dart';
import 'package:http/http.dart' as http;
import 'package:covid19_tracker/model/config.dart';
import 'package:covid19_tracker/screens/dashboard.dart';
import 'package:covid19_tracker/screens/slot_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import "package:hive_flutter/hive_flutter.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) async {
    Networking n = new Networking();
    // NotificationService nr= new NotificationService();
    n.get_notified();
    checkAvailability2();
    return Future.value(true);
  });
}

void main() async {
  await Hive.initFlutter();
  await GetStorage.init();
  box = await Hive.openBox('easyTheme');
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager.initialize(callbackDispatcher);
  await Workmanager.registerPeriodicTask("vaccine_notify", "vaccine_notify",
      inputData: {"data1": "value1", "data2": "value2"},
      frequency: Duration(minutes: 15),
      initialDelay: Duration(minutes: 1));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyApp createState() => _MyApp();
}

Future<bool> checkAvailability2() async {
  GetStorage box = GetStorage();
  bool isAvailable = false;
  print("check2");
  var currentDistrictId = box.read('district_Id');
  if (currentDistrictId != null) {
    String dateString = DateFormat("dd-MM-yyyy").format(DateTime.now());
    final _url =
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$currentDistrictId&date=$dateString';
    // print(_url);
    var response = await http.get(_url);
    // print("res ${response.body}");
    if (response.statusCode == 200) {
      var r = covidvaccinebypinFromJson(response.body);
      List<Centers> s = r.centers;
      List<Session> ct;
      bool av = false;
      // NotificationService nr= new NotificationService();
      for (int i = 0; i < s.length; ++i) {
        print("vinayak");
        ct = s[i].sessions;
        for (int j = 0; j < ct.length; ++j) {
          print("${ct[j].minAgeLimit}");
          // nr.ifAvailable(s[i],ct[j]);
        }
      }
    }
  }
  return isAvailable;
}

class _MyApp extends State<MyApp> {
  // Timer _timerForInter;
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      print("Changed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Concure',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: currentTheme.currentTheme(),
      home: DashboardScreen(),
    );
  }
}
