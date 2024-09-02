// To parse this JSON data, do
//
//     final MobileMenuModel = MobileMenuModelFromJson(jsonString);

import 'dart:convert';

MobileMenuModel mobileMenuModelFromJson(String str) =>
    MobileMenuModel.fromJson(json.decode(str));

String mobileMenuModelToJson(MobileMenuModel data) =>
    json.encode(data.toJson());

class MobileMenuModel {
  List<MobileMenuList> mobileMenuList;

  MobileMenuModel({
    required this.mobileMenuList,
  });

  factory MobileMenuModel.fromJson(Map<String, dynamic> json) =>
      MobileMenuModel(
        mobileMenuList: List<MobileMenuList>.from(
            json["mobile_menu_list"].map((x) => MobileMenuList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mobile_menu_list":
            List<dynamic>.from(mobileMenuList.map((x) => x.toJson())),
      };
}

class MobileMenuList {
  int id;
  String menu;
  String status;

  MobileMenuList({
    required this.id,
    required this.menu,
    required this.status,
  });

  factory MobileMenuList.fromJson(Map<String, dynamic> json) => MobileMenuList(
        id: json["id"],
        menu: (["", null, false, 0].contains(json["menu"])) ? "" : json["menu"],
        status: (["", null, false, 0].contains(json["status"]))
            ? ""
            : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "menu": menu,
        "status": status,
      };
}
