import 'package:mall_app/Purchase/Purchase_Model/product_list_model.dart';

class PurchaseData {
  PurchaseData({
    this.totalInvoiceAmount,
    this.availablePoint,
    this.totalLoyaltyPoint,
    this.productDatum,
    this.navigateFromScreen,
    this.mallId,
  });

  String? totalInvoiceAmount;
  String? availablePoint;
  String? totalLoyaltyPoint;
  ProductDatum? productDatum;
  String? navigateFromScreen;
  String? mallId;
}

class Product {
  Product({
    required this.productId,
    required this.productQty,
    required this.usedPoint,
  });

  final String productId;
  final String usedPoint;
  final String productQty;

  // Method to convert the Product object to a Map
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'used_points': usedPoint,
      'product_quantity': productQty,
    };
  }
}

















// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mall_app/Api_caller/bloc.dart';
// import 'package:mall_app/Purchase/Purchase_Model/category_list_model.dart';
// import 'package:mall_app/Purchase/Purchase_Model/product_list_model.dart';
// import 'package:mall_app/Purchase/Purchase_Model/purchase_data.dart';
// import 'package:mall_app/Purchase/Purchase_Model/subcategory_model.dart';
// import 'package:mall_app/Purchase/Widget/order_page_wiget.dart';
// import 'package:mall_app/Purchase/cart_page.dart';
// import 'package:mall_app/Utils/common_log.dart';

// class OrderPage extends StatefulWidget {
//   const OrderPage({
//     super.key,
//   });

//   @override
//   State<OrderPage> createState() => _OrderPageState();
// }

// class _OrderPageState extends State<OrderPage> {
//   final quntityController = TextEditingController();

//   PurchaseData? args;

//   ProductDatum? productData;

//   int? selectedCatId;
//   int? selectedSubCatID;
//   int? selectProdId;

//   @override
//   void initState() {
//     super.initState();

//     Future.delayed(const Duration(microseconds: 000), () {
//       args = ModalRoute.of(context)!.settings.arguments as PurchaseData;
//       try {
//         if (args != null) {
//           setState(() {
//             args = args;
//           });
//           // Logger.dataLog(
//           //     "Argument :${args!.availablePoint}--${args!.totalInvoiceAmount} -- ${args!.totalLoyaltyPoint}");
//         }
//       } catch (e) {
//         Logger.dataPrint('Something went Wrong :$e');
//       }
//       getCallAPIForOrder();
//     });
//   }

//   void getCallAPIForOrder() {
//     globalBloc.doFetchCategoryListData();
//     globalBloc.doFetchSubCategoryListData("");
//     globalBloc.doFetchProductListData(categoryId: "", subCategoryId: "");
//   }

//   void fillCompleteOrderData(String value) {
//     int quntity = int.parse(value);
//     Logger.dataLog("Quntity : $quntity");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Order Page"),
//       ),
//       bottomSheet: SizedBox(
//         height: 100,
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {},
//                   child: const Text('Add Item'),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => const CartPage(),
//                       ),
//                     );
//                   },
//                   child: const Text('Add Item'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           args == null
//               ? const Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : InitialOrderPageDataWidget(
//                   availablePoint: args!.availablePoint.toString(),
//                   totalInvoiceAmount: args!.totalInvoiceAmount.toString(),
//                   totalLoyaltyPoint: args!.totalLoyaltyPoint.toString(),
//                 ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   buildCategoryDropDown(),
//                   const SizedBox(height: 10),
//                   buildSubCategoryDropDown(),
//                   const SizedBox(height: 10),
//                   buildProductListDropDown(),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 80,
//                                 child: RichText(
//                                   text: TextSpan(
//                                     text: "Quntity",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyLarge!
//                                         .copyWith(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold),
//                                     children: [
//                                       TextSpan(
//                                         text: "*",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyLarge!
//                                             .copyWith(
//                                               color: Colors.red,
//                                             ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 20,
//                                 child: TextField(
//                                   controller: quntityController,
//                                   keyboardType: TextInputType.number,
//                                   inputFormatters: [
//                                     FilteringTextInputFormatter.digitsOnly
//                                   ],
//                                   decoration: const InputDecoration(
//                                     hintText: "00",
//                                   ),
//                                   onChanged: (value) {
//                                     fillCompleteOrderData(value);
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         buildValueOfOrder(
//                             name1: "Value",
//                             name: "Rate",
//                             value1: "",
//                             value: ""),
//                         const SizedBox(height: 20),
//                         buildValueOfOrder(
//                             name1: "Tax Value",
//                             name: "Tax",
//                             value1: "",
//                             value: ""),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 100),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildCategoryDropDown() {
//     return StreamBuilder<CategoryListModel>(
//       stream: globalBloc.getCategoryList.stream,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Container();
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         }
//         var categoryList = snapshot.data!.data;
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Select Category",
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyLarge!
//                     .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               DropdownSearch<CategoryDatum>(
//                 //dropdownDecoratorProps used in decoration of Dropdown
//                 dropdownDecoratorProps: const DropDownDecoratorProps(
//                   dropdownSearchDecoration: InputDecoration(
//                     hintText: "Select Category",
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Color(0xFF000000)),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(6),
//                       ),
//                     ),
//                     contentPadding: EdgeInsets.only(left: 10),
//                   ),
//                 ),
//                 //popupProps used in decoration of Showing data
//                 popupProps: const PopupProps.menu(
//                   menuProps: MenuProps(),
//                   showSearchBox: true,
//                   searchFieldProps: TextFieldProps(
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: "Search Here",
//                       contentPadding: EdgeInsets.only(left: 10),
//                     ),
//                   ),
//                   fit: FlexFit.tight,
//                   constraints: BoxConstraints(maxHeight: 300),
//                 ),
//                 items: categoryList,
//                 itemAsString: (item) => item.category,
//                 onChanged: (CategoryDatum? selectedCategory) {
//                   if (selectedCategory != null) {
//                     setState(() {
//                       selectedCatId = selectedCategory.id;

//                       globalBloc
//                           .doFetchSubCategoryListData(selectedCatId.toString());
//                       selectedSubCatID = null;
//                       selectProdId = null;
//                       Logger.dataLog(
//                           "Selected Category ID : $selectedCatId --selected Sub Cat ID : $selectedSubCatID");
//                     });
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget buildSubCategoryDropDown() {
//     return StreamBuilder<SubCategoryListModel>(
//       stream: globalBloc.getSubCategoryList.stream,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Container();
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         }
//         var subcategoryList = snapshot.data!.data;
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Select Sub-Category",
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyLarge!
//                     .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               DropdownSearch<SubCategoryDatum>(
//                 //dropdownDecoratorProps used in decoration of Dropdown
//                 dropdownDecoratorProps: const DropDownDecoratorProps(
//                   dropdownSearchDecoration: InputDecoration(
//                     hintText: "Select Sub-category",
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Color(0xFF000000)),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(6),
//                       ),
//                     ),
//                     contentPadding: EdgeInsets.only(left: 10),
//                   ),
//                 ),
//                 //popupProps used in decoration of Showing data
//                 popupProps: const PopupProps.menu(
//                   menuProps: MenuProps(),
//                   showSearchBox: true,
//                   searchFieldProps: TextFieldProps(
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: "Search Here",
//                       contentPadding: EdgeInsets.only(left: 10),
//                     ),
//                   ),
//                   fit: FlexFit.tight,
//                   constraints: BoxConstraints(maxHeight: 300),
//                 ),
//                 items: subcategoryList,
//                 selectedItem: selectedSubCatID == null
//                     ? null
//                     : subcategoryList.firstWhere(
//                         (subCat) => subCat.id == selectedSubCatID,
//                         // orElse: () => subcategoryList.isNotEmpty
//                         //     ? subcategoryList[0]
//                         //     : null,
//                       ),

//                 itemAsString: (item) => item.name,
//                 onChanged: (SubCategoryDatum? selectedSubCategory) {
//                   if (selectedSubCategory != null) {
//                     setState(() {
//                       selectedSubCatID = selectedSubCategory.id;
//                       Logger.dataLog(
//                           "Selected Sub-Category Id : $selectedSubCatID");
//                       globalBloc.doFetchProductListData(
//                         categoryId: selectedCatId.toString(),
//                         subCategoryId: selectedSubCatID.toString(),
//                       );
//                       selectProdId = null;
//                     });
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget buildProductListDropDown() {
//     return StreamBuilder<ProductListModel>(
//       stream: globalBloc.getProductList.stream,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Container();
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         }

//         var productList = snapshot.data!.data;
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     "Select Product",
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyLarge!
//                         .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     "*",
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleMedium!
//                         .copyWith(color: Colors.red),
//                   )
//                 ],
//               ),
//               DropdownSearch<ProductDatum>(
//                 //dropdownDecoratorProps used in decoration of Dropdown
//                 dropdownDecoratorProps: const DropDownDecoratorProps(
//                   dropdownSearchDecoration: InputDecoration(
//                     hintText: "Select Product",
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Color(0xFF000000)),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(6),
//                       ),
//                     ),
//                     contentPadding: EdgeInsets.only(left: 10),
//                   ),
//                 ),
//                 //popupProps used in decoration of Showing data
//                 popupProps: const PopupProps.menu(
//                   menuProps: MenuProps(),
//                   showSearchBox: true,
//                   searchFieldProps: TextFieldProps(
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: "Search Here",
//                       contentPadding: EdgeInsets.only(left: 10),
//                     ),
//                   ),
//                   fit: FlexFit.tight,
//                   constraints: BoxConstraints(maxHeight: 250),
//                 ),
//                 items: productList,
//                 selectedItem: (selectProdId == null)
//                     ? null
//                     : productList
//                         .firstWhere((product) => product.id == selectProdId),
//                 itemAsString: (item) => item.productName,
//                 onChanged: (ProductDatum? selectedProduct) {
//                   if (selectedProduct != null) {
//                     setState(() {
//                       selectProdId = selectedProduct.id;
//                       productData = selectedProduct;
//                     });
//                   }
//                 },
//               ),
//               const SizedBox(height: 12),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget buildValueOfOrder(
//       {String? name, String? value, String? name1, String? value1}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width * 0.30,
//           decoration: const BoxDecoration(
//             shape: BoxShape.rectangle,
//             border: Border(
//               bottom: BorderSide(
//                 color: Color(0xffB2B2B2),
//                 width: 2.0,
//               ),
//             ),
//           ),
//           child: Column(
//             children: [
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Container(
//                   padding: const EdgeInsets.only(left: 10, top: 2),
//                   child: Text(
//                     name!,
//                     style: const TextStyle(
//                       fontSize: 10.0,
//                     ),
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Container(
//                   padding: const EdgeInsets.only(left: 10, bottom: 3),
//                   child: Text(
//                     value!,
//                     style: const TextStyle(
//                       fontSize: 10.0,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 20),
//         Container(
//           width: MediaQuery.of(context).size.width * 0.30,
//           decoration: const BoxDecoration(
//             shape: BoxShape.rectangle,
//             border: Border(
//               bottom: BorderSide(
//                 color: Color(0xffB2B2B2),
//                 width: 2.0,
//               ),
//             ),
//           ),
//           child: Column(
//             children: [
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Container(
//                   padding: const EdgeInsets.only(left: 10, top: 2),
//                   child: Text(
//                     name1!,
//                     style: const TextStyle(
//                       fontSize: 10.0,
//                     ),
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Container(
//                   padding: const EdgeInsets.only(left: 10, bottom: 3),
//                   child: Text(
//                     value1!,
//                     style: const TextStyle(
//                       fontSize: 10.0,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
