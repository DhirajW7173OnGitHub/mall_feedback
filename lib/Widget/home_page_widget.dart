import 'package:flutter/material.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({
    super.key,
    // required this.onTap,
  });

  // final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              //this code allow to open Drawer
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
          CircleAvatar(
            maxRadius: 40,
            child: Image.asset("assets/images/person.png"),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StorageUtil.getString(localStorageData.NAME),
                style:
                    // GoogleFonts.akayaKanadaka(
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.purple,
                    //     fontSize: 26),
                    Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                        fontSize: 26),
              ),
            ],
          ),
          // const Spacer(),
          // IconButton(
          //   onPressed: onTap,
          //   icon: const Icon(
          //     Icons.logout,
          //     color: Colors.purple,
          //   ),
          // ),
        ],
      ),
    );
  }
}
