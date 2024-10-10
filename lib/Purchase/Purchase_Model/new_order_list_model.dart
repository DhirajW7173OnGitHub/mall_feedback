// To parse this JSON data, do
//
//     final NewProductOrderListModel = NewProductOrderListModelFromJson(jsonString);

import 'dart:convert';

NewProductOrderListModel newProductOrderListModelFromJson(String str) =>
    NewProductOrderListModel.fromJson(json.decode(str));

String newProductOrderListModelToJson(NewProductOrderListModel data) =>
    json.encode(data.toJson());

class NewProductOrderListModel {
  int errorcode;
  String msg;
  List<NewProductOrderDatum> data;

  NewProductOrderListModel({
    required this.errorcode,
    required this.msg,
    required this.data,
  });

  factory NewProductOrderListModel.fromJson(Map<String, dynamic> json) =>
      NewProductOrderListModel(
        errorcode: json["errorcode"],
        msg: json["message"] ?? "",
        data: (json["data"] == null || json["data"] == [])
            ? []
            : List<NewProductOrderDatum>.from(json["data"].map((x) => NewProductOrderDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "message": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class NewProductOrderDatum {
  int id;
  String productId;
  String productName;
  String productImage;
  String price;
  String productQuantity;
  String usedPoints;
  String productAmount;
  String redemptionDate;

  NewProductOrderDatum({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.productQuantity,
    required this.usedPoints,
    required this.productAmount,
    required this.redemptionDate,
  });

  factory NewProductOrderDatum.fromJson(Map<String, dynamic> json) => NewProductOrderDatum(
        id: json["id"],
        productId: json["product_id"]??"",
        productName: json["product_name"]??"",
        productImage: json["product_image"]??"",
        price: json["price"]??"",
        productQuantity: json["product_quantity"]??"",
        usedPoints: json["used_points"]??"",
        productAmount: json["product_amount"]??"",
        redemptionDate: json["redemption_date"]??"",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "product_name": productName,
        "product_image": productImage,
        "price": price,
        "product_quantity": productQuantity,
        "used_points": usedPoints,
        "product_amount": productAmount,
        "redemption_date": redemptionDate,
      };
}
