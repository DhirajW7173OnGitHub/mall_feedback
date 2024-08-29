import 'package:flutter/material.dart';

class CommonCode {
  static commonDialogForData(
    BuildContext context, {
    required String msg,
    required bool isBarrier,
    required int second,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: second), () {
          Navigator.pop(context);
        });
        return AlertDialog(
          title: SizedBox(
            child: Text(
              msg,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
