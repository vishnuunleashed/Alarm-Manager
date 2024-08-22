import 'dart:developer';

import 'package:alarmappforufs/data/repositoryimpl/local/database_helper.dart';
import 'package:alarmappforufs/presentation/screens/alarm_main/models/alarm_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';

class AlarmMainScreenProvder extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  TextEditingController labelController = TextEditingController(text: "");

  List<AlarmModel> alarmList = [];

  Future<void> init() async {
    Database db = await _databaseHelper.getDatabase();
    List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM alarmtable");

    if(maps.isNotEmpty){
      maps.forEach((element) {
        if(DateTime.parse(element["alarmtime"]).isAfter(DateTime.now())){
          alarmList.add(AlarmModel.fromJson(element));
        }
      });
      if(maps.length > alarmList.length){
        insertToDb();
      }
    }
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();


    notifyListeners();
  }

  void setAlarm(String alarmTime, String label) {
    alarmList.add(AlarmModel(alarmtime: alarmTime, label: label));
    insertToDb();
    notifyListeners();
  }

  void removeAlarm(int index) {
    alarmList.removeAt(index);
    insertToDb();
    notifyListeners();
  }

  Future<void> insertToDb() async {
    Database db = await _databaseHelper.getDatabase();
    await db.transaction((txn) async {
      if (alarmList.isNotEmpty) {
        for (var row in alarmList) {
          txn.insert("alarmtable", row.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    });
  }

  void showAlarm(int id ,String label){
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('Alarm App', 'Alarm App Channel',
        channelDescription: 'Curious for alarms',
        importance: Importance.max,
        icon: 'ic_launcher',
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    FlutterLocalNotificationsPlugin().show(id, "Alarm", label, notificationDetails);

  }
}
