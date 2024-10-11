import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Purchase/Purchase_Model/purchase_data.dart';
import 'package:mall_app/Purchase/Widget/common_network_image_widget.dart';
import 'package:mall_app/Purchase/cart_page.dart';
import 'package:mall_app/Purchase/order_summary_page.dart';
import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';
import 'package:mall_app/Utils/common_code.dart';
import 'package:mall_app/Utils/common_log.dart';
import 'package:mall_app/Utils/global_enum.dart';
import 'package:mall_app/Utils/global_utils.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  PurchaseData? args;

  bool checkInternet = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 00), () {
      args = ModalRoute.of(context)?.settings.arguments as PurchaseData;
      try {
        if (args != null) {
          setState(() {
            args = args;
          });
        }
      } catch (e) {
        Logger.dataPrint('Error Occured in Argument');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        bottomNavigationBar: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 50,
                child: InkWell(
                  onTap: commonBottomSheetForCartAndBuy,
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Add to Cart",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 50,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const OrderSummaryPage(),
                        settings: RouteSettings(arguments: args),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: Colors.black),
                    child: const Text(
                      "Buy now",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: (args == null)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 400,
                        child: CommonNetworkWidget(
                            prodImage: args!.productDatum!.productImage),
                        //  Image.network(
                        //   args!.productDatum!.productImage,
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: args!.productDatum!.productName + " ",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.w700),
                                children: [
                                  TextSpan(
                                    text: args!.productDatum!.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  "Price : ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "\u{20B9}${args!.productDatum!.price}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  "Product Point : ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w500),
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void commonBottomSheetForCartAndBuy() {
    showModalBottomSheet(
      shape: const LinearBorder(),
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 160,
                        width: 100,
                        child: CommonNetworkWidget(
                            prodImage: args!.productDatum!.productImage)
                        //  Image.network(
                        //   args!.productDatum!.productImage,
                        //   fit: BoxFit.cover,
                        // ),
                        ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            args!.productDatum!.productName,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            args!.productDatum!.description,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ),
                        Text(
                          "\u{20B9}${args!.productDatum!.price}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => clickOnContinueForAddToCart(),
                    child: const Text("Continue"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void clickOnContinueForAddToCart() async {
    checkInternet = await InternetConnection().hasInternetAccess;
    if (!checkInternet) {
      return getCommonDialog("Check Internet Connection.");
    }

    var response = await globalBloc.doFetchAllcartProductData(
        userId: StorageUtil.getString(localStorageData.ID),
        mallId: args!.mallId);

    var isExist = response.data.any((product) {
      return int.parse(product.productId) == args!.productDatum!.id;
    });

    if (isExist) {
      Navigator.pop(context);
      commonNavigateForCart();
    } else {
      var res = await globalBloc.doAddProductDataInCart(
        userId: StorageUtil.getString(localStorageData.ID),
        mallId: args!.mallId,
        productId: args!.productDatum!.id.toString(),
        productQty: "1",
        usedPoint: args!.productDatum!.productPoints,
      );

      if (res["errorcode"] == 1 || res["errorcode"] == "1") {
        return getCommonDialog(res["message"]);
      }

      globalUtils.showToastMessage(res["message"]);
      Navigator.pop(context);
      commonNavigateForCart();
    }
  }

  void commonNavigateForCart() {
    PurchaseData arg;
    arg = PurchaseData(
        availablePoint: args!.availablePoint,
        totalInvoiceAmount: args!.totalInvoiceAmount,
        totalLoyaltyPoint: args!.totalLoyaltyPoint,
        productDatum: args!.productDatum,
        navigateFromScreen: EbumCartPage.PRODUCTDETAILPAGE.name);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CartPage(),
        settings: RouteSettings(arguments: args),
      ),
    );
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
