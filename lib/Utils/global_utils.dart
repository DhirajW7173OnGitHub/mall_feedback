import 'package:flutter/material.dart';

class GlobalUtils {
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
        backgroundColor: Colors.red,
        duration: Duration(seconds: seconds),
        onVisible: onVisible,
      ),
    );
  }
}

GlobalUtils globalUtils = GlobalUtils();
