import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Initial%20Pages/login_page.dart';
import 'package:mall_app/Utils/common_code.dart';
import 'package:mall_app/Validation/validation_mixin.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with ValidationMixin {
  final emailFormKey = GlobalKey<FormState>();
  final phoneFormKey = GlobalKey<FormState>();
  final firstNameFormKey = GlobalKey<FormState>();
  final lastNameFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passWordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmedPassFocusNode = FocusNode();

  bool isShowPassClick = false;
  bool isConfirmPassShowClick = false;

  bool checkInternet = false;

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passWordController.dispose();
    _phoneController.dispose();
  }

  void submitButtonClick() async {
    checkInternet = await InternetConnection().hasInternetAccess;

    if (checkInternet) {
      if (!firstNameFormKey.currentState!.validate()) {
        _getMessage("No Space Allowed in First Name");
      } else if (!lastNameFormKey.currentState!.validate()) {
        _getMessage("No Space Allowed in Last Name");
      } else if (!emailFormKey.currentState!.validate()) {
        _getMessage("Enter Valid Email");
      } else if (!phoneFormKey.currentState!.validate()) {
        _getMessage("Enter Valid Mobile Number");
      } else if (!passwordFormKey.currentState!.validate()) {
        _getMessage("Enter Valid Password");
      } else if (!passwordFormKey.currentState!.validate()) {
        _getMessage("Password Not Match");
      } else {
        var res = await globalBloc.doUserSignUp(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text,
          email: _emailController.text,
          password: _passWordController.text,
          confirmedPass: _confirmPassController.text,
        );

        log("Getting Response : $res --- ${res["errorcode"]}");
        if (res["errorcode"] == 0) {
          _getMessage(res["message"]);
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false);
          });
        } else {
          _getMessage(res["message"]);
        }
      }
    } else {
      _getMessage("check Internet Connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Registration"),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: (_firstNameController.text.isEmpty &&
                      _lastNameController.text.isEmpty &&
                      _emailController.text.isEmpty &&
                      _phoneController.text.isEmpty &&
                      _passWordController.text.isEmpty)
                  ? null
                  : (_passWordController.text != _confirmPassController.text)
                      ? null
                      : () {
                          submitButtonClick();
                        },
              child: const Text("Submit"),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildWidgetForFirstName(),
              buildWidgetForLastName(),
              buildWidgetForPhoneNumber(),
              buildWidgetForEmailID(),
              buildWidgetForPassword(),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWidgetForPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Form(
        key: passwordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCommonTextWidget("Enter Password"),
            TextFormField(
              controller: _passWordController,
              obscureText: !isShowPassClick,
              obscuringCharacter: "*",
              focusNode: passwordFocusNode,
              keyboardType: TextInputType.emailAddress,
              validator: passwordValidation,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.only(left: 10),
                hintText: "Enter password",
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isShowPassClick = !isShowPassClick;
                    });
                  },
                  icon: isShowPassClick
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
              ),
              onChanged: (value) {
                passwordFormKey.currentState!.validate();
                setState(() {});
              },
            ),
            const SizedBox(
              height: 12,
            ),
            buildCommonTextWidget("Confirm Password"),
            TextFormField(
              controller: _confirmPassController,
              obscureText: !isConfirmPassShowClick,
              obscuringCharacter: "*",
              focusNode: confirmedPassFocusNode,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter Confirmed Password";
                }
                if (_confirmPassController.text != _passWordController.text) {
                  return "Not Match";
                }
                return null;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.only(left: 10),
                hintText: "Confirmed password",
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isConfirmPassShowClick = !isConfirmPassShowClick;
                    });
                  },
                  icon: isConfirmPassShowClick
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
              ),
              onChanged: (value) {
                passwordFormKey.currentState!.validate();
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWidgetForEmailID() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCommonTextWidget("Enter Email ID"),
          Form(
            key: emailFormKey,
            child: TextFormField(
              controller: _emailController,
              focusNode: emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              validator: emailValidation,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.only(left: 10),
                hintText: "Enter Email ID",
              ),
              onChanged: (value) {
                emailFormKey.currentState!.validate();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWidgetForPhoneNumber() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCommonTextWidget("Enter Mobile Number"),
          Form(
            key: phoneFormKey,
            child: TextFormField(
              controller: _phoneController,
              focusNode: phoneFocusNode,
              keyboardType: TextInputType.phone,
              validator: phoneValidation,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.only(left: 10),
                hintText: "Enter Mobile Number",
              ),
              onChanged: (value) {
                phoneFormKey.currentState!.validate();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWidgetForLastName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCommonTextWidget("Enter Last Name"),
          Form(
            key: lastNameFormKey,
            child: TextFormField(
              controller: _lastNameController,
              focusNode: lastNameFocusNode,
              keyboardType: TextInputType.name,
              validator: firstNameValidation,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.only(left: 10),
                hintText: "Enter Last Name",
              ),
              onChanged: (value) {
                lastNameFormKey.currentState!.validate();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWidgetForFirstName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCommonTextWidget("Enter First Name"),
          Form(
            key: firstNameFormKey,
            child: TextFormField(
              controller: _firstNameController,
              focusNode: firstNameFocusNode,
              keyboardType: TextInputType.name,
              validator: firstNameValidation,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.only(left: 10),
                hintText: "Enter First Name",
              ),
              onChanged: (value) {
                firstNameFormKey.currentState!.validate();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCommonTextWidget(String msg) {
    return Row(
      children: [
        Text(
          msg,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          "*",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.red),
        )
      ],
    );
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



 // if (_firstNameController.text.isEmpty) {
      //   _getMessage("Enter First Name");
      // } else if (_lastNameController.text.isEmpty) {
      //   _getMessage("Enter Last Name");
      // } else if (_emailController.text.isEmpty) {
      //   _getMessage("Enter email ID");
      // } else if (_phoneController.text.isEmpty) {
      //   _getMessage("Enter Mobile Number");
      // } else if (_passWordController.text.isEmpty) {
      //   _getMessage("Enter Password");
      // } else if (_confirmPassController.text.isEmpty) {
      //   _getMessage("Enter Confi");
      // }

       // Widget buildWidgetForConfirmPass() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         buildCommonTextWidget("Confirm Password"),
  //         TextFormField(
  //           controller: _confirmPassController,
  //           obscureText: !isConfirmPassShowClick,
  //           obscuringCharacter: "*",
  //           focusNode: confirmedPassFocusNode,
  //           keyboardType: TextInputType.emailAddress,
  //           validator: (value) {
  //             if (value!.isEmpty) {
  //               return "Enter Confirmed Password";
  //             }
  //             if (_confirmPassController.text != _passWordController.text) {
  //               return "Not Match";
  //             }
  //             return null;
  //           },
  //           decoration: InputDecoration(
  //             border: const OutlineInputBorder(),
  //             contentPadding: const EdgeInsets.only(left: 10),
  //             hintText: "Confirmed password",
  //             suffixIcon: IconButton(
  //               onPressed: () {
  //                 setState(() {
  //                   isConfirmPassShowClick = !isConfirmPassShowClick;
  //                 });
  //               },
  //               icon: isConfirmPassShowClick
  //                   ? const Icon(Icons.visibility)
  //                   : const Icon(Icons.visibility_off),
  //             ),
  //           ),
  //           onChanged: (value) {
  //             setState(() {});
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }