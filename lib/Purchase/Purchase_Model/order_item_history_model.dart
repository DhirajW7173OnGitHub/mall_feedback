// To parse this JSON data, do
//
//     final OrderItemHistoryModel = OrderItemHistoryModelFromJson(jsonString);

import 'dart:convert';

OrderItemHistoryModel orderItemHistoryModelFromJson(String str) =>
    OrderItemHistoryModel.fromJson(json.decode(str));

String orderItemHistoryModelToJson(OrderItemHistoryModel data) =>
    json.encode(data.toJson());

class OrderItemHistoryModel {
  int errorcode;
  int totalRecords;
  String msg;
  List<Item> items;

  OrderItemHistoryModel({
    required this.errorcode,
    required this.totalRecords,
    required this.msg,
    required this.items,
  });

  factory OrderItemHistoryModel.fromJson(Map<String, dynamic> json) =>
      OrderItemHistoryModel(
        errorcode: json["errorcode"],
        totalRecords: (["", null, false, 0].contains(json["message"]))
            ? 0
            : json["totalRecords"],
        msg: (["", null, false, 0].contains(json["message"]))
            ? ""
            : json["message"],
        items: (json["items"] == [] || json["items"] == null)
            ? []
            : List<Item>.from(
                json["items"].map((x) => Item.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "totalRecords": totalRecords,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  String itemCode;
  String itemName;
  String unitPrice;
  String unitTax;
  String discount;
  int quantity;
  String totalAmount;

  Item({
    required this.itemCode,
    required this.itemName,
    required this.unitPrice,
    required this.unitTax,
    required this.discount,
    required this.quantity,
    required this.totalAmount,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemCode: (["", null, false, 0].contains(json["item_code"]))
            ? ""
            : json["item_code"],
        itemName: (["", null, false, 0].contains(json["item_name"]))
            ? ""
            : json["item_name"],
        unitPrice: (["", null, false, 0].contains(json["unit_price"]))
            ? ""
            : json["unit_price"],
        unitTax: (["", null, false, 0].contains(json["unit_tax"]))
            ? ""
            : json["unit_tax"],
        discount: (["", null, false, 0].contains(json["discount"]))
            ? ""
            : json["discount"],
        quantity: (["", null, false, 0].contains(json["quantity"]))
            ? 0
            : json["quantity"],
        totalAmount: (["", null, false, 0].contains(json["total_amount"]))
            ? ""
            : json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "item_code": itemCode,
        "item_name": itemName,
        "unit_price": unitPrice,
        "unit_tax": unitTax,
        "discount": discount,
        "quantity": quantity,
        "total_amount": totalAmount,
      };
}
