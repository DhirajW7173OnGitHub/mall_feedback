import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GlobalUtils {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey(debugLabel: 'scaffoldMessengerKey');
  showNegativeSnackBar({
    VoidCallback? onVisible,
    String? msg,
    int seconds = 1,
    BuildContext? context,
  }) {
    return ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(
          msg!,
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: Colors.purple,
        duration: Duration(seconds: seconds),
        onVisible: onVisible,
      ),
    );
  }

  void showSnackBar(String message, {Color color = Colors.purple}) {
    final messenger = scaffoldMessengerKey.currentState;
    messenger?.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void showToastMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.purple,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

GlobalUtils globalUtils = GlobalUtils();
