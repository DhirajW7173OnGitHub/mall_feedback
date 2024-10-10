import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Api_caller/upload_data_api_caller.dart';
import 'package:mall_app/Purchase/Purchase_Model/cart_screen_mode.dart';
import 'package:mall_app/Purchase/Purchase_Model/purchase_data.dart';
import 'package:mall_app/Purchase/Widget/cart_page_widget.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';
import 'package:mall_app/Utils/common_code.dart';
import 'package:mall_app/Utils/common_dialog_for_final_order.dart';
import 'package:mall_app/Utils/common_log.dart';
import 'package:mall_app/Utils/global_utils.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String navigatedFromScreen = "";

  PurchaseData? args;

  List<CartDatum> productListData = [];

  bool checkInternet = false;

  //Final Product Amount
  double finalAmount = 0;
  double usedPoint = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 00), () {
      args = ModalRoute.of(context)?.settings.arguments as PurchaseData;
      try {
        if (args!.navigateFromScreen != null) {
          setState(() {
            navigatedFromScreen = args!.navigateFromScreen!;
          });
        }
      } catch (e) {
        Logger.dataPrint('Error Occured in Argument');
      }
      Logger.dataLog("Argument Data : ${args!.productDatum!.productName}");
      getProductCartData();
    });
  }

  void getProductCartData() async {
    var res = await globalBloc.doFetchAllcartProductData(
      userId: StorageUtil.getString(localStorageData.ID),
      mallId: args!.mallId,
    );

    setState(() {
      productListData = res.data;
      calculateTotalPrice();
    });
  }

  void increaseQty(int index) {
    setState(() {
      productListData[index].productQuantity += 1;
      calculateTotalPrice();
    });
  }

  void decreaseQty(int index) {
    if (productListData[index].productQuantity == 1) {
      CommonCode.commonDialogForData(
        context,
        msg: "Can't Reduce.",
        isBarrier: false,
        second: 2,
      );
    } else {
      setState(() {
        productListData[index].productQuantity -= 1;
        calculateTotalPrice();
      });
    }
  }

  void calculateTotalPrice() {
    finalAmount = 0;
    usedPoint = 0;
    for (var product in productListData) {
      double prodPrice = double.parse(product.price);
      double prodPoint = double.parse(product.productPoints);
      finalAmount += prodPrice * product.productQuantity;
      usedPoint += prodPoint * product.productQuantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      bottomNavigationBar: (productListData.isEmpty)
          ? Container(
              height: 100,
            )
          : Container(
              height: 90,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total: \u{20B9}${finalAmount.toStringAsFixed(2)}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Used Point : ${usedPoint.toStringAsFixed(2)}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: finalOrderUpload,
                      child: const Text("Order Product"),
                    ),
                  ],
                ),
              ),
            ),
      body: Column(
        children: [
          StreamBuilder<CartProductListModel>(
            stream: globalBloc.getCartProductList.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
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
              if (snapshot.data!.data.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Text(
                      "No Product In Cart.",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              productListData = snapshot.data!.data;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                    itemCount: productListData.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return CartWidget(
                        onTapOnMinus: () => decreaseQty(index),
                        onTapOnPlus: () => increaseQty(index),
                        deleteTap: () =>
                            deleteProductFromCart(productListData[index]),
                        prodQty: productListData[index].productQuantity,
                        prodImage: productListData[index].productImage,
                        prodName: productListData[index].productName,
                        prodPoint: productListData[index].productPoints,
                        prodPrice: productListData[index].price,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void deleteProductFromCart(CartDatum cartData) async {
    checkInternet = await InternetConnection().hasInternetAccess;
    if (!checkInternet) {
      return globalUtils.showSnackBar("check Internet Connection.");
    }

    var res = await globalBloc.doDeleteProductFromCart(
      userId: StorageUtil.getString(localStorageData.ID),
      mallId: args!.mallId,
      productId: cartData.productId,
      cartId: cartData.id.toString(),
    );

    if (res["errorcode"] == 1 || res["errorcode"] == "1") {
      return getCommonDialog(res["message"]);
    }
    getCommonDialog(res["message"]);
    setState(() {
      getProductCartData();
    });
  }

  void finalOrderUpload() async {
    EasyLoading.show(dismissOnTap: false);
    checkInternet = await InternetConnection().hasInternetAccess;
    if (checkInternet) {
      double value = double.parse(args!.availablePoint!);
      if (usedPoint > value) {
        EasyLoading.dismiss();
        return getCommonDialog("You have not Sufficient Point.");
      }

      //Api Send Data Fill Here
      List<Map<String, dynamic>> productList = [];

      // Iterate productListData and add each product's info to productList
      for (var product in productListData) {
        productList.add({
          "product_id": product.productId,
          "used_points": usedPoint,
          "product_quantity": product.productQuantity.toString(),
        });
      }
      Logger.dataLog("Product List : $productList");
      var res = await UploadFileDataApiCaller().finalProductOrderUploadData(
        mallId: args!.mallId,
        userId: StorageUtil.getString(localStorageData.ID),
        productList: productList,
      );

      if (res!["errorcode"] == 1 || res["errorcode"] == "1") {
        EasyLoading.dismiss();
        return getCommonDialog(res["message"]);
      }
      FinalDialogForOrder.orderCompleteDialog(context, res["message"]);
    } else {
      getCommonDialog("Check Internet Connection.");
    }
  }

  void getCommonDialog(String msg) {
    CommonCode.commonDialogForData(
      context,
      msg: msg,
      isBarrier: false,
      second: 2,
    );
  }
}
