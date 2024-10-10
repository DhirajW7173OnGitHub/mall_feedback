import 'package:flutter/material.dart';

class NewProductOrderWidget extends StatelessWidget {
  const NewProductOrderWidget({
    super.key,
    required this.prodQty,
    required this.prodImage,
    required this.prodName,
    required this.prodPoint,
    required this.prodPrice,
  //  required this.deleteTap,
  });

  final String prodName;
  final String prodPrice;
  final String prodPoint;
  final int prodQty;
  final String prodImage;
  //final Function() deleteTap;

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
                  height: 120,
                  width: 80,
                  child: Image.network(
                    prodImage,
                    fit: BoxFit.cover,
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
                    const SizedBox(height: 12),
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
                          prodPoint,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),                   
                  ],
                ),
              ],
            ),
            // const SizedBox(height: 10),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: deleteTap,
            //     child: const Text("Delete Order"),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
