import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mall_app/Pages/home_page.dart';
import 'package:mall_app/Pages/login_page.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  _loadWidget() async {
    var _duration = const Duration(seconds: 4);
    return Timer(_duration, navigateToPage);
  }

  void navigateToPage() async {
    final loggedIn = StorageUtil.getString(LocalStorageData.ISLOGGEDIN) != "";
    final lastLoginTime =
        StorageUtil.getString(LocalStorageData.LASTLOGGEDINTIME);
    if (loggedIn) {
      if (lastLoginTime != null) {
        final lastLoginDateTime = DateTime.parse(lastLoginTime);
        final timeDifference = DateTime.now().difference(lastLoginDateTime);

        // Check if the last login time is within the last 24 hours
        if (timeDifference.inHours <= 24) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
          return;
        }
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "HELLO",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
