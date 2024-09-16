import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Purchase/Purchase_Model/order_history_model.dart';
import 'package:mall_app/Purchase/Widget/order_list_widget.dart';
import 'package:mall_app/Purchase/order_item_history_page.dart.dart';
import 'package:mall_app/Shared_Preference/auth_service_sharedPreference.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  void initState() {
    super.initState();
    sessionManager.updateLastLoggedInTimeAndLoggedInStatus();
    // globalBloc.doFetchPurchaseHistoryData(
    //   phone: StorageUtil.getString(localStorageData.PHONE),
    //   mallId: "PCMB",
    // );
    globalBloc.doFetchOrderHistoryData(
      phone: StorageUtil.getString(localStorageData.PHONE),
      mallId: "1",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
      ),
      body: Column(
        children: [
          StreamBuilder<OrderHistoryModel>(
            stream: globalBloc.getOrderHistory.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.orders.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text("No Data"),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              var orderData = snapshot.data!.orders;
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: orderData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: OrderListWidget(
                        onTap: () {
                          clickOnParticularOrderData(orderData[index]);
                        },
                        storeName: orderData[index].storeName,
                        storeId: orderData[index].storeid,
                        customerName: orderData[index].customerName,
                        paymentMode: orderData[index].paymentMode,
                        phone: orderData[index].contactNo,
                        receiptDate: DateFormat("dd-MMM-yyyy").format(
                          DateTime.parse(orderData[index].receiptDateTime),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void clickOnParticularOrderData(Order orderData) {
    // log("Click on Order Id : ${orderData.anniversary}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OrderItemHistoryScreen(),
        settings: RouteSettings(
          arguments: orderData,
        ),
      ),
    );
  }
}
