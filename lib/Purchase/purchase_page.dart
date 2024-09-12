import 'package:flutter/material.dart';
import 'package:mall_app/Initial%20Pages/login_page.dart';
import 'package:mall_app/Shared_Preference/auth_service_sharedPreference.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';
import 'package:mall_app/Utils/common_code.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  void initState() {
    super.initState();
    sessionManager.updateLastLoggedInTimeAndLoggedInStatus();
  }

  void clickOnLogOut() {
    CommonLogOut.CommonLogoutDialog(context, onTapYes: clickOnYesButton);
  }

  void clickOnYesButton() async {
    await StorageUtil.putString(localStorageData.ISLOGGEDIN, "");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase"),
        actions: [
          IconButton(
            onPressed: clickOnLogOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(),
    );
  }
}
