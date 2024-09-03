import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Attendance%20/Model/attendance_details_model.dart';
import 'package:mall_app/Attendance%20/Widget/attendance_details_widget.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';
import 'package:mall_app/Utils/common_code.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  LocationData? currentLocation;

  String endTime = "";

  bool isFinalUnMarkAttendance = false;
  @override
  void initState() {
    super.initState();
    _getAttendanceData();
  }

  _getAttendanceData() async {
    DateTime now = DateTime.now();
    String currentData = DateFormat("yyyy-MM-dd").format(now);
    var res = await globalBloc.doFetchAttendanceDetailsData(
        userId: StorageUtil.getString(localStorageData.ID), date: currentData);
    setState(() {
      //DateFormat("HH:mm:ss").format()
      endTime = res.attendance.endTime;
      log("End Mark Time : $endTime");
    });
  }

  _clickonMarkIcon() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Alert",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.purple,
              ),
            ),
            content: Text(
              "Do you want un-marked your Attendance?",
              // (endTime == "00:00:00")
              //     ? "Do you want un-marked your Attendance?"
              //     : "Do you want marked your Attendance?",
              textAlign: TextAlign.center,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _clickOnYesForUnmark();

                      Navigator.pop(context);
                    },
                    child: const Text("Yes"),
                  ),
                ],
              ),
            ],
          );
        });
  }

  _clickOnYesForUnmark() async {
    await _getUserLocation();
    DateTime now = DateTime.now();
    String currentDate = DateFormat("yyyy-MM-dd").format(now);
    String currentTime = DateFormat("HH:mm:ss").format(now);
    var res = await globalBloc.doUnMarkUserAttendance(
      userId: StorageUtil.getString(localStorageData.ID),
      date: currentDate,
      endTime: currentTime,
      lat: currentLocation!.latitude.toString(),
      long: currentLocation!.longitude.toString(),
    );

    if (res["errorcode"] == 0) {
      _getCommonCodeDialog(res["message"]);
    } else {
      _getCommonCodeDialog(res["message"]);
    }

    // if (endTime == "00:00:00") {
    //   var res = await globalBloc.doUnMarkUserAttendance(
    //     userId: StorageUtil.getString(localStorageData.ID),
    //     date: currentDate,
    //     endTime: currentTime,
    //     lat: currentLocation!.latitude.toString(),
    //     long: currentLocation!.longitude.toString(),
    //   );

    //   if (res["errorcode"] == 0) {
    //     _getCommonCodeDialog(res["message"]);
    //   } else {
    //     _getCommonCodeDialog(res["message"]);
    //   }
    // } else {
    //   var res = await globalBloc.doMarkUserAttendance(
    //     userId: StorageUtil.getString(localStorageData.ID),
    //     todayDate: currentDate,
    //     startTime: currentTime,
    //     lat: '${currentLocation!.latitude}',
    //     long: '${currentLocation!.longitude}',
    //     present: 'yes',
    //   );

    //   if (res["errorcode"] == 0) {
    //     _getCommonCodeDialog(res["message"]);
    //   } else {
    //     _getCommonCodeDialog(res["message"]);
    //   }
    // }
  }

  Future<bool> _getUserLocation() async {
    EasyLoading.show(dismissOnTap: false);
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

    EasyLoading.dismiss();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Attendance"),
          actions: [
            (endTime == "00:00:00")
                ? TextButton(
                    onPressed: _clickonMarkIcon,
                    child: const Text(
                      "End Day",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : Container(),
            // TextButton(
            //     onPressed: _clickonMarkIcon,
            //     child: const Text("mark"),
            //   ),
          ],
        ),
        body: Column(
          children: [
            StreamBuilder<AttendanceDataModel>(
              stream: globalBloc.getAttendanceData.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                var attendanceData = snapshot.data!.attendance;
                return AttendanceCardWidget(
                  userName: attendanceData.userName,
                  date: attendanceData.date,
                  endTime: attendanceData.endTime,
                  reportedTime: attendanceData.reportedTime,
                  startTime: attendanceData.startTime,
                  status: attendanceData.status,
                );
              },
            ),
          ],
        ),
        //  SingleChildScrollView(
        //   child:
        // ),
      ),
    );
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
