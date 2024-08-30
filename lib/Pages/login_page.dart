import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Pages/home_page.dart';
import 'package:mall_app/Shared_Preference/auth_service_sharedPreference.dart';
import 'package:mall_app/Utils/common_code.dart';
import 'package:mall_app/Validation/validation_mixin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin {
  final mobileFormKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  final passController = TextEditingController();

  final mobileFocusNode = FocusNode();
  final passFocusNode = FocusNode();

  bool checkInternet = false;

  bool passVisibility = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Login',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: mobileFormKey,
                    child: TextFormField(
                      controller: mobileController,
                      focusNode: mobileFocusNode,
                      enableInteractiveSelection: false,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(),
                        hintText: "Enter Mobile Number",
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: passController,
                    focusNode: passFocusNode,
                    obscuringCharacter: "*",
                    obscureText: !passVisibility,
                    enableInteractiveSelection: false,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passVisibility = !passVisibility;
                          });
                        },
                        icon: passVisibility
                            ? const Icon(Icons.visibility_outlined)
                            : const Icon(Icons.visibility_off_outlined),
                      ),
                      contentPadding: const EdgeInsets.only(left: 10),
                      border: const OutlineInputBorder(),
                      hintText: "Enter password",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (mobileController.text.isEmpty) {
                      _getMessage("Enter Mobile Number");
                    } else if (passController.text.isEmpty) {
                      _getMessage("Enter Mobile Number");
                    } else {
                      if (mobileFormKey.currentState!.validate()) {
                        _handleLogin();
                        // await globalBloc.doUserLogin(
                        //   context,
                        //   phone: mobileController.text,
                        //   pass: passController.text,
                        // );
                      } else {
                        _getMessage("Enter valid Mobile Number");
                      }
                    }
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    checkInternet = await InternetConnection().hasInternetAccess;
    if (checkInternet) {
      final res = await globalBloc.doUserLogin(
        phone: mobileController.text,
        pass: passController.text,
      );

      log("####: ${res}  -- {res.msg}");

      if (res["errorcode"] == 0 && res["message"].toLowerCase() == "success") {
        await sessionManager.updateLastLoggedInTimeAndLoggedInStatus();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        _getMessage(res["message"]);
      }
    } else {
      _getMessage("Check Internet Connection");
    }
  }

  _getMessage(String msg) {
    CommonCode.commonDialogForData(
      context,
      msg: msg,
      isBarrier: false,
      second: 2,
    );
  }
}
