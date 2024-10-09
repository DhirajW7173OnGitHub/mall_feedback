import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Purchase/Purchase_Model/category_list_model.dart';
import 'package:mall_app/Purchase/Purchase_Model/product_list_model.dart';
import 'package:mall_app/Purchase/Purchase_Model/purchase_data.dart';
import 'package:mall_app/Purchase/Purchase_Model/subcategory_model.dart';
import 'package:mall_app/Purchase/product_detail_page.dart';
import 'package:mall_app/Utils/common_log.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int? selectedCatId;
  int? selectedSubCatID;
  int? selectProdId;

  int selectedCategoryIndex = -1;
  @override
  void initState() {
    super.initState();
    getCallAPIForOrder();
  }

  void getCallAPIForOrder() async {
    await globalBloc.doFetchCategoryListData();
    await globalBloc.doFetchSubCategoryListData("");
    await globalBloc.doFetchProductListData(categoryId: "", subCategoryId: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          buildCategoryList(),
          const SizedBox(height: 10),
          buildSubCategoryDropDown(),
          const SizedBox(height: 20),
          buildProductGridWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void selectCatForProduct(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
  }

  Widget buildCategoryList() {
    return StreamBuilder<CategoryListModel>(
      stream: globalBloc.getCategoryList.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var categoryList = snapshot.data!.data;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                bool isSelectCategory = index == selectedCategoryIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      selectCatForProduct(index);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            isSelectCategory ? Colors.purple : Colors.grey[300],
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        categoryList[index].category,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color:
                                isSelectCategory ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildSubCategoryDropDown() {
    return StreamBuilder<SubCategoryListModel>(
      stream: globalBloc.getSubCategoryList.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        var subcategoryList = snapshot.data!.data;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DropdownSearch<SubCategoryDatum>(
            //dropdownDecoratorProps used in decoration of Dropdown
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: "Select Sub-category",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF000000)),
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                contentPadding: EdgeInsets.only(left: 10),
              ),
            ),
            //popupProps used in decoration of Showing data
            popupProps: const PopupProps.menu(
              menuProps: MenuProps(),
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Search Here",
                  contentPadding: EdgeInsets.only(left: 10),
                ),
              ),
              fit: FlexFit.tight,
              constraints: BoxConstraints(maxHeight: 300),
            ),
            items: subcategoryList,
            selectedItem: selectedSubCatID == null
                ? null
                : subcategoryList.firstWhere(
                    (subCat) => subCat.id == selectedSubCatID,
                    // orElse: () => subcategoryList.isNotEmpty
                    //     ? subcategoryList[0]
                    //     : null,
                  ),
            itemAsString: (item) => item.name,
            onChanged: (SubCategoryDatum? selectedSubCategory) {
              if (selectedSubCategory != null) {
                setState(() {
                  selectedSubCatID = selectedSubCategory.id;
                  Logger.dataLog(
                      "Selected Sub-Category Id : $selectedSubCatID");
                  globalBloc.doFetchProductListData(
                    categoryId: selectedCatId.toString(),
                    subCategoryId: selectedSubCatID.toString(),
                  );
                  selectProdId = null;
                });
              }
            },
          ),
        );
      },
    );
  }

  Widget buildProductGridWidget() {
    return StreamBuilder<ProductListModel>(
      stream: globalBloc.getProductList.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var productList = snapshot.data!.data;
        return Expanded(
          child: GridView.count(
            shrinkWrap: true,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.66,
            crossAxisCount: 2,
            children: List.generate(
              productList.length,
              (index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: InkWell(
                    onTap: () {
                      clickOnProduct(productList[index]);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 140,
                              child: Image.network(
                                productList[index].productImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                productList[index].productName,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "\u{20B9}${productList[index].price}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Product Point : ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  productList[index].productPoints,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void clickOnProduct(ProductDatum productData) {
    PurchaseData args;
    args = PurchaseData(
        availablePoint: globalBloc.getOrderHistory.stream.value.availablePoint,
        totalInvoiceAmount:
            globalBloc.getOrderHistory.stream.value.totalInvoiceAmount,
        totalLoyaltyPoint:
            globalBloc.getOrderHistory.stream.value.totalLoylityPoints,
        productDatum: productData);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProductDetailsPage(),
        settings: RouteSettings(
          arguments: args,
        ),
      ),
    );
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
