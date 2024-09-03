// To parse this JSON data, do
//
//     final AttendanceDataModel = AttendanceDataModelFromJson(jsonString);

import 'dart:convert';

AttendanceDataModel attendanceDataModelFromJson(String str) =>
    AttendanceDataModel.fromJson(json.decode(str));

String attendanceDataModelToJson(AttendanceDataModel data) =>
    json.encode(data.toJson());

class AttendanceDataModel {
  int errorcode;
  String msg;
  Attendance attendance;

  AttendanceDataModel({
    required this.errorcode,
    required this.attendance,
    required this.msg,
  });

  factory AttendanceDataModel.fromJson(Map<String, dynamic> json) =>
      AttendanceDataModel(
        errorcode: json["errorcode"],
        msg: (["", null, false, 0].contains(json["message"]))
            ? ""
            : json["message"],
        attendance: (json["attendance"] == null || json["attendance"] == {})
            ? Attendance(
                userId: 0,
                userName: "",
                date: "",
                startTime: "",
                endTime: "",
                status: "",
                reportedTime: "")
            : Attendance.fromJson(json["attendance"]),
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "attendance": attendance.toJson(),
        "message": msg,
      };
}

class Attendance {
  int userId;
  String userName;
  String date;
  String startTime;
  String endTime;
  String status;
  String reportedTime;

  Attendance({
    required this.userId,
    required this.userName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.reportedTime,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        userId: (["", null, false, 0].contains(json["user_id"]))
            ? 0
            : json["user_id"],
        userName: (["", null, false, 0].contains(json["user_name"]))
            ? 0
            : json["user_name"],
        date: (["", null, false, 0].contains(json["date"])) ? 0 : json["date"],
        startTime: (["", null, false, 0].contains(json["start_time"]))
            ? 0
            : json["start_time"],
        endTime: (["", null, false, 0].contains(json["end_time"]))
            ? 0
            : json["end_time"],
        status: (["", null, false, 0].contains(json["status"]))
            ? 0
            : json["status"],
        reportedTime: (["", null, false, 0].contains(json["reported_time"]))
            ? 0
            : json["reported_time"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "date": date,
        "start_time": startTime,
        "end_time": endTime,
        "status": status,
        "reported_time": reportedTime,
      };
}
