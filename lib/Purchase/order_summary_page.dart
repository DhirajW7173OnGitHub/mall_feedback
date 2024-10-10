import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mall_app/Api_caller/upload_data_api_caller.dart';
import 'package:mall_app/Purchase/Purchase_Model/purchase_data.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';
import 'package:mall_app/Utils/common_code.dart';
import 'package:mall_app/Utils/common_dialog_for_final_order.dart';
import 'package:mall_app/Utils/common_log.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  PurchaseData? args;

  double? priceOfProduct;
  double? finalPriceOfProd;
  double? getProductPoint;
  double? usedPoint;

  bool checkInternet = false;

  //Count Of ProductQty
  int count = 1;

  //Api Send Data Fill Here
  List<Map<String, dynamic>> productList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 00), () {
      args = ModalRoute.of(context)?.settings.arguments as PurchaseData;
      try {
        if (args != null) {
          setState(() {
            args = args;
            priceOfProduct = double.parse(args!.productDatum!.price);
            usedPoint = double.parse(args!.productDatum!.productPoints);
            getProductPoint = double.parse(args!.productDatum!.productPoints);
          });
        }
      } catch (e) {
        Logger.dataPrint('Error Occured in Argument');
      }
      Logger.dataLog("Argument Data : ${args!.productDatum!.productName}");
    });
  }

  void productPrice() {
    setState(() {
      if (count == 1) {
        finalPriceOfProd = priceOfProduct;
        usedPoint = getProductPoint;
      } else {
        finalPriceOfProd = priceOfProduct! * count;
        usedPoint = getProductPoint! * count;
      }
    });
  }

  void increaseQty() {
    setState(() {
      count += 1;
    });
    productPrice();
  }

  void decreaseQty() {
    if (count == 1) {
      CommonCode.commonDialogForData(
        context,
        msg: "Can't Reduce.",
        isBarrier: false,
        second: 2,
      );
    } else {
      setState(() {
        count -= 1;
      });
      productPrice();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Summary"),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (finalPriceOfProd == null)
                    ? "\u{20B9}$priceOfProduct"
                    : "\u{20B9}$finalPriceOfProd",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              ElevatedButton(
                onPressed: finalOrderUpload,
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
      body: args == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Container(
                        height: 300,
                        width: 200,
                        alignment: Alignment.center,
                        child: Image.network(
                          args!.productDatum!.productImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        args!.productDatum!.productName,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "\u{20B9}${args!.productDatum!.price}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Product Point : ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          args!.productDatum!.productPoints,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Available Point : ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          args!.availablePoint!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 35,
                        width: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(border: Border.all()),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: decreaseQty,
                              child: const Text(
                                "-",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                count.toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            InkWell(
                              onTap: increaseQty,
                              child: const Text(
                                "+",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  void finalOrderUpload() async {
    EasyLoading.show(dismissOnTap: false);
    checkInternet = await InternetConnection().hasInternetAccess;
    if (checkInternet) {
      double value = double.parse(args!.availablePoint!);
      if (usedPoint! > value) {
        EasyLoading.dismiss();
        return getMessage("You have not Sufficient Point.");
      }

      productList.add({
        "product_id": args!.productDatum!.id.toString(),
        "used_points": usedPoint.toString(),
        "product_quantity": count.toString(),
      });
      Logger.dataLog("Product List : $productList");
      var res = await UploadFileDataApiCaller().finalProductOrderUploadData(
        mallId: args!.mallId,
        userId: StorageUtil.getString(localStorageData.ID),
        productList: productList,
      );

      if (res!["errorcode"] == 1 || res["errorcode"] == "1") {
        EasyLoading.dismiss();
        return getMessage(res["message"]);
      }
      FinalDialogForOrder.orderCompleteDialog(context, res["message"]);
    } else {
      getMessage("Check Internet Connection.");
    }
  }

  void getMessage(String msg) {
    CommonCode.commonDialogForData(
      context,
      msg: msg,
      isBarrier: false,
      second: 2,
    );
  }
}
