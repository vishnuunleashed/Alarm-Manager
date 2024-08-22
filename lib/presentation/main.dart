import 'dart:developer';

import 'package:alarmappforufs/data/repositoryimpl/local/database_helper.dart';
import 'package:alarmappforufs/presentation/provider/alarm_main_provider/alarm_main_provider.dart';
import 'package:alarmappforufs/presentation/screens/alarm_main/alarm_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Initialize database
    await DatabaseHelper.initialize();
    AndroidNotificationChannel channel = const AndroidNotificationChannel('Alarm App', 'Alarm App Channel',
        importance: Importance.max,
        );
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    log('Database opened successfully');
  } catch (e, stackTrace) {
    log('Error opening database: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>AlarmMainScreenProvder())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue,brightness: Brightness.light),
          useMaterial3: true,
          /* light theme settings */
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue,brightness: Brightness.dark),
          useMaterial3: true,
          /* dark theme settings */
        ),
        home: const AlarmMainScreen(),
      ),
    );
  }
}

