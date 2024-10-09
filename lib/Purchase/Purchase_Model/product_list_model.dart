// To parse this JSON data, do
//
//     final ProductListModel = ProductListModelFromJson(jsonString);

import 'dart:convert';

ProductListModel productListModelFromJson(String str) =>
    ProductListModel.fromJson(json.decode(str));

String productListModelToJson(ProductListModel data) =>
    json.encode(data.toJson());

class ProductListModel {
  int errorcode;
  List<ProductDatum> data;

  ProductListModel({
    required this.errorcode,
    required this.data,
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) =>
      ProductListModel(
        errorcode: json["errorcode"],
        data: (json["data"] == [] || json["data"] == null)
            ? []
            : List<ProductDatum>.from(
                json["data"].map((x) => ProductDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ProductDatum {
  int id;
  String catId;
  String subCatId;
  String productImage;
  String productName;
  String description;
  String price;
  String productPoints;

  ProductDatum({
    required this.id,
    required this.catId,
    required this.subCatId,
    required this.productImage,
    required this.productName,
    required this.description,
    required this.price,
    required this.productPoints,
  });

  factory ProductDatum.fromJson(Map<String, dynamic> json) => ProductDatum(
        id: json["id"] ?? 0,
        catId: json["cat_id"] ?? "",
        subCatId: json["sub_cat_id"] ?? "",
        productImage: json["product_image"] ?? "",
        productName: json["product_name"] ?? "",
        description: json["description"] ?? "",
        price: json["price"] ?? "",
        productPoints: json["product_points"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cat_id": catId,
        "sub_cat_id": subCatId,
        "product_image": productImage,
        "product_name": productName,
        "description": description,
        "price": price,
        "product_points": productPoints,
      };
}
