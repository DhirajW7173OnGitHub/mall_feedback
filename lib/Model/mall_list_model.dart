// To parse this JSON data, do
//
//     final MallListModel = MallListModelFromJson(jsonString);

import 'dart:convert';

MallListModel mallListModelFromJson(String str) =>
    MallListModel.fromJson(json.decode(str));

String mallListModelToJson(MallListModel data) => json.encode(data.toJson());

class MallListModel {
  int errorcode;
  String msg;
  List<MallDatum> data;

  MallListModel({
    required this.errorcode,
    required this.msg,
    required this.data,
  });

  factory MallListModel.fromJson(Map<String, dynamic> json) => MallListModel(
        errorcode: json["errorcode"],
        msg: (["", null, false, 0].contains(json["message"]))
            ? ""
            : json["message"],
        data: (json["data"] == null || json["data"] == [])
            ? []
            : List<MallDatum>.from(
                json["data"].map((x) => MallDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MallDatum {
  int id;
  String name;
  String mallKey;

  MallDatum({
    required this.id,
    required this.name,
    required this.mallKey,
  });

  factory MallDatum.fromJson(Map<String, dynamic> json) => MallDatum(
        id: (["", null, false, 0].contains(json["id"])) ? 0 : json["id"],
        name: (["", null, false, 0].contains(json["name"])) ? "" : json["name"],
        mallKey: (["", null, false, 0].contains(json["mall_key"]))
            ? ""
            : json["mall_key"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mall_key": mallKey,
      };
}
