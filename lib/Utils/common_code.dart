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

class CommonLogOut {
  static CommonLogoutDialog(
    BuildContext context, {
    required Function() onTapYes,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Alert",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
            ),
          ),
          content: Text(
            'Do you want Log-Out?',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: onTapYes,
                  child: const Text("Yes"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
