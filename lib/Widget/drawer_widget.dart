import 'package:flutter/material.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
    required this.onTap,
  });

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          width: double.maxFinite,
          color: Colors.purple,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                maxRadius: 40,
                child: Image.asset("assets/images/person.png"),
              ),
              Text(
                StorageUtil.getString(localStorageData.NAME),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24),
              ),
              const SizedBox(height: 5),
              Text(
                (StorageUtil.getString(localStorageData.USERTYPE) == "8")
                    ? "(Customer)"
                    : "(Support user)",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
        buildshowDataWidget(
          context,
          iconData: Icons.phone,
          // inputMsg: "Mobile number",
          showMsg: StorageUtil.getString(localStorageData.PHONE),
        ),
        const Divider(),
        buildshowDataWidget(
          context,
          iconData: Icons.email,
          //inputMsg: "Email ID",
          showMsg: StorageUtil.getString(localStorageData.EMAIL),
        ),
        const Divider(),
        //Spacer() are use to all remaining space
        const Spacer(),
        //Divider is used to straight horizontal line
        const Divider(),
        Align(
          alignment: Alignment.center,
          child: TextButton.icon(
            onPressed: onTap,
            icon: const Icon(
              Icons.logout,
              size: 20,
            ),
            label: Text(
              "Logout",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  //build Common Widget for Code Redundancy
  Widget buildshowDataWidget(BuildContext context,
      {
      //IconData Is Used to get Icon
      IconData? iconData,
      String? showMsg}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Icon(iconData, color: Colors.purple, size: 28),
          const SizedBox(width: 10),
          Text(
            showMsg!,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
    // SizedBox(
    //   width: double.maxFinite,
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           inputMsg!,
    //           style: Theme.of(context)
    //               .textTheme
    //               .bodyLarge!
    //               .copyWith(fontWeight: FontWeight.bold),
    //         ),
    //         Container(
    //           padding: const EdgeInsets.all(6),
    //           width: double.maxFinite,
    //           decoration: BoxDecoration(
    //             border: Border.all(),
    //             color: Colors.white,
    //             borderRadius: BorderRadius.circular(8),
    //           ),
    //           child: Text(
    //             showMsg!,
    //             style: Theme.of(context).textTheme.bodyLarge!.copyWith(
    //                 fontWeight: FontWeight.w400, color: Colors.purple),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
