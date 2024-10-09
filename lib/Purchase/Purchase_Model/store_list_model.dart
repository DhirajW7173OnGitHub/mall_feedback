// To parse this JSON data, do
//
//     final StoreListModel = StoreListModelFromJson(jsonString);

import 'dart:convert';

StoreListModel storeListModelFromJson(String str) =>
    StoreListModel.fromJson(json.decode(str));

String storeListModelToJson(StoreListModel data) => json.encode(data.toJson());

class StoreListModel {
  int errorcode;
  String msg;
  List<StoreDatum> data;

  StoreListModel({
    required this.errorcode,
    required this.data,
    required this.msg,
  });

  factory StoreListModel.fromJson(Map<String, dynamic> json) => StoreListModel(
        errorcode: json["errorcode"],
        msg: (["", null, false, 0].contains(json["message"]))
            ? ""
            : json["message"],
        data: (json["data"] == null || json["data"] == [])
            ? []
            : List<StoreDatum>.from(
                json["data"].map((x) => StoreDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class StoreDatum {
  String storeid;
  String brandName;

  StoreDatum({
    required this.storeid,
    required this.brandName,
  });

  factory StoreDatum.fromJson(Map<String, dynamic> json) => StoreDatum(
        storeid: (["", null, false, 0].contains(json["storeid"]))
            ? ""
            : json["storeid"],
        brandName: json["brand_name"],
      );

  Map<String, dynamic> toJson() => {
        "storeid": storeid,
        "brand_name": brandName,
      };
}
