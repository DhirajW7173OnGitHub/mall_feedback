import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mall_app/Api_caller/api_caller.dart';
import 'package:mall_app/Attendance%20/Model/attendance_details_model.dart';
import 'package:mall_app/Model/login_user_model.dart';
import 'package:mall_app/Model/mall_list_model.dart';
import 'package:mall_app/Model/mobile_menu_model.dart';
import 'package:mall_app/Purchase/Purchase_Model/cart_screen_mode.dart';
import 'package:mall_app/Purchase/Purchase_Model/category_list_model.dart';
import 'package:mall_app/Purchase/Purchase_Model/new_order_list_model.dart';
import 'package:mall_app/Purchase/Purchase_Model/order_history_model.dart';
import 'package:mall_app/Purchase/Purchase_Model/order_item_history_model.dart';
import 'package:mall_app/Purchase/Purchase_Model/product_list_model.dart';
import 'package:mall_app/Purchase/Purchase_Model/store_list_model.dart';
import 'package:mall_app/Purchase/Purchase_Model/subcategory_model.dart';
import 'package:mall_app/Utils/common_log.dart';
import 'package:mall_app/Utils/global_utils.dart';
import 'package:mall_app/feedback/Model/feedback_model.dart';
import 'package:rxdart/rxdart.dart';

class GlobalBloc {
  final _apiCaller = ApiCaller();

  //------------User Sign Up------------//
  Future<Map> doUserSignUp({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? password,
    String? confirmedPass,
  }) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "email": email,
      "password": password,
      "password_confirmation": confirmedPass,
    };

    try {
      var res = await _apiCaller.userSignUpWithData(bodyData);
      Logger.dataLog("doUserSignUp Body Data : $bodyData---> RESPONSE: $res ");
      EasyLoading.dismiss();
      return res;
    } catch (e) {
      Logger.dataLog("doUserSignUp Error : $e");
      throw "Something went wrong in doUserSignUp: $e";
    }
  }

  //--------------------User Login--------------------//
  BehaviorSubject<LoginUserDataModel> get getLoginUserData => _verifyUser;
  final BehaviorSubject<LoginUserDataModel> _verifyUser =
      BehaviorSubject<LoginUserDataModel>();

  Future<LoginUserDataModel> doUserLoginAndFetchUserData({
    String? phone,
    String? pass,
    String? userType,
  }) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {
      "phone": phone,
      "password": pass,
      "usertype": userType,
    };
    try {
      var res = await _apiCaller.userLogincall(bodyData);
      Logger.dataLog("doUserLogin Body Data : $bodyData---> RESPONSE: $res ");
      var data = LoginUserDataModel.fromJson(res);
      _verifyUser.add(data);
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      Logger.dataLog("doUserLoginAndFetchUserData Error : $e");
      throw "Something went wrong in doUserLogin: $e";
    }
  }

  //--------------------Mobile MenuApi------------------//
  BehaviorSubject<MobileMenuModel> get getMobileMenu => _liveMobileMenuData;
  final BehaviorSubject<MobileMenuModel> _liveMobileMenuData =
      BehaviorSubject<MobileMenuModel>();

  Future<MobileMenuModel> doFetchMobileMenu(
      {String? userId, String? usertype}) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {
      "user_id": userId,
      "usertype": usertype,
    };

    try {
      Map<String, dynamic> res = await _apiCaller.getMobileMenuData(bodyData);
      Logger.dataLog(
          'doFetchMobileMenu bodyData : $bodyData --Response : $res');
      var data = MobileMenuModel.fromJson(res);
      _liveMobileMenuData.add(data);
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      Logger.dataLog("doFetchMobileMenu Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //------------Mark USer Attedance------------------//
  Future<Map> doMarkUserAttendance({
    String? userId,
    String? todayDate,
    String? startTime,
    String? lat,
    String? long,
    String? present,
  }) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {
      "user_id": userId,
      "date": todayDate,
      "start_time": startTime,
      "latitudes": lat,
      "longitude": long,
      "present": present,
    };
    try {
      var res = await _apiCaller.markUserAttendance(bodyData);
      Logger.dataLog(
          "doMarkUserAttendance Body Data : $bodyData --Response : $res");
      globalUtils.showSnackBar(res['message']);
      EasyLoading.dismiss();
      return res;
    } catch (e) {
      Logger.dataLog("doMarkUserAttendance Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //----------------End Marked Attendance----------------//
  Future<Map> doUnMarkUserAttendance({
    String? userId,
    String? date,
    String? endTime,
    String? lat,
    String? long,
  }) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {
      "user_id": userId,
      "date": date,
      "end_time": endTime,
      "latitudes": lat,
      "longitude": long
    };

    try {
      var res = await _apiCaller.endMarkUserAttendance(bodyData);
      Logger.dataLog(
          "doUnMarkUserAttendance Body Data : $bodyData --Response : $res");
      EasyLoading.dismiss();
      return res;
    } catch (e) {
      Logger.dataLog("doUnMarkUserAttendance Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //---------------feedBack Question Data---------------//
  BehaviorSubject<FeedbackModel> get getFeedbackQueData => _liveFeedbackQueData;
  final BehaviorSubject<FeedbackModel> _liveFeedbackQueData =
      BehaviorSubject<FeedbackModel>();

  Future<FeedbackModel> doFetchFeedBackQueData() async {
    EasyLoading.show(dismissOnTap: false);
    try {
      Map<String, dynamic> res = await _apiCaller.getDataOfFeedBack();
      Logger.dataLog('doFetchFeedBackQueData Response : $res');
      var data = FeedbackModel.fromJson(res);
      _liveFeedbackQueData.add(data);
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      Logger.dataLog("doFetchFeedBackQueData Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //----------------------Fetch Attendance Detail------------------//
  BehaviorSubject<AttendanceDataModel> get getAttendanceData =>
      _liveAttendanceData;
  final BehaviorSubject<AttendanceDataModel> _liveAttendanceData =
      BehaviorSubject<AttendanceDataModel>();

  Future<AttendanceDataModel> doFetchAttendanceDetailsData(
      {String? userId, String? date}) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {
      "user_id": userId,
      "date": date,
    };
    try {
      Map<String, dynamic> res =
          await _apiCaller.getUserAttendanceDetails(bodyData);
      Logger.dataLog(
          'doFetchAttendanceDetailsData Body Data : $bodyData -- Response : $res');
      var data = AttendanceDataModel.fromJson(res);
      _liveAttendanceData.add(data);
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      Logger.dataLog("doFetchAttendanceDetailsData Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //--------------------Item History Data-----------------//
  BehaviorSubject<OrderHistoryModel> get getOrderHistory => _liveOrderHistory;
  final BehaviorSubject<OrderHistoryModel> _liveOrderHistory =
      BehaviorSubject<OrderHistoryModel>();

  Future<OrderHistoryModel> doFetchOrderHistoryData(
      {String? phone, String? mallId, String? storeId}) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {
      "phone": phone,
      "mall_id": mallId,
      "storeid": storeId ?? "0",
    };

    try {
      Map<String, dynamic> res = await _apiCaller.getOrderHistoryData(bodyData);
      Logger.dataLog(
          "doFetchOrderHistoryData BodyData : $bodyData ---Response : $res");
      var data = OrderHistoryModel.fromJson(res);
      _liveOrderHistory.add(data);
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      EasyLoading.dismiss();
      Logger.dataLog("doFetchOrderHistoryData Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //--------------------Order History Data-----------------//
  BehaviorSubject<OrderItemHistoryModel> get getItemHistory => _liveItemHistory;
  final BehaviorSubject<OrderItemHistoryModel> _liveItemHistory =
      BehaviorSubject<OrderItemHistoryModel>();

  Future<OrderItemHistoryModel> doFetchItemHistoryData(
      {String? orderId}) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {"orderid": orderId};

    try {
      Map<String, dynamic> res = await _apiCaller.getItemHistoryData(bodyData);
      Logger.dataLog(
          "doFetchItemHistoryData BodyData : $bodyData ---Response : $res");
      var data = OrderItemHistoryModel.fromJson(res);
      _liveItemHistory.add(data);
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      EasyLoading.dismiss();
      Logger.dataLog("doFetchItemHistoryData Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //-----------------Purchase History ----------------//
  BehaviorSubject<Map> get getPurchseHistory => _livePurchaseHistory;
  final BehaviorSubject<Map> _livePurchaseHistory = BehaviorSubject<Map>();

  Future<Map> doFetchPurchaseHistoryData(
      {String? phone, String? mallId}) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {
      "phone": phone,
      "mall_id": mallId,
    };

    try {
      Map<String, dynamic> res =
          await _apiCaller.getPurchaseHistoryData(bodyData);
      Logger.dataLog(
          "doFetchPurchaseHistoryData BodyData : $bodyData ---Response : $res");

      _livePurchaseHistory.add(res);
      EasyLoading.dismiss();
      return res;
    } catch (e) {
      EasyLoading.dismiss();
      Logger.dataLog("doFetchPurchaseHistoryData Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //-----------------Mall List Data ----------------//
  BehaviorSubject<MallListModel> get getMallListData => _liveMallListData;
  final BehaviorSubject<MallListModel> _liveMallListData =
      BehaviorSubject<MallListModel>();

  Future<MallListModel> doFetchMallListData() async {
    EasyLoading.show(dismissOnTap: false);

    try {
      Map<String, dynamic> res = await _apiCaller.getMallListData();
      Logger.dataLog("doFetchMallListData BodyData Response : $res");
      var data = MallListModel.fromJson(res);

      _liveMallListData.add(data);
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      Logger.dataLog("doFetchMallListData Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //-----------------Purchase Count According Mall----------------//
  Future<Map> doFetchPurchaseCountData({String? phone, String? mallKey}) async {
    EasyLoading.show(dismissOnTap: false);

    Map bodyData = {"mall_key": mallKey, "phone": phone};

    try {
      var res = await _apiCaller.getPurchaseCount(bodyData);
      Logger.dataLog(
          "doFetchPurchaseCountData BodyData : $bodyData Response : $res");

      EasyLoading.dismiss();
      return res;
    } catch (e) {
      Logger.dataLog("doFetchPurchaseCountData Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //-----------------Get Store List Data------------------//
  BehaviorSubject<StoreListModel> get getStoreList => _liveStoreList;
  final BehaviorSubject<StoreListModel> _liveStoreList =
      BehaviorSubject<StoreListModel>();

  Future<StoreListModel> doFetchStoreListData(String mallId) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {"mall_id": mallId};
    try {
      Map<String, dynamic> res = await _apiCaller.getStoreListData(bodyData);
      Logger.dataLog("getStoreListData BodyData : $bodyData --Response : $res");
      var data = StoreListModel.fromJson(res);
      _liveStoreList.add(data);
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      Logger.dataLog("doFetchStoreListData Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //-----------------Category List Data------------------//
  BehaviorSubject<CategoryListModel> get getCategoryList => _liveCategoryList;
  final BehaviorSubject<CategoryListModel> _liveCategoryList =
      BehaviorSubject<CategoryListModel>();

  Future<CategoryListModel> doFetchCategoryListData() async {
    EasyLoading.show(dismissOnTap: false);

    try {
      Map<String, dynamic> res = await _apiCaller.getCategoryListData();
      Logger.dataLog("doFetchCategoryListData Response : $res");
      var data = CategoryListModel.fromJson(res);
      _liveCategoryList.add(data);
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      Logger.dataLog("doFetchStoreListData Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //-----------------Sub-Category List Data------------------//
  BehaviorSubject<SubCategoryListModel> get getSubCategoryList =>
      _liveSubCategoryList;
  final BehaviorSubject<SubCategoryListModel> _liveSubCategoryList =
      BehaviorSubject<SubCategoryListModel>();

  Future<SubCategoryListModel> doFetchSubCategoryListData(
      String categoryId) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {"category_id": categoryId};
    try {
      Map<String, dynamic> res =
          await _apiCaller.getSubCategoryListData(bodyData);
      Logger.dataLog(
          "doFetchSubCategoryListData BodyData: $bodyData Response : $res");
      var data = SubCategoryListModel.fromJson(res);
      _liveSubCategoryList.add(data);
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      Logger.dataLog("doFetchSubCategoryListData Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //-----------------Product List Data------------------//
  BehaviorSubject<ProductListModel> get getProductList => _liveProductList;
  final BehaviorSubject<ProductListModel> _liveProductList =
      BehaviorSubject<ProductListModel>();

  Future<ProductListModel> doFetchProductListData(
      {String? categoryId, String? subCategoryId}) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {
      "category_id": categoryId,
      "sub_category_id": subCategoryId
    };
    try {
      Map<String, dynamic> res = await _apiCaller.getProductListData(bodyData);
      Logger.dataLog(
          "doFetchProductListData BodyData: $bodyData Response : res");
      var data = ProductListModel.fromJson(res);
      _liveProductList.add(data);
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      Logger.dataLog("doFetchProductListData Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //-----------------Product Add In Cart Data------------------//
  Future<Map> doAddProductDataInCart({
    String? userId,
    String? mallId,
    String? productId,
    String? productQty,
    String? usedPoint,
  }) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {
      "customer_id": userId,
      "mall_id": mallId,
      "product_id": productId,
      "product_quantity": productQty,
      "used_points": usedPoint,
    };
    try {
      Map<String, dynamic> res = await _apiCaller.addProductInCart(bodyData);
      Logger.dataLog(
          "doAddProductDataInCart BodyData: $bodyData Response : $res");
      EasyLoading.dismiss();
      return res;
    } catch (e) {
      EasyLoading.dismiss();
      Logger.dataLog("doAddProductDataInCart Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //-----------------Fetch Product of Cart Data------------------//
  BehaviorSubject<CartProductListModel> get getCartProductList =>
      _liveCartProductList;
  final BehaviorSubject<CartProductListModel> _liveCartProductList =
      BehaviorSubject<CartProductListModel>();

  Future<CartProductListModel> doFetchAllcartProductData({
    String? userId,
    String? mallId,
  }) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {"customer_id": userId, "mall_id": mallId};
    try {
      Map<String, dynamic> res =
          await _apiCaller.getAllProductDataForCart(bodyData);
      Logger.dataLog(
          "doFetchAllcartProductData BodyData: $bodyData Response : $res");
      var data = CartProductListModel.fromJson(res);
      _liveCartProductList.add(data);
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      Logger.dataLog("doFetchAllcartProductData Error : $e");
      throw "Something Went Wrong : $e";
    }
  }

  //-----------------Product Add In Cart Data------------------//
  Future<Map> doDeleteProductFromCart({
    String? userId,
    String? mallId,
    String? productId,
    String? cartId,
  }) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {
      "customer_id": userId,
      "mall_id": mallId,
      "product_id": productId,
      "cart_id": cartId
    };
    try {
      Map<String, dynamic> res =
          await _apiCaller.getDeleteProductFromCart(bodyData);
      Logger.dataLog(
          "doDeleteProductFromCart BodyData: $bodyData Response : $res");
      EasyLoading.dismiss();
      return res;
    } catch (e) {
      EasyLoading.dismiss();
      Logger.dataLog("doDeleteProductFromCart Error : $e");
      throw "Something Went Wrong : $e";
    }
  }
  //getNewOrderProductData

  //-----------------Fetch New order Product Data------------------//
  BehaviorSubject<NewProductOrderListModel> get getNewOrderProductList =>
      _liveNewOrderProductList;
  final BehaviorSubject<NewProductOrderListModel> _liveNewOrderProductList =
      BehaviorSubject<NewProductOrderListModel>();

  Future<NewProductOrderListModel> doFetchNewOrderProductData({
    String? userId,
    String? mallId,
  }) async {
    EasyLoading.show(dismissOnTap: false);
    Map bodyData = {"customer_id": userId, "mall_id": mallId};
    try {
      Map<String, dynamic> res =
          await _apiCaller.getNewOrderProductData(bodyData);
      Logger.dataLog(
          "doFetchNewOrderProductData BodyData: $bodyData Response : $res");
      var data = NewProductOrderListModel.fromJson(res);
      _liveNewOrderProductList.add(data);
      EasyLoading.dismiss();
      return data;
    } catch (e) {
      Logger.dataLog("doFetchNewOrderProductData Error : $e");
      throw "Something Went Wrong : $e";
    }
  }
}

GlobalBloc globalBloc = GlobalBloc();
