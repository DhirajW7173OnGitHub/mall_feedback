import 'dart:developer';

class Logger {
  static String enviroment = 'DEV';

  static dataLog(String msg) {
    if (enviroment == 'DEV') {
      log(msg);
    }
  }

  static dataPrint(String msg) {
    if (enviroment == 'DEV') {
      print(msg);
    }
  }
}
