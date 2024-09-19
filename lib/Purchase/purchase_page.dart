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

  String? _selectedDate;
  bool isEnterSearch = false;

  @override
  void initState() {
    super.initState();
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
        _selectedDate = null;
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextFieldBySearchForOrder(orderData),
                      isEnterSearch
                          ? buildDateSearchWidget(orderData)
                          : Container(),
                      const SizedBox(height: 8),
                      (filterOrderHistoryList.isEmpty)
                          ? Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "No Order available for that Date.",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: filterOrderHistoryList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: OrderListWidget(
                                      onTap: () {
                                        clickOnParticularOrderData(
                                            orderData[index]);
                                      },
                                      storeName: filterOrderHistoryList[index]
                                          .storeName,
                                      storeId:
                                          filterOrderHistoryList[index].storeid,
                                      customerName:
                                          filterOrderHistoryList[index]
                                              .customerName,
                                      paymentMode: filterOrderHistoryList[index]
                                          .paymentMode,
                                      phone: filterOrderHistoryList[index]
                                          .contactNo,
                                      receiptDate:
                                          DateFormat("dd-MMM-yyyy").format(
                                        DateTime.parse(
                                            filterOrderHistoryList[index]
                                                .receiptDateTime),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ],
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

  Widget buildTextFieldBySearchForOrder(List<Order> orderHistoryData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: searchController,
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.name,
        focusNode: searchFousNode,
        decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            contentPadding: EdgeInsets.only(left: 10),
            hintText: "Search by Store Name"),
        onChanged: (value) {
          //Enter value in textField find in filterOrderHistoryList
          getOrderDataAccordingSearch(value, orderHistoryData);
        },
      ),
    );
  }

  Widget buildDateSearchWidget(List<Order> newOrderHistory) {
    return GestureDetector(
      onTap: () {
        _pickDate(newOrderHistory);
      },
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width * 0.40,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedDate != null ? _selectedDate! : 'dd-mm-yyyy',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Icon(Icons.calendar_month),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show date picker
  _pickDate(List<Order> newOrderList) async {
    //showDatePicker is used to show Dialog for date
    //selection which return value in DateTime format
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

        //again update filterOrderHistoryList by date
        filterOrderHistoryList = newOrderList.where((item) {
          var receiptDate = DateFormat("dd-MM-yyyy")
              .format(DateTime.parse(item.receiptDateTime));

          return receiptDate.contains(_selectedDate!);
        }).toList();
      });
    }
  }
}
