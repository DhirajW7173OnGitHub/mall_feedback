import 'package:flutter/material.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Purchase/Purchase_Model/new_order_list_model.dart';
import 'package:mall_app/Purchase/Widget/newproduct_order_widget.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';

class NewOrderProductScreen extends StatefulWidget {
  const NewOrderProductScreen({super.key, required this.mallId});

  final int mallId;

  @override
  State<NewOrderProductScreen> createState() => _NewOrderProductScreenState();
}

class _NewOrderProductScreenState extends State<NewOrderProductScreen> {
  @override
  void initState() {
    super.initState();
    globalBloc.doFetchNewOrderProductData(
        userId: StorageUtil.getString(localStorageData.ID),
        mallId: widget.mallId.toString());
  }

//CartWidget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order List"),
      ),
      body: Column(
        children: [
          StreamBuilder<NewProductOrderListModel>(
            stream: globalBloc.getNewOrderProductList.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                return Center(
                  child: Text(
                    "No Data Found",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              var productListData = snapshot.data!.data;
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: productListData.length,
                  itemBuilder: (context, index) {
                    return NewProductOrderWidget(
                      //deleteTap: () {},
                      prodImage: productListData[index].productImage,
                      prodName: productListData[index].productName,
                      prodPoint: productListData[index].usedPoints,
                      prodPrice: productListData[index].price,
                      prodQty:
                          int.parse(productListData[index].productQuantity),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
