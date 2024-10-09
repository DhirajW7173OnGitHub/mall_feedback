import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Attendance%20/attendance_page.dart';
import 'package:mall_app/Initial%20Pages/login_page.dart';
import 'package:mall_app/Loyalty%20/loyalty_page.dart';
import 'package:mall_app/Model/mall_list_model.dart';
import 'package:mall_app/Model/mobile_menu_model.dart';
import 'package:mall_app/Purchase/purchase_page.dart';
import 'package:mall_app/Shared_Preference/auth_service_sharedPreference.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';
import 'package:mall_app/Utils/common_code.dart';
import 'package:mall_app/Widget/drawer_widget.dart';
import 'package:mall_app/Widget/home_page_widget.dart';
import 'package:mall_app/feedback/feedback_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MallDatum? selectedMall;
  int selectedIndex = 0;

  int purchaseCount = 0;
  int? mallId;

  LocationData? currentLocation;
  LatLng? userLocation;
  Set<Marker> markers = {};
  String? address;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    sessionManager.updateLastLoggedInTimeAndLoggedInStatus();
    /* This is useful when you need to execute code after the UI has been laid out
    After it Update UI*/
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getMallData();
      globalBloc.doFetchMobileMenu(
        userId: StorageUtil.getString(localStorageData.ID),
        usertype: StorageUtil.getString(localStorageData.USERTYPE),
      );

      (StorageUtil.getString(localStorageData.USERTYPE) == "4")
          ? _getDialogForAttendance()
          : null;
    });
  }

  getMallData() {
    (StorageUtil.getString(localStorageData.USERTYPE) == "8")
        ? globalBloc.doFetchMallListData()
        : null;
  }

  _getDialogForAttendance() async {
    DateTime now = DateTime.now();
    //getting current date formated by Intl package
    String currentDate = DateFormat('yyyy-MM-dd').format(now);
    // String currentTime = DateFormat('HH:mm:ss').format(now);
    var res = await globalBloc.doFetchAttendanceDetailsData(
      userId: StorageUtil.getString(localStorageData.ID),
      date: currentDate,
    );

    log('Attendance :${res.attendance == {}}--${res.errorcode} ${res.msg}');
    //Build Dialog on Attendance Response
    if (res.attendance != {} && res.errorcode == 1) {
      initialDialogForAttendance();
    } else {
      log('you have already marked your attendance');
      //globalUtils.showSnackBar(res.msg);
      //_getCommonCodeDialog(res.msg);
    }
  }

  initialDialogForAttendance() async {
    showDialog(
      context: context,
      //by barrierDismissible user can not interact with screen except Dailog button
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Attendance Alert!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Would you like to submit your daily attendance now?',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
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
                      log(' yes click');
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

    //Location Service Checker(Disable/enable)
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        return false; // Location services were not enabled
      }
    }

    //Permission check for location
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

    log('Location Latitude: ${currentLocation!.latitude} and longitude: ${currentLocation!.longitude}');

    EasyLoading.dismiss();

    return true;
  }

  //Showing Marker on Map
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
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.5,
            child: GoogleMap(
              mapType: MapType.normal,
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              //Set Camera position according to user location(means in target pass Lat long value)
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

  //Mark User Attendance
  Future<void> _getLocationAndTime(String isPresent) async {
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
    CommonLogOut.CommonLogoutDialog(context, onTapYes: clickOnYesButton);
  }

  void clickOnYesButton() async {
    //Delete ISLOGGEDIN data
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
          preferredSize: const Size.fromHeight(80),
          child: Container(
            color: Colors.transparent,
            child: const HomePageWidget(
                //  onTap: clickOnLogOut,
                ),
          ),
        ),
        drawer: Drawer(
          width: 240,
          child: DrawerWidget(
            onTap: clickOnLogOut,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          unselectedItemColor: const Color(0xFF757575),
          selectedItemColor: Colors.purple,
          onTap: (value) {
            navigatorPage(value);
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Notification",
              icon: Icon(Icons.notifications),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            (StorageUtil.getString(localStorageData.USERTYPE) == "8")
                ? buildDrpdownMallListWidget()
                : Container(),
            const SizedBox(height: 5),
            const SizedBox(height: 20),
            StreamBuilder<MobileMenuModel>(
              stream: globalBloc.getMobileMenu.stream,
              // || snapshot.data!.mobileMenuList.isEmpty
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No Mobile Menu"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                var menuItem = snapshot.data!.mobileMenuList;
                return Expanded(
                  child: GridView.count(
                    scrollDirection: Axis.vertical,
                    //crossAxisCount used for how many item want horizontally
                    crossAxisCount: 2,
                    //mainAxisSpacing means vertical spacing
                    mainAxisSpacing: 10,
                    //crossAxisSpacing means horizontal spacing
                    crossAxisSpacing: 10,
                    /*if the list is inside another scrollable or limited-height parent, 
                    and you want the list to only occupy the space it needs then shrinkWrap use */
                    shrinkWrap: true,
                    children: List.generate(
                      menuItem.length,
                      (index) {
                        //default image set here
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
                          imageName = "assets/icons/purchase.png";
                        } else if (menuItem[index].id == 4) {
                          imageName = "assets/icons/loyalty.png";
                        } else {
                          imageName = "assets/icons/place.png";
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Container(
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
                                      child: SizedBox(
                                        width: 80,
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

  Widget buildDrpdownMallListWidget() {
    return Column(
      children: [
        StreamBuilder<MallListModel>(
          stream: globalBloc.getMallListData.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
              return const SizedBox(
                child: Center(
                  child: Text("No Mall Found"),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            //set all getting Data in mallList varible
            var mallList = snapshot.data!.data;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: DropdownSearch<MallDatum>(
                //dropdownDecoratorProps used in decoration of Dropdown
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: "Select Mall",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF000000)),
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                ),
                //popupProps used in decoration of Showing data
                popupProps: const PopupProps.menu(
                  menuProps: MenuProps(elevation: 8),
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Search Here",
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(),
                ),
                //All mallList Data put in items
                items: mallList, //.map((item) => item.name).toList(),
                //itemAsString is used for show an item in dropdown
                itemAsString: (MallDatum item) => item.name,
                onChanged: (MallDatum? selectedMall) async {
                  if (selectedMall != null) {
                    var mallKey = selectedMall.mallKey;
                    var res = await globalBloc.doFetchPurchaseCountData(
                      mallKey: mallKey,
                      phone: StorageUtil.getString(localStorageData.PHONE),
                    );
                    setState(() {
                      if (res["errorcode"] == 0) {
                        purchaseCount = res["purchase_count"];
                        mallId = selectedMall.id;
                      } else {
                        purchaseCount = 0;
                        mallId = selectedMall.id;
                      }
                    });
                  }
                },
              ),
            );
          },
        ),
        // const SizedBox(height: 5),
        // Padding(
        //   padding: const EdgeInsets.only(left: 12, right: 12),
        //   child: Align(
        //     alignment: Alignment.centerLeft,
        //     child: Container(
        //       height: 48,
        //       // width: MediaQuery.of(context).size.width * 0.5,
        //       decoration: BoxDecoration(
        //         border: Border.all(),
        //         borderRadius: BorderRadius.circular(6),
        //       ),
        //       child: Padding(
        //         padding: const EdgeInsets.only(left: 12),
        //         child: Row(
        //           children: [
        //             Text(
        //               'Purchase Count :',
        //               style: Theme.of(context)
        //                   .textTheme
        //                   .bodyLarge!
        //                   .copyWith(fontWeight: FontWeight.w400),
        //             ),
        //             const SizedBox(width: 10),
        //             Text(
        //               purchaseCount.toString(),
        //               style: Theme.of(context)
        //                   .textTheme
        //                   .bodyLarge!
        //                   .copyWith(fontWeight: FontWeight.w400),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  void navigateToProfilePage() {}

  void navigatorPage(int index) {
    switch (index) {
      case 1:
        navigateToProfilePage();
        break;
    }
  }

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

  void navigatePurchasePage() async {
    if (mallId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PurchaseScreen(mallId: mallId!),
        ),
      );
    } else {
      _getCommonCodeDialog("First Select Mall");
    }
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
        navigatePurchasePage();
        break;
      case 4:
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
