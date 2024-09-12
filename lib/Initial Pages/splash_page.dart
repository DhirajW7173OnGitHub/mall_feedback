import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mall_app/Initial%20Pages/home_page.dart';
import 'package:mall_app/Initial%20Pages/login_page.dart';
import 'package:mall_app/Purchase/purchase_page.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? version;
  @override
  void initState() {
    super.initState();

    _loadWidget();
  }

  _loadWidget() async {
    PackageInfo package = await PackageInfo.fromPlatform();

    setState(() {
      version = package.version;
    });

    var _duration = const Duration(seconds: 4);
    return Timer(_duration, navigateToPage);
  }

  void navigateToPage() async {
    final loggedIn = StorageUtil.getString(localStorageData.ISLOGGEDIN) != "";
    final lastLoginTime =
        StorageUtil.getString(localStorageData.LASTLOGGEDINTIME);
    if (loggedIn) {
      if (lastLoginTime != null) {
        final lastLoginDateTime = DateTime.parse(lastLoginTime);
        final timeDifference = DateTime.now().difference(lastLoginDateTime);

        // Check if the last login time is within the last 24 hours
        if (timeDifference.inHours <= 24) {
          if (StorageUtil.getString(localStorageData.USERTYPE) == "4") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PurchaseScreen(),
              ),
            );
          }

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
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "WEL-COME",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              version ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
