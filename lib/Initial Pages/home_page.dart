import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Attendance%20/attendance_page.dart';
import 'package:mall_app/Initial%20Pages/login_page.dart';
import 'package:mall_app/Model/mobile_menu_model.dart';
import 'package:mall_app/Shared_Preference/auth_service_sharedPreference.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';
import 'package:mall_app/Utils/common_code.dart';
import 'package:mall_app/Utils/global_utils.dart';
import 'package:mall_app/Widget/home_page_widget.dart';
import 'package:mall_app/feedback/feedback_page.dart';
import 'package:mall_app/loyalty%20/loyalty_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  LocationData? currentLocation;
  LatLng? userLocation;
  Set<Marker> markers = {};
  String? address;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    sessionManager.updateLastLoggedInTimeAndLoggedInStatus();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      globalBloc.doFetchMobileMenu(
        userId: StorageUtil.getString(localStorageData.ID),
      );

      _getDialogForAttendance();
    });
  }

  _getDialogForAttendance() async {
    DateTime now = DateTime.now();
    String currentDate = DateFormat('yyyy-MM-dd').format(now);
    String currentTime = DateFormat('HH:mm:ss').format(now);
    var res = await globalBloc.doFetchAttendanceDetailsData(
        userId: StorageUtil.getString(localStorageData.ID), date: currentDate);

    log('Attendance :${res.attendance == {}}--${res.errorcode} ${res.msg}');
    if (res.attendance != {} && res.errorcode == 1) {
      initialDialogForAttendance();
    } else {
      globalUtils.showSnackBar(res.msg);
      //_getCommonCodeDialog(res.msg);
    }
  }

  initialDialogForAttendance() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Attendance Alert!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.purple),
          ),
          content: const Text(
            'Would you like to submit your daily attendance now?',
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 50,
                  child: TextButton(
                    child: Text(
                      'No'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.purple),
                    ),
                    onPressed: () async {
                      DateTime now = DateTime.now();
                      String currentDate = DateFormat('yyyy-MM-dd').format(now);
                      String currentTime = DateFormat('HH:mm:ss').format(now);

                      await globalBloc.doMarkUserAttendance(
                        userId: StorageUtil.getString(localStorageData.ID),
                        startTime: currentTime,
                        todayDate: currentDate,
                        lat: "",
                        long: "",
                        present: "no",
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Expanded(
                  flex: 50,
                  child: TextButton(
                    child: Text(
                      'Yes'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.purple),
                    ),
                    onPressed: () async {
                      print(' yes click');

                      _showMapDialog(checkInFromMap: () {
                        _getLocationAndTime('yes');
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<bool> _getUserLocation() async {
    final location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        return false; // Location services were not enabled
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        _permissionGranted = await location.requestPermission();
        return false; // Location permission was not granted
      }
    }

    currentLocation = await location.getLocation();
    userLocation =
        await LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
    await _addUserMarker(userLocation!);

    log('adres: ${currentLocation!.latitude} and ${currentLocation!.longitude}');

    // address = await getLocation.getPlaceName(
    //   currentLocation!.latitude!,
    //   currentLocation!.longitude!,
    // );
    //log('address: $address');
    EasyLoading.dismiss();

    return true;
  }

  _addUserMarker(LatLng? location) {
    final userMarker = Marker(
      markerId: const MarkerId('userLocation'),
      position: location!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: 'Your Location'),
    );

    setState(() {
      markers = {userMarker};
    });
  }

  _showMapDialog({required void Function() checkInFromMap}) async {
    EasyLoading.show(dismissOnTap: false);
    var isEnabled = await _getUserLocation();
    EasyLoading.dismiss();

    isEnabled == false
        ? _getUserLocation()
        : finalDialogForLocation(checkInFromMap);
  }

  finalDialogForLocation(void Function() checkInFromMap) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(4),
          title: const Text('Your Current Location'),
          content: Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.5,
            child: GoogleMap(
              mapType: MapType.normal,
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: userLocation!,
                zoom: 15.0,
              ),
              markers: markers,
              mapToolbarEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: checkInFromMap,
              child: const Text(
                'Check In',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ],
        );
      },
    );
  }

  //Mark Attendance
  void _getLocationAndTime(String isPresent) async {
    EasyLoading.show(dismissOnTap: false);
    DateTime now = DateTime.now();
    String currentDate = DateFormat('yyyy-MM-dd').format(now);
    String currentTime = DateFormat('HH:mm:ss').format(now);

    var res = await globalBloc.doMarkUserAttendance(
      userId: StorageUtil.getString(localStorageData.ID),
      todayDate: currentDate,
      startTime: currentTime,
      lat: '${currentLocation!.latitude}',
      long: '${currentLocation!.longitude}',
      present: isPresent,
    );

    EasyLoading.dismiss();
    Navigator.of(context).pop();
  }

  void clickOnLogOut() {
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
                  onPressed: clickOnYesButton,
                  child: const Text("Yes"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void clickOnYesButton() async {
    await StorageUtil.putString(localStorageData.ISLOGGEDIN, "");

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Container(
            child: HomePageWidget(
              onTap: clickOnLogOut,
            ),
          ),
        ),

        // drawer: Drawer(
        //   child: Column(
        //     children: [
        //       Text(
        //         "OK",
        //       )
        //     ],
        //   ),
        // ),
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
            const SizedBox(
              height: 100,
            ),
            StreamBuilder<MobileMenuModel>(
              stream: globalBloc.getMobileMenu.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data!.mobileMenuList.isEmpty) {
                  return const Center(
                    child: Text("No Mofile Menu"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                var menuItem = snapshot.data!.mobileMenuList;
                return Expanded(
                  child: GridView.count(
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    shrinkWrap: true,
                    children: List.generate(
                      menuItem.length,
                      (index) {
                        String imageName = "assets/icons/place.png";
                        Color? color =
                            (menuItem[index].status.toLowerCase() == "active")
                                ? Colors.white
                                : Colors.grey[300];
                        String menuTitle = menuItem[index].menu;
                        if (menuItem[index].id == 1) {
                          imageName = "assets/icons/feedback1.png";
                        } else if (menuItem[index].id == 2) {
                          imageName = "assets/icons/attendance1.png";
                        } else if (menuItem[index].id == 3) {
                          imageName = "assets/icons/place.png";
                        } else {
                          imageName = "assets/icons/place.png";
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Container(
                            // margin: const EdgeInsets.symmetric(horizontal: 10),
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(6),
                              color: color,
                            ),
                            child: InkWell(
                              onTap: () {
                                menuNavigator(menuItem[index].id);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 70,
                                      child: Container(
                                        width: 60,
                                        height: 50,
                                        child: Image.asset(
                                          imageName,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 30,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          menuTitle,
                                          maxLines: 3,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        // Container(
                                        //   width:
                                        //       MediaQuery.of(context).size.width *
                                        //           1,
                                        //   child: Text(
                                        //     menuTitle,
                                        //     maxLines: 3,
                                        //     textAlign: TextAlign.center,
                                        //     style: const TextStyle(
                                        //       fontSize: 14.0,
                                        //       fontWeight: FontWeight.w500,
                                        //       color: Colors.black,
                                        //     ),
                                        //   ),
                                        // ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // void navigateToProfilePage() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const UserProfileScreen(),
  //     ),
  //   );
  // }

  // void navigatorPage(int index) {
  //   switch (index) {
  //     case 1:
  //       navigateToProfilePage();
  //       break;
  //   }
  // }

  void navigateFeedBackPage() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FeedBackScreen(),
      ),
    );
  }

  void navigateAttendancePage() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AttendancePage(),
      ),
    );
  }

  void navigateLoyaltyPage() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoyaltyPage(),
      ),
    );
  }

  void menuNavigator(int id) {
    switch (id) {
      case 1:
        navigateFeedBackPage();
        break;
      case 2:
        navigateAttendancePage();
        break;
      case 3:
        navigateLoyaltyPage();
        break;
    }
  }

  _getCommonCodeDialog(String msg) {
    CommonCode.commonDialogForData(
      context,
      msg: msg,
      isBarrier: false,
      second: 2,
    );
  }
}
