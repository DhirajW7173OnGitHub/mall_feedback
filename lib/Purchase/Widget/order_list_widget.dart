import 'package:flutter/material.dart';

class OrderListWidget extends StatelessWidget {
  const OrderListWidget({
    super.key,
    required this.customerName,
    required this.paymentMode,
    required this.phone,
    required this.receiptDate,
    required this.storeId,
    required this.storeName,
    required this.onTap,
  });

  final String storeId;
  final String storeName;
  final String receiptDate;
  final String customerName;
  final String phone;
  final String paymentMode;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        //  elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Store ID :-",
              //       style: Theme.of(context)
              //           .textTheme
              //           .bodyLarge!
              //           .copyWith(fontWeight: FontWeight.bold),
              //     ),
              //     Text(
              //       storeId,
              //       style: Theme.of(context)
              //           .textTheme
              //           .bodyMedium!
              //           .copyWith(fontWeight: FontWeight.w500),
              //     )
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Store Name :-",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    storeName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Invoice Date  :-",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    receiptDate,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Customer Name :-",
              //       style: Theme.of(context)
              //           .textTheme
              //           .bodyLarge!
              //           .copyWith(fontWeight: FontWeight.bold),
              //     ),
              //     Text(
              //       customerName,
              //       style: Theme.of(context)
              //           .textTheme
              //           .bodyMedium!
              //           .copyWith(fontWeight: FontWeight.w500),
              //     )
              //   ],
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Customer Mobile Number :-",
              //       style: Theme.of(context)
              //           .textTheme
              //           .bodyLarge!
              //           .copyWith(fontWeight: FontWeight.bold),
              //     ),
              //     Text(
              //       phone,
              //       style: Theme.of(context)
              //           .textTheme
              //           .bodyMedium!
              //           .copyWith(fontWeight: FontWeight.w500),
              //     )
              //   ],
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payment Mode :-",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    paymentMode,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
