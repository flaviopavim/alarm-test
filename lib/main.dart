import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';



import 'package:alarmtest/widget/Button.dart';
import 'package:alarmtest/widget/Input.dart';
import 'package:alarmtest/widget/Select.dart';
import 'package:flutter/material.dart';

import 'fn/sql.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  service.invoke("setAsBackground");

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }


  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);


  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: false,

      //notificationChannelId: 'my_foreground',
      //initialNotificationTitle: '',
      //initialNotificationContent: '',
      //initialNotificationTitle: 'AWESOME SERVICE',
      //initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );



  service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

var array_confirmed=[];
var msg=[];
var hash="";

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  //DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  //SharedPreferences preferences = await SharedPreferences.getInstance();
  //await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  notification(title, content) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'my_foreground',
      'MY FOREGROUND SERVICE',
      icon: 'ic_bg_service_small',
      ongoing: true,
      enableVibration: true, // Permite vibração
      //vibrationPattern: Int64List(4), // Define o padrão de vibração (opcional)
      channelShowBadge: true,
      importance: Importance.high, // Define a importância da notificação
      playSound: true, // Permite som
      //sound: RawResourceAndroidNotificationSound('nome_do_arquivo_de_som'), // Especifique o nome do arquivo de som
      priority: Priority.high, // Define a prioridade da notificação
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(
      888,
      title,
      content,
      platformChannelSpecifics,
    );
  }


  refresh() async {
    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');


    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  }

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    refresh();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String frequency_value = "";
  String duration_value = "";

  TextEditingController controller_frequency_period = TextEditingController();
  TextEditingController controller_duration_period = TextEditingController();

  var options=[
    {
      'name': '',
      'title': 'Select'
    },
    {
      'name': 'hour',
      'title': 'Horas'
    },
    {
      'name': 'day',
      'title': 'Dias'
    },
    {
      'name': 'week',
      'title': 'Semanas'
    },
    {
      'name': 'month',
      'title': 'Meses'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        //padding: EdgeInsets.all(8.0),
          itemCount: 1,
          itemBuilder: (context, i) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  const Text('Selecione a frequência'),

                  Row(
                    children: [
                      Expanded(child: Text('à cada')),
                      Expanded(child: Input(
                          text: 'x', controller: controller_frequency_period)),
                      Expanded(child: Select(text: 'Horas',
                          options: options,
                          selected: frequency_value,
                          onChanged: (String? newValue) {
                            frequency_value = newValue.toString();
                            setState(() {

                            });
                          })),
                    ],
                  ),

                  const Text('Selecione a duração'),

                  Row(
                    children: [
                      Expanded(child: Text('à cada')),
                      Expanded(child: Input(
                          text: 'x', controller: controller_duration_period)),
                      Expanded(child: Select(text: 'Horas',
                          options: options,
                          selected: frequency_value,
                          onChanged: (String? newValue) {
                            frequency_value = newValue.toString();
                            setState(() {

                            });
                          })),
                    ],
                  ),

                  GestureDetector(
                      onTap: () async {
                        await insert("INSERT INTO calendar ("
                            "frequency_period, "
                            "frequency_value, "
                            "duration_period, "
                            "duration_value"
                            ") VALUES ( "
                            "'${controller_frequency_period.text}', "
                            "'${frequency_value}', "
                            "'${controller_duration_period.text}', "
                            "'${duration_value}'"
                            ")");
                      },
                      child: Button(text: 'Salvar', color: Colors.blue)
                  ),


                ],
              ),
            );
          }),
    );
  }
}