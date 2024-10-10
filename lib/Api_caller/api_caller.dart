import 'package:http/http.dart' as http;
import 'package:mall_app/Api_caller/api_wrapper.dart';
import 'package:mall_app/Utils/common_log.dart';

class ApiCaller {
  static late http.Client _client;

  //------------------------Sign Up---------------------//
  Future<Map> userSignUpWithData(Map body) async {
    var endPoint = "signup";

    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint(
          "userSignUpWithData body Data : $body -- Response : $res");
      return res;
    } catch (e) {
      Logger.dataPrint('userSignUpWithData Error : $e');
      throw "Something went Wrong : $e";
    }
  }

  //------------------------User Login---------------------//
  Future<Map<String, dynamic>> userLogincall(Map body) async {
    var endPoint = "userlogin";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint("userLogincall body Data : $body -- Response : $res");
      return res;
    } catch (e) {
      Logger.dataPrint('userLogincall Error : $e');
      throw "Something went Wrong : $e";
    }
  }

  //------------------------Mark Attendance---------------------//
  Future<Map> markUserAttendance(Map body) async {
    var endPoint = "mark-attendance";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint(
          'markUserAttendance Body Data : $body --Response : $res');
      return res;
    } catch (e) {
      Logger.dataPrint('markUserAttendance Error : $e');
      throw "Something went Wrong : $e";
    }
  }

  //------------------------End Mark Attendance---------------------//
  Future<Map> endMarkUserAttendance(Map body) async {
    var endPoint = "end-attendance";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint(
          'endMarkUserAttendance Body Data : $body --Response : $res');
      return res;
    } catch (e) {
      Logger.dataPrint('endMarkUserAttendance Error : $e');
      throw "Something went Wrong : $e";
    }
  }

  //------------------------Menu Data Api---------------------//
  Future<Map<String, dynamic>> getMobileMenuData(Map body) async {
    var endPoint = "get-mobile-menu";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint(
          "getMobileMenuData Body Data : $body -- Response : $res");
      return res;
    } catch (e) {
      Logger.dataPrint('getMobileMenuData Error : $e');
      throw "Something went Wrong : $e";
    }
  }

  //------------------------Feedback Question Data---------------------//
  Future<Map<String, dynamic>> getDataOfFeedBack() async {
    var endPoint = "feedback-questions";

    try {
      final res = await ApiWrapper.get(endPoint);
      Logger.dataPrint('getDataOfFeedBack Response : $res');
      return res;
    } catch (e) {
      Logger.dataPrint('getDataOfFeedBack Error : $e');
      throw "Something went Wrong : $e";
    }
  }

  //----------Attendance Data Fetch get-attendance-data--------------//
  Future<Map<String, dynamic>> getUserAttendanceDetails(Map body) async {
    var endPoint = "get-attendance-data";

    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint(
          "getUserAttendanceDetails body Data : $body --Response : $res");
      return res;
    } catch (e) {
      Logger.dataPrint('uploadFeedbackData Error: $e');
      throw "Something Went Wrong $e";
    }
  }

  //----------------Order-History API----------------//
  Future<Map<String, dynamic>> getOrderHistoryData(Map body) async {
    var endPoint = "orders-history";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      // log("getOrderHistoryData body Data : $body --Response : $res");
      return res;
    } catch (e) {
      Logger.dataPrint('getOrderHistoryData Error: $e');
      throw "getOrderHistoryData Something Went Wrong $e";
    }
  }

  //------------------Order Item History-----------------//
  Future<Map<String, dynamic>> getItemHistoryData(Map body) async {
    var endPoint = "item-history";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint(
          "getItemHistoryData body Data : $body --Response : $res");
      return res;
    } catch (e) {
      Logger.dataPrint('getItemHistoryData Error: $e');
      throw "getItemHistoryData Something Went Wrong $e";
    }
  }

  //----------------Purchase-History API----------------//
  Future<Map<String, dynamic>> getPurchaseHistoryData(Map body) async {
    var endPoint = "savePurchaseHistory";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint(
          "getPurchaseHistoryData body Data : $body --Response : $res");
      return res;
    } catch (e) {
      Logger.dataPrint('getPurchaseHistoryData Error: $e');
      throw "getPurchaseHistoryData Something Went Wrong $e";
    }
  }

  //----------------Mall List API----------------//
  Future<Map<String, dynamic>> getMallListData() async {
    var endPoint = "mall-list";
    try {
      final res = await ApiWrapper.get(endPoint);
      Logger.dataPrint("getMallListData body Data Response : $res");
      return res;
    } catch (e) {
      Logger.dataPrint('getMallListData Error: $e');
      throw "getMallListData Something Went Wrong $e";
    }
  }

  //----------------Purchase Count API----------------//
  Future<Map> getPurchaseCount(Map body) async {
    var endPoint = "purchase-count";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint("getPurchaseCount body Data : $body --Response : $res");
      return res;
    } catch (e) {
      Logger.dataPrint('getPurchaseCount Error: $e');
      throw "getPurchaseCount Something Went Wrong $e";
    }
  }

  //----------------Store List API----------------//
  Future<Map<String, dynamic>> getStoreListData(Map body) async {
    var endPoint = "store-list";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint("getStoreListData body Data : $body --Response : $res");
      return res;
    } catch (e) {
      throw "getStoreListData Something Went Wrong $e";
    }
  }

  //----------------Sub-Category List API----------------//
  Future<Map<String, dynamic>> getSubCategoryListData(Map body) async {
    var endPoint = "sub-category-list";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint(
          "getSubCategoryListData body Data : $body --Response : $res");
      return res;
    } catch (e) {
      throw "getSubCategoryListData Something Went Wrong $e";
    }
  }

  //----------------Category List API----------------//
  Future<Map<String, dynamic>> getCategoryListData() async {
    var endPoint = "category-list";
    try {
      final res = await ApiWrapper.get(endPoint);
      Logger.dataPrint("getCategoryListData Response : $res");
      return res;
    } catch (e) {
      throw "getCategoryListData Something Went Wrong $e";
    }
  }

  //----------------Category List API----------------//
  Future<Map<String, dynamic>> getProductListData(Map body) async {
    var endPoint = "product-list";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint("getProductListData Response : $res");
      return res;
    } catch (e) {
      throw "getProductListData Something Went Wrong $e";
    }
  }

  //----------------Final Order Of Product API----------------//
  // Future<Map<String, dynamic>> finalUploadOrder(Map body) async {
  //   var endPoint = "redeem-product";
  //   try {
  //     final res = await ApiWrapper.post(endPoint, body);
  //     Logger.dataPrint(
  //         "finalUploadOrder Body Data : $body --- Response : $res");
  //     return res;
  //   } catch (e) {
  //     throw "finalUploadOrder Something Went Wrong $e";
  //   }
  // }

  //----------------Final Order Of Product API----------------//
  Future<Map<String, dynamic>> getAddProductInCart(Map body) async {
    var endPoint = "add-to-cart";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint(
          "getAddProductInCart Body Data : $body --- Response : $res");
      return res;
    } catch (e) {
      throw "getAddProductInCart Something Went Wrong $e";
    }
  }

  //----------------Product Add to Cart API----------------//
  Future<Map<String, dynamic>> getAllProductDataForCart(Map body) async {
    var endPoint = "get-cart-product";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint("getAddProductInCart Response : $res");
      return res;
    } catch (e) {
      throw "getAddProductInCart Something Went Wrong $e";
    }
  }

  //----------------Delete Product from Cart API----------------//
  Future<Map<String, dynamic>> getDeleteProductFromCart(Map body) async {
    var endPoint = "remove-cart-product";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint("getDeleteProductFromCart Response : $res");
      return res;
    } catch (e) {
      throw "getDeleteProductFromCart Something Went Wrong $e";
    }
  }

  //----------------New Product Order API----------------//
  Future<Map<String, dynamic>> getNewOrderProductData(Map body) async {
    var endPoint = "get-ordered-product";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      Logger.dataPrint("getNewOrderProductData Response : $res");
      return res;
    } catch (e) {
      throw "getNewOrderProductData Something Went Wrong $e";
    }
  }
}
