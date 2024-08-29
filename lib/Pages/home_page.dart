import 'package:flutter/material.dart';
import 'package:mall_app/feedback/feedback_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void navigateToProfilePage() {}

  void navigatorPage(int index) {
    switch (index) {
      case 1:
        navigateToProfilePage();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          color: Colors.purple,
          alignment: Alignment.bottomCenter,
          child: const Text(
            "Home Page",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: selectedIndex,
      //   unselectedItemColor: const Color(0xFF757575),
      //   selectedItemColor: Colors.purple,
      //   onTap: (value) {
      //     navigatorPage(value);
      //   },
      //   type: BottomNavigationBarType.fixed,
      //   items: const [
      //     BottomNavigationBarItem(
      //       label: "Home",
      //       icon: Icon(Icons.home),
      //     ),
      //     BottomNavigationBarItem(
      //       label: "Profile",
      //       icon: Icon(Icons.person),
      //     ),
      //   ],
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeedBackScreen(),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text("FEEDBACK"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
