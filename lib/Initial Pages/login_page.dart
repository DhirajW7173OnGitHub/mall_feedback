import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Initial%20Pages/home_page.dart';
import 'package:mall_app/Initial%20Pages/register_page.dart';
import 'package:mall_app/Purchase/purchase_page.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';
import 'package:mall_app/Utils/common_code.dart';
import 'package:mall_app/Validation/validation_mixin.dart';
import 'package:toggle_switch/toggle_switch.dart';

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

  int selectedToggle = 8;

  @override
  void dispose() {
    super.dispose();
    mobileController.dispose();
    passController.dispose();
    mobileFocusNode.unfocus();
    passFocusNode.unfocus();
  }

  int? _selectToggleSwitchIndex(int index) {
    switch (index) {
      case 0:
        return 8;
      case 1:
        return 4;
      default:
        return null;
    }
  }

  Widget buildToggleSwitchWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ToggleSwitch(
        radiusStyle: true,
        cornerRadius: 10,
        minWidth: 150,
        minHeight: 35,
        fontSize: 15,
        activeBgColor: const [
          Colors.purple,
          Color.fromARGB(255, 206, 80, 228),
          // Color(0xFFE36AF8),
        ],
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.grey[300],
        inactiveFgColor: Colors.black,
        totalSwitches: 2,
        labels: const ["Customer", "Support User"],
        onToggle: (index) {
          selectedToggle = _selectToggleSwitchIndex(index!)!;
        },
      ),
    );
  }

  Widget buildMobileTextFieldWidget() {
    return Padding(
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
    );
  }

  Widget buildPasswordTextFieldWidget() {
    return Padding(
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
    );
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Login',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                buildToggleSwitchWidget(),
                const SizedBox(height: 15),
                buildMobileTextFieldWidget(),
                const SizedBox(height: 15),
                buildPasswordTextFieldWidget(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Text(
                        "Don't have an account?",
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text("Register Here"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        log('Selected UserType : $selectedToggle');
                        if (mobileController.text.isEmpty) {
                          _getMessage("Enter Mobile Number");
                        } else if (passController.text.isEmpty) {
                          _getMessage("Enter Password");
                        } else {
                          if (mobileFormKey.currentState!.validate()) {
                            _handleLogin();
                          } else {
                            _getMessage("Enter valid Mobile Number");
                          }
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
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
      log("Selected Toggle Button : $selectedToggle");
      final res = await globalBloc.doUserLoginAndFetchUserData(
        phone: mobileController.text,
        pass: passController.text,
        userType: selectedToggle.toString(),
      );

      if (res.errorcode == 0 && res.msg.toLowerCase() == "success") {
        await StorageUtil.putString(
            localStorageData.ID, res.user.id.toString());
        StorageUtil.putString(localStorageData.NAME, res.user.name);
        StorageUtil.putString(
            localStorageData.ROLE_ID, res.user.roleId.toString());
        StorageUtil.putString(localStorageData.EMAIL, res.user.email);
        StorageUtil.putString(localStorageData.MALL_ID, res.user.mallIds);
        StorageUtil.putString(localStorageData.LOCATION, res.user.location);
        StorageUtil.putString(localStorageData.PHONE, res.user.phone);
        StorageUtil.putString(localStorageData.TOKEN, res.token);
        StorageUtil.putString(
            localStorageData.USERTYPE, res.userType.toString());
        _navigateFunc();
      } else {
        _getMessage(res.msg);
      }
    } else {
      _getMessage("Check Internet Connection");
    }
  }

  void _navigateFunc() {
    //
    if (selectedToggle == 4 ||
        StorageUtil.getString(localStorageData.USERTYPE) == "4") {
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
  }

  void _getMessage(String msg) {
    CommonCode.commonDialogForData(
      context,
      msg: msg,
      isBarrier: false,
      second: 2,
    );
  }
}
