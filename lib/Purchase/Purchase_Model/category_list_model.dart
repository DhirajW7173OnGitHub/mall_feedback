// To parse this JSON data, do
//
//     final CategoryListModel = CategoryListModelFromJson(jsonString);

import 'dart:convert';

CategoryListModel categoryListModelFromJson(String str) =>
    CategoryListModel.fromJson(json.decode(str));

String categoryListModelToJson(CategoryListModel data) =>
    json.encode(data.toJson());

class CategoryListModel {
  int errorcode;
  List<CategoryDatum> data;

  CategoryListModel({
    required this.errorcode,
    required this.data,
  });

  factory CategoryListModel.fromJson(Map<String, dynamic> json) =>
      CategoryListModel(
        errorcode: json["errorcode"],
        data: (json["data"] == null || json["data"] == [])
            ? []
            : List<CategoryDatum>.from(
                json["data"].map((x) => CategoryDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CategoryDatum {
  int id;
  String category;

  CategoryDatum({
    required this.id,
    required this.category,
  });

  factory CategoryDatum.fromJson(Map<String, dynamic> json) => CategoryDatum(
        id: json["id"] ?? 0,
        category: json["category"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
      };
}
