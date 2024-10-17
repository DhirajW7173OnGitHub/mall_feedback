// To parse this JSON data, do
//
//     final CartProductListModel = CartProductListModelFromJson(jsonString);

import 'dart:convert';

CartProductListModel cartProductListModelFromJson(String str) =>
    CartProductListModel.fromJson(json.decode(str));

String cartProductListModelToJson(CartProductListModel data) =>
    json.encode(data.toJson());

class CartProductListModel {
  int errorcode;
  String msg;
  List<CartDatum> data;

  CartProductListModel({
    required this.errorcode,
    required this.msg,
    required this.data,
  });

  factory CartProductListModel.fromJson(Map<String, dynamic> json) =>
      CartProductListModel(
        errorcode: json["errorcode"],
        msg: (["", null, false, 0].contains(json["message"]))
            ? ""
            : json["message"],
        data: (json["data"] == null || json["data"] == [])
            ? []
            : List<CartDatum>.from(
                json["data"].map((x) => CartDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "message": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CartDatum {
  int id;
  String customerId;
  String mallId;
  String productId;
  int productQuantity;
  String productName;
  String productImage;
  String price;
  String productPoints;

  CartDatum({
    required this.id,
    required this.customerId,
    required this.mallId,
    required this.productId,
    required this.productQuantity,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.productPoints,
  });

  factory CartDatum.fromJson(Map<String, dynamic> json) => CartDatum(
        id: json["id"] ?? 0,
        customerId: json["customer_id"] ?? "",
        mallId: json["mall_id"] ?? "",
        productId: json["product_id"] ?? "",
        productQuantity: json["product_quantity"] ?? 1,
        productName: json["product_name"] ?? "",
        productImage: json["product_image"] ?? "",
        price: json["price"] ?? "",
        productPoints: json["product_points"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "mall_id": mallId,
        "product_id": productId,
        "product_quantity": productQuantity,
        "product_name": productName,
        "product_image": productImage,
        "price": price,
        "product_points": productPoints,
      };
}
