// To parse this JSON data, do
//
//     final SubCategoryListModel = SubCategoryListModelFromJson(jsonString);

import 'dart:convert';

SubCategoryListModel subCategoryListModelFromJson(String str) =>
    SubCategoryListModel.fromJson(json.decode(str));

String subCategoryListModelToJson(SubCategoryListModel data) =>
    json.encode(data.toJson());

class SubCategoryListModel {
  int errorcode;

  List<SubCategoryDatum> data;

  SubCategoryListModel({
    required this.errorcode,
    required this.data,
  });

  factory SubCategoryListModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryListModel(
        errorcode: json["errorcode"],
        data: (json["data"] == null || json["data"] == [])
            ? []
            : List<SubCategoryDatum>.from(
                json["data"].map((x) => SubCategoryDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SubCategoryDatum {
  int id;
  String name;

  SubCategoryDatum({
    required this.id,
    required this.name,
  });

  factory SubCategoryDatum.fromJson(Map<String, dynamic> json) =>
      SubCategoryDatum(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
