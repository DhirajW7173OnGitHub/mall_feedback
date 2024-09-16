import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Purchase/Purchase_Model/order_history_model.dart';
import 'package:mall_app/Purchase/Purchase_Model/order_item_history_model.dart';
import 'package:mall_app/Purchase/Widget/order_details_widget.dart';
import 'package:mall_app/Purchase/Widget/order_item_history_widget.dart';

class OrderItemHistoryScreen extends StatefulWidget {
  const OrderItemHistoryScreen({super.key});

  @override
  State<OrderItemHistoryScreen> createState() => _OrderItemHistoryScreenState();
}

class _OrderItemHistoryScreenState extends State<OrderItemHistoryScreen> {
  Order? args;
  int? orderId;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 200), () {
      try {
        args = ModalRoute.of(context)?.settings.arguments as Order;
        log("Geeting Order Id : ${args!.id}");
        setState(() {
          orderId = args!.id;
        });
      } catch (e) {
        print("SOMETHING WENT WRONG");
      }
      _getItemHistoryData();
    });
  }

  _getItemHistoryData() {
    globalBloc.doFetchItemHistoryData(orderId: orderId.toString());
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)?.settings.arguments as Order;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Data"),
      ),
      body: Column(
        children: [
          OrderDetailsWidget(
            anniversary: (args!.anniversary.isEmpty) ? "" : args!.anniversary,
            contactNo: (args!.contactNo.isEmpty) ? "" : args!.contactNo,
            custName: (args!.customerName.isEmpty) ? "" : args!.customerName,
            discount: (args!.discount.isEmpty) ? "" : args!.discount,
            dob: (args!.dateOfBirth.isEmpty) ? "" : args!.dateOfBirth,
            email: (args!.email.isEmpty) ? "" : args!.email,
            invoiceAmount:
                (args!.invoiceAmount.isEmpty) ? "" : args!.invoiceAmount,
            paymentMode: (args!.paymentMode.isEmpty) ? "" : args!.paymentMode,
            receiptDate: (args!.receiptDateTime.isEmpty)
                ? ""
                : DateFormat('dd-MMM-yyyy').format(
                    DateTime.parse(args!.receiptDateTime),
                  ),
            receiptNo: (args!.receiptNo.isEmpty) ? "" : args!.receiptNo,
            returnAmount:
                (args!.returnAmount.isEmpty) ? "" : args!.returnAmount,
            returnTax: (args!.returnTax.isEmpty) ? "" : args!.returnTax,
            storeId: (args!.storeid.isEmpty) ? "" : args!.storeid,
            storeName: (args!.storeName.isEmpty) ? "" : args!.storeName,
            tax: (args!.tax.isEmpty) ? "" : args!.tax,
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: StreamBuilder<OrderItemHistoryModel>(
              stream: globalBloc.getItemHistory.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
                  return const Center(
                    child: Text("No Data Found"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var itemData = snapshot.data!.items;
                return Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: ItemHistoryWidget(
                          discount: itemData[index].discount,
                          itemName: itemData[index].itemName,
                          qty: itemData[index].quantity.toString(),
                          tax: itemData[index].unitTax,
                          total: itemData[index].totalAmount,
                          unitPrice: itemData[index].unitPrice,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
