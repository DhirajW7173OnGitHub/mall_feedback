import 'dart:developer';

import 'package:badges/badges.dart' as badges;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Purchase/Purchase_Model/order_history_model.dart';
import 'package:mall_app/Purchase/Purchase_Model/purchase_data.dart';
import 'package:mall_app/Purchase/Purchase_Model/store_list_model.dart';
import 'package:mall_app/Purchase/Widget/order_list_widget.dart';
import 'package:mall_app/Purchase/new_order_list_page.dart';
import 'package:mall_app/Purchase/order_item_history_page.dart.dart';
import 'package:mall_app/Purchase/order_screen.dart';
import 'package:mall_app/Shared_Preference/auth_service_sharedPreference.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({
    super.key,
    required this.mallId,
  });

  final int mallId;

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final searchController = TextEditingController();
  final dateController = TextEditingController();

  FocusNode searchFousNode = FocusNode();
  FocusNode dateFousNode = FocusNode();

  List<Order> filterOrderHistoryList = [];

  String? selectedDate;
  bool isEnterSearch = false;

  @override
  void initState() {
    super.initState();

    log('Getting Mall ID : ${widget.mallId}');
    sessionManager.updateLastLoggedInTimeAndLoggedInStatus();

    _fetchOrderHistoryData();
  }

  _fetchOrderHistoryData() async {
    var res = await globalBloc.doFetchOrderHistoryData(
      phone: StorageUtil.getString(localStorageData.PHONE),
      mallId: widget.mallId.toString(),
    );
    if (res.errorcode == 1) {
      return getDialogOfTime(res.msg);
    } else {
      globalBloc.doFetchStoreListData(widget.mallId.toString());
      setState(() {
        //Add all getting list of order in filterOrderHistoryList
        filterOrderHistoryList.addAll(res.orders);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    searchController.dispose();
  }

  void getDialogOfTime(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  "Alert",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Colors.purple, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                alignment: Alignment.center,
                child: Text(
                  msg,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void getOrderDataAccordingSearch(String query, List<Order> orderHistoryList) {
    setState(() {
      /*here getting query find in orderHistoryList if it exist then
      filterOrderHistoryList update accoding to query*/
      filterOrderHistoryList = orderHistoryList
          .where((item) => item.storeName.contains(query))
          .toList();
      //userd for showing date search by isEnterSearch
      if (query != "") {
        isEnterSearch = true;
      } else {
        isEnterSearch = false;
        selectedDate = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Order History"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NewOrderProductScreen(
                      mallId: widget.mallId,
                    ),
                  ),
                );
              },
              child: badges.Badge(
                showBadge: true,
                position: badges.BadgePosition.topEnd(top: -9, end: -5),
                badgeStyle:
                    badges.BadgeStyle(borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  "New Order",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            StreamBuilder<StoreListModel>(
              stream: globalBloc.getStoreList.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No Store List"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                //Store List save here in storeList
                var storeList = snapshot.data!.data;

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: DropdownSearch<StoreDatum>(
                    //dropdownDecoratorProps used in decoration of Dropdown
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: "Select Store",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF000000)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 10),
                      ),
                    ),
                    //popupProps used in decoration of Showing data
                    popupProps: const PopupProps.menu(
                      menuProps: MenuProps(),
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Search Here",
                          contentPadding: EdgeInsets.only(left: 10),
                        ),
                      ),
                      fit: FlexFit.tight,
                      constraints: BoxConstraints(maxHeight: 300),
                    ),
                    //All mallList Data put in items
                    items: storeList,
                    //itemAsString is used for show an item in dropdown
                    itemAsString: (StoreDatum item) => item.brandName,
                    onChanged: (StoreDatum? selectStore) async {
                      if (selectStore != null) {
                        setState(() {
                          var storeId = selectStore.storeid;
                          globalBloc.doFetchOrderHistoryData(
                              phone:
                                  StorageUtil.getString(localStorageData.PHONE),
                              mallId: widget.mallId.toString(),
                              storeId: storeId);
                        });
                      }
                    },
                  ),
                );
              },
            ),
            StreamBuilder<OrderHistoryModel>(
              stream: globalBloc.getOrderHistory.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No Order Data"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                var orderList = snapshot.data!.orders;
                return (orderList.isEmpty)
                    ? Expanded(
                        child: Center(
                          child: Text(
                            snapshot.data!.msg,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Total Invoice Amout : ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot.data!.totalInvoiceAmount,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Total Available Point : ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot.data!.availablePoint,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.w400),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed:
                                              (snapshot.data!.availablePoint ==
                                                          "0" ||
                                                      snapshot
                                                          .data!
                                                          .availablePoint
                                                          .isEmpty)
                                                  ? null
                                                  : () {
                                                      navigateToOrderPage();
                                                    },
                                          icon: const Icon(
                                            Icons.send,
                                            color: Colors.purple,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: orderList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: OrderListWidget(
                                      onTap: () {
                                        clickOnParticularOrderData(
                                            orderList[index]);
                                      },
                                      invoiceNu: orderList[index].receiptNo,
                                      storeName: orderList[index].storeName,
                                      storeId: orderList[index].storeid,
                                      customerName:
                                          orderList[index].customerName,
                                      paymentMode: orderList[index].paymentMode,
                                      phone: orderList[index].contactNo,
                                      receiptDate:
                                          DateFormat("dd-MMM-yyyy").format(
                                        DateTime.parse(
                                            orderList[index].receiptDateTime),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void navigateToOrderPage() {
    PurchaseData args;
    args = PurchaseData(
      mallId: widget.mallId.toString(),
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OrderPage(),
        settings: RouteSettings(
          arguments: args,
        ),
      ),
    );
  }

  void clickOnParticularOrderData(Order orderData) {
    //Naviagate toOrderItemHistoryScreen with orderData
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

  // Widget buildTextFieldBySearchForOrder(List<Order> orderHistoryData) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: TextFormField(
  //       controller: searchController,
  //       textCapitalization: TextCapitalization.words,
  //       keyboardType: TextInputType.name,
  //       focusNode: searchFousNode,
  //       decoration: const InputDecoration(
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(10),
  //             ),
  //           ),
  //           contentPadding: EdgeInsets.only(left: 10),
  //           hintText: "Search by Store Name"),
  //       onChanged: (value) {
  //         //Enter value in textField find in filterOrderHistoryList
  //         getOrderDataAccordingSearch(value, orderHistoryData);
  //       },
  //     ),
  //   );
  // }

  // Widget buildDateSearchWidget(List<Order> newOrderHistory) {
  //   return GestureDetector(
  //     onTap: () {
  //       _pickDate(newOrderHistory);
  //     },
  //     child: Container(
  //       height: 40,
  //       width: MediaQuery.of(context).size.width * 0.40,
  //       margin: const EdgeInsets.all(8),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         border: Border.all(),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               _selectedDate != null ? _selectedDate! : 'dd-mm-yyyy',
  //               style: Theme.of(context).textTheme.bodyLarge,
  //             ),
  //             const Icon(Icons.calendar_month),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // // Function to show date picker
  // _pickDate(List<Order> newOrderList) async {
  //   //showDatePicker is used to show Dialog for date
  //   //selection which return value in DateTime format
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime.now(),
  //   );

  //   if (pickedDate != null && pickedDate != _selectedDate) {
  //     setState(() {
  //       _selectedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

  //       //again update filterOrderHistoryList by date
  //       filterOrderHistoryList = newOrderList.where((item) {
  //         var receiptDate = DateFormat("dd-MM-yyyy")
  //             .format(DateTime.parse(item.receiptDateTime));

  //         return receiptDate.contains(_selectedDate!);
  //       }).toList();
  //     });
  //   }
  // }
}



   // StreamBuilder<OrderHistoryModel>(
            //   stream: globalBloc.getOrderHistory.stream,
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return const Expanded(
            //         child: Center(
            //           child: Text("No Data"),
            //         ),
            //       );
            //     }
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const CircularProgressIndicator();
            //     }
            //     var orderData = snapshot.data!.orders;
            //     return Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           StreamBuilder<StoreListModel>(
            //             stream: globalBloc.getStoreList.stream,
            //             builder: (context, snapshot) {
            //               if (!snapshot.hasData) {
            //                 return const Center(
            //                   child: Text("No Store List"),
            //                 );
            //               }
            //               if (snapshot.connectionState ==
            //                   ConnectionState.waiting) {
            //                 return const CircularProgressIndicator();
            //               }

            //               //Store List save here in storeList
            //               var storeList = snapshot.data!.data;

            //               //check Store List is not Empty
            //               // if (storeList.isNotEmpty) {
            //               //   firstStoreData = storeList.first;
            //               // }
            //               // log('@@@@@@@@@@@@:${firstStoreData!.brandName}');
            //               return Padding(
            //                 padding: const EdgeInsets.symmetric(
            //                     horizontal: 12, vertical: 8),
            //                 child: DropdownSearch<StoreDatum>(
            //                   //dropdownDecoratorProps used in decoration of Dropdown
            //                   dropdownDecoratorProps:
            //                       const DropDownDecoratorProps(
            //                     dropdownSearchDecoration: InputDecoration(
            //                       hintText: "Select Store",
            //                       border: OutlineInputBorder(
            //                         borderSide:
            //                             BorderSide(color: Color(0xFF000000)),
            //                         borderRadius: BorderRadius.all(
            //                           Radius.circular(6),
            //                         ),
            //                       ),
            //                       contentPadding: EdgeInsets.only(left: 10),
            //                     ),
            //                   ),
            //                   //popupProps used in decoration of Showing data
            //                   popupProps: const PopupProps.menu(
            //                     menuProps: MenuProps(),
            //                     showSearchBox: true,
            //                     searchFieldProps: TextFieldProps(
            //                       decoration: InputDecoration(
            //                         border: OutlineInputBorder(),
            //                         hintText: "Search Here",
            //                         contentPadding: EdgeInsets.only(left: 10),
            //                       ),
            //                     ),
            //                     fit: FlexFit.tight,
            //                     constraints: BoxConstraints(maxHeight: 300),
            //                   ),
            //                   //All mallList Data put in items
            //                   items: storeList,
            //                   //itemAsString is used for show an item in dropdown
            //                   itemAsString: (StoreDatum item) => item.brandName,
            //                   onChanged: (StoreDatum? selectStore) async {
            //                     if (selectStore != null) {
            //                       setState(() {
            //                         var storeId = selectStore.storeid;
            //                         globalBloc.doFetchOrderHistoryData(
            //                             phone: StorageUtil.getString(
            //                                 localStorageData.PHONE),
            //                             mallId: widget.mallId.toString(),
            //                             storeId: storeId);
            //                       });
            //                     }
            //                   },
            //                 ),
            //               );
            //             },
            //           ),
            //           StreamBuilder<OrderHistoryModel>(
            //             stream: globalBloc.getOrderHistory.stream,
            //             builder: (context, snapshot) {
            //               if (!snapshot.hasData) {
            //                 return const Center(
            //                   child: Text("No Order Data"),
            //                 );
            //               }
            //               if (snapshot.connectionState ==
            //                   ConnectionState.waiting) {
            //                 return const CircularProgressIndicator();
            //               }
            //               var orderList = snapshot.data!.orders;
            //               return (orderList.isEmpty)
            //                   ? Expanded(
            //                       child: Center(
            //                         child: Text(
            //                           snapshot.data!.msg,
            //                           style: Theme.of(context)
            //                               .textTheme
            //                               .bodyLarge!
            //                               .copyWith(
            //                                   fontWeight: FontWeight.bold),
            //                         ),
            //                       ),
            //                     )
            //                   : Expanded(
            //                       child: ListView.builder(
            //                         shrinkWrap: true,
            //                         itemCount: orderList.length,
            //                         itemBuilder: (context, index) {
            //                           return Padding(
            //                             padding: const EdgeInsets.symmetric(
            //                                 horizontal: 10, vertical: 3),
            //                             child: OrderListWidget(
            //                               onTap: () {
            //                                 clickOnParticularOrderData(
            //                                     orderList[index]);
            //                               },
            //                               invoiceNu: orderList[index].receiptNo,
            //                               storeName: orderList[index].storeName,
            //                               storeId: orderList[index].storeid,
            //                               customerName:
            //                                   orderList[index].customerName,
            //                               paymentMode:
            //                                   orderList[index].paymentMode,
            //                               phone: orderList[index].contactNo,
            //                               receiptDate:
            //                                   DateFormat("dd-MMM-yyyy").format(
            //                                 DateTime.parse(orderList[index]
            //                                     .receiptDateTime),
            //                               ),
            //                             ),
            //                           );
            //                         },
            //                       ),
            //                     );
            //             },
            //           ),
            //           //  buildTextFieldBySearchForOrder(orderData),
            //           // isEnterSearch
            //           //     ? buildDateSearchWidget(orderData)
            //           //     : Container(),
            //           // const SizedBox(height: 8),
            //           // (filterOrderHistoryList.isEmpty)
            //           //     ? Expanded(
            //           //         child: Container(
            //           //           alignment: Alignment.center,
            //           //           child: Text(
            //           //             "No Order available for that Date.",
            //           //             overflow: TextOverflow.ellipsis,
            //           //             style: Theme.of(context)
            //           //                 .textTheme
            //           //                 .bodyLarge!
            //           //                 .copyWith(fontWeight: FontWeight.bold),
            //           //           ),
            //           //         ),
            //           //       )
            //           //     : Expanded(
            //           //         child: ListView.builder(
            //           //           shrinkWrap: true,
            //           //           itemCount: filterOrderHistoryList.length,
            //           //           itemBuilder: (context, index) {
            //           //             return Padding(
            //           //               padding: const EdgeInsets.symmetric(
            //           //                   horizontal: 10, vertical: 3),
            //           //               child: OrderListWidget(
            //           //                 onTap: () {
            //           //                   clickOnParticularOrderData(
            //           //                       orderData[index]);
            //           //                 },
            //           //                 invoiceNu: filterOrderHistoryList[index]
            //           //                     .receiptNo,
            //           //                 storeName: filterOrderHistoryList[index]
            //           //                     .storeName,
            //           //                 storeId:
            //           //                     filterOrderHistoryList[index].storeid,
            //           //                 customerName:
            //           //                     filterOrderHistoryList[index]
            //           //                         .customerName,
            //           //                 paymentMode: filterOrderHistoryList[index]
            //           //                     .paymentMode,
            //           //                 phone: filterOrderHistoryList[index]
            //           //                     .contactNo,
            //           //                 receiptDate:
            //           //                     DateFormat("dd-MMM-yyyy").format(
            //           //                   DateTime.parse(
            //           //                       filterOrderHistoryList[index]
            //           //                           .receiptDateTime),
            //           //                 ),
            //           //               ),
            //           //             );
            //           //           },
            //           //         ),
            //           //       ),

            //           const SizedBox(height: 20),
            //         ],
            //       ),
            //     );
            //   },
            // ),