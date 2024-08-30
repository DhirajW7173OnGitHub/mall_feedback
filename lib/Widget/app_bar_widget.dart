import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    required this.onTap,
  });

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        children: [
          IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
    );
  }
}
