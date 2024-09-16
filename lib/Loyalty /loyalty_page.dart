import 'package:flutter/material.dart';

class LoyaltyPage extends StatefulWidget {
  const LoyaltyPage({
    super.key,
  });

  @override
  State<LoyaltyPage> createState() => _LoyaltyPageState();
}

class _LoyaltyPageState extends State<LoyaltyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loyalty"),
      ),
    );
  }
}
