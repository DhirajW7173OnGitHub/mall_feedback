import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mall_app/Environment/environment.dart';
import 'package:mall_app/Initial%20Pages/splash_page.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';
import 'package:mall_app/Utils/common_log.dart';
import 'package:mall_app/Utils/global_utils.dart';

import 'firebase_options.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Enviroment SetUp
  const String environment = String.fromEnvironment(
    "ENVIRONMENT",
    defaultValue: Environment.DEV,
  );

  Logger.enviroment = environment;

  Environment().initConfig(environment);

  //Firebase Initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //this code of line use for Dialog of Notitfication Permission
  //await FirebaseMessaging.instance.requestPermission();

  //Initial instance of SharedPreference
  await StorageUtil.getInstance();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: globalUtils.scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        scrollbarTheme: const ScrollbarThemeData(
          // trackColor: MaterialStatePropertyAll(Colors.purple),
          thumbColor: MaterialStatePropertyAll(Colors.purple),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(Colors.purple),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          //brightness: Brightness.dark,
          seedColor: Colors.purple,
          primary: Colors.purple,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
      home: const SplashScreen(),
      navigatorKey: navigatorKey,
    );
  }
}
