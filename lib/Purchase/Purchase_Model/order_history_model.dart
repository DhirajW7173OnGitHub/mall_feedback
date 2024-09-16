// To parse this JSON data, do
//
//     final OrderHistoryModel = OrderHistoryModelFromJson(jsonString);

import 'dart:convert';

OrderHistoryModel orderHistoryModelFromJson(String str) =>
    OrderHistoryModel.fromJson(json.decode(str));

String orderHistoryModelToJson(OrderHistoryModel data) =>
    json.encode(data.toJson());

class OrderHistoryModel {
  int errorcode;
  int totalRecords;
  String msg;
  List<Order> orders;

  OrderHistoryModel({
    required this.errorcode,
    required this.totalRecords,
    required this.msg,
    required this.orders,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      OrderHistoryModel(
        errorcode: json["errorcode"],
        totalRecords: (["", null, false, 0].contains(json["totalRecords"]))
            ? 0
            : json["totalRecords"],
        msg: (["", null, false, 0].contains(json["message"]))
            ? ""
            : json["message"],
        orders: (json["orders"] == null || json["orders"] == [])
            ? []
            : List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "totalRecords": totalRecords,
        "message": msg,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  int id;
  String storeid;
  String storeName;
  String receiptNo;
  String receiptDateTime;
  String invoiceAmount;
  String tax;
  String discount;
  String returnAmount;
  String returnTax;
  String customerName;
  String contactNo;
  String email;
  String location;
  String dateOfBirth;
  String anniversary;
  String paymentMode;

  Order({
    required this.id,
    required this.storeid,
    required this.storeName,
    required this.receiptNo,
    required this.receiptDateTime,
    required this.invoiceAmount,
    required this.tax,
    required this.discount,
    required this.returnAmount,
    required this.returnTax,
    required this.customerName,
    required this.contactNo,
    required this.email,
    required this.location,
    required this.dateOfBirth,
    required this.anniversary,
    required this.paymentMode,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        storeid: (["", null, false, 0].contains(json["storeid"]))
            ? ""
            : json["storeid"],
        storeName: (["", null, false, 0].contains(json["store_name"]))
            ? ""
            : json["store_name"],
        receiptNo: (["", null, false, 0].contains(json["receipt_no"]))
            ? ""
            : json["receipt_no"],
        receiptDateTime:
            (["", null, false, 0].contains(json["receipt_date_time"]))
                ? ""
                : json["receipt_date_time"],
        invoiceAmount: (["", null, false, 0].contains(json["invoice_amount"]))
            ? ""
            : json["invoice_amount"],
        tax: (["", null, false, 0].contains(json["tax"])) ? "" : json["tax"],
        discount: (["", null, false, 0].contains(json["discount"]))
            ? ""
            : json["discount"],
        returnAmount: (["", null, false, 0].contains(json["return_amount"]))
            ? ""
            : json["return_amount"],
        returnTax: (["", null, false, 0].contains(json["return_tax"]))
            ? ""
            : json["return_tax"],
        customerName: (["", null, false, 0].contains(json["customer_name"]))
            ? ""
            : json["customer_name"],
        contactNo: (["", null, false, 0].contains(json["contact_no"]))
            ? ""
            : json["contact_no"],
        email:
            (["", null, false, 0].contains(json["email"])) ? "" : json["email"],
        location: (["", null, false, 0].contains(json["location"]))
            ? ""
            : json["location"],
        dateOfBirth: (["", null, false, 0].contains(json["date_of_birth"]))
            ? ""
            : json["date_of_birth"],
        anniversary: (["", null, false, 0].contains(json["anniversary"]))
            ? ""
            : json["anniversary"],
        paymentMode: (["", null, false, 0].contains(json["payment_mode"]))
            ? ""
            : json["payment_mode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "storeid": storeid,
        "store_name": storeName,
        "receipt_no": receiptNo,
        "receipt_date_time": receiptDateTime,
        "invoice_amount": invoiceAmount,
        "tax": tax,
        "discount": discount,
        "return_amount": returnAmount,
        "return_tax": returnTax,
        "customer_name": customerName,
        "contact_no": contactNo,
        "email": email,
        "location": location,
        "date_of_birth": dateOfBirth,
        "anniversary": anniversary,
        "payment_mode": paymentMode,
      };
}
