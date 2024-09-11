import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Initial%20Pages/home_page.dart';
import 'package:mall_app/Initial%20Pages/register_page.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';
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
  void dispose() {
    super.dispose();
    mobileController.dispose();
    passController.dispose();
    mobileFocusNode.unfocus();
    passFocusNode.unfocus();
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
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (mobileController.text.isEmpty) {
                        _getMessage("Enter Mobile Number");
                      } else if (passController.text.isEmpty) {
                        _getMessage("Enter Mobile Number");
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
                const SizedBox(
                  height: 12,
                ),
                // Center(
                //   child: TextButton(
                //     onPressed: () {},
                //     child: const Text(
                //       "I forgot my password",
                //     ),
                //   ),
                // ),
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
      final res = await globalBloc.doUserLoginAndFetchUserData(
        phone: mobileController.text,
        pass: passController.text,
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
        _navigateFunc();
      } else {
        _getMessage(res.msg);
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

  _navigateFunc() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
}
