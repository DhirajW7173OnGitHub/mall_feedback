import 'package:flutter/material.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({
    super.key,
    required this.prodQty,
    required this.prodImage,
    required this.prodName,
    required this.prodPoint,
    required this.prodPrice,
    required this.onTapOnMinus,
    required this.onTapOnPlus,
    required this.deleteTap,
  });

  final String prodName;
  final String prodPrice;
  final String prodPoint;
  final int prodQty;
  final String prodImage;
  final Function() onTapOnMinus;
  final Function() onTapOnPlus;
  final Function() deleteTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 140,
                  width: 80,
                  child: Image.network(
                    prodImage,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        prodName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                          "\u{20B9}$prodPrice",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
                          prodPoint,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
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
                                onTap: onTapOnMinus,
                                child: const Text(
                                  "-",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  prodQty.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              InkWell(
                                onTap: onTapOnPlus,
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
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: deleteTap,
                icon: const Icon(Icons.delete),
                label: const Text("Delete From Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
