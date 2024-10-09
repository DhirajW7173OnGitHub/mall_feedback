import 'package:flutter/material.dart';
import 'package:mall_app/Purchase/Purchase_Model/purchase_data.dart';
import 'package:mall_app/Utils/common_log.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  PurchaseData? args;

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
      Logger.dataLog("Argument Data : ${args!.productDatum!.productName}");
    });
  }

  void clickOnAddCart() {
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
                      child: Image.network(
                        args!.productDatum!.productImage,
                        fit: BoxFit.cover,
                      ),
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
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
            ),
          ],
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
                  onTap: clickOnAddCart,
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
                  onTap: () {},
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
                        child: Image.network(
                          args!.productDatum!.productImage,
                          fit: BoxFit.cover,
                        ),
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
}
