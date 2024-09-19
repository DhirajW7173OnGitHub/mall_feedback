import 'package:flutter/material.dart';

class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({
    super.key,
    required this.anniversary,
    required this.contactNo,
    required this.custName,
    required this.discount,
    required this.dob,
    required this.email,
    required this.invoiceAmount,
    required this.paymentMode,
    required this.receiptDate,
    required this.receiptNo,
    required this.returnAmount,
    required this.returnTax,
    required this.storeId,
    required this.storeName,
    required this.tax,
  });

  final String storeId;
  final String storeName;
  final String receiptNo;
  final String receiptDate;
  final String invoiceAmount;
  final String tax;
  final String discount;
  final String returnAmount;
  final String returnTax;
  final String custName;
  final String contactNo;
  final String email;
  final String dob;
  final String anniversary;
  final String paymentMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF5EAF7),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Store ID :",
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.bold),
            //     ),
            //     Text(
            //       storeId,
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.w400),
            //     ),
            //   ],
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Store Name :",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  storeName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Invoice No :",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  receiptNo,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Invoice Date :",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  receiptDate,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Invoice Amount :",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  invoiceAmount,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tax :",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  tax,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Discount :",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  discount,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Return Amount :",
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.bold),
            //     ),
            //     Text(
            //       returnAmount,
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.w400),
            //     ),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Return Tax :",
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.bold),
            //     ),
            //     Text(
            //       returnTax,
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.w400),
            //     ),
            //   ],
            // ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Customer Name :",
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.bold),
            //     ),
            //     Text(
            //       custName,
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.w400),
            //     ),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Contact Number :",
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.bold),
            //     ),
            //     Text(
            //       contactNo,
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.w400),
            //     ),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Email ID :",
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.bold),
            //     ),
            //     Text(
            //       email,
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.w400),
            //     ),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Date Of Birth :",
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.bold),
            //     ),
            //     Text(
            //       dob,
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.w400),
            //     ),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Anniversary :",
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.bold),
            //     ),
            //     Text(
            //       anniversary,
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyLarge!
            //           .copyWith(fontWeight: FontWeight.w400),
            //     ),
            //   ],
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment Mode :",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  paymentMode,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
