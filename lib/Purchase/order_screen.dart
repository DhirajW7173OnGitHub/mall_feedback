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
  PurchaseData? args;

  int selectedCategoryIndex = -1;

  int? selectedCatId;
  int? selectedSubCatID;
  int? selectProdId;

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

      getCallAPIForOrder();
    });

    // Logger.dataLog(
    //     "Available Point:${globalBloc.getOrderHistory.stream.value.availablePoint}");
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
      body: (args == null)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                buildCategoryList(),
                // const SizedBox(height: 10),
                // buildSubCategoryDropDown(),
                const SizedBox(height: 20),
                buildProductGridWidget(),
                const SizedBox(height: 20),
              ],
            ),
    );
  }

  void selectCategoryFromList(int index, CategoryDatum categoryData) {
    Logger.dataLog(
        "Index : $index -- Category Data : ${categoryData.category}");
    setState(() {
      //Selection For Category
      selectedCategoryIndex = index;
      //Set categoryData.id in selectedCatId
      selectedCatId = categoryData.id;
      //When Category Select Then SubCategory Refresh
      selectedSubCatID = null;
      //Fetch Sub Category
      globalBloc.doFetchSubCategoryListData(categoryData.id.toString());
      //Fetch Product
      globalBloc.doFetchProductListData(
          categoryId: categoryData.id.toString(), subCategoryId: "");
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
              // shrinkWrap: true,
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                bool isSelectCategory = index == selectedCategoryIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      selectCategoryFromList(index, categoryList[index]);
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
        if (subcategoryList.isEmpty || subcategoryList == null) {
          return SizedBox(
            child: Center(
              child: Text(
                snapshot.data!.msg,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
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

        if (productList.isEmpty || productList == null) {
          return Expanded(
            child: Center(
              child: Text(
                snapshot.data!.msg,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

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
    PurchaseData arg;
    arg = PurchaseData(
      availablePoint: globalBloc.getOrderHistory.stream.value.availablePoint,
      totalInvoiceAmount:
          globalBloc.getOrderHistory.stream.value.totalInvoiceAmount,
      totalLoyaltyPoint:
          globalBloc.getOrderHistory.stream.value.totalLoylityPoints,
      productDatum: productData,
      mallId: args!.mallId,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProductDetailsPage(),
        settings: RouteSettings(
          arguments: arg,
        ),
      ),
    );
  }
}
