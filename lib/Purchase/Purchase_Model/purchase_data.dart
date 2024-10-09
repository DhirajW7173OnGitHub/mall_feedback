import 'package:mall_app/Purchase/Purchase_Model/product_list_model.dart';

class PurchaseData {
  PurchaseData({
    this.totalInvoiceAmount,
    this.availablePoint,
    this.totalLoyaltyPoint,
    this.productDatum,
  });

  String? totalInvoiceAmount;
  String? availablePoint;
  String? totalLoyaltyPoint;
  ProductDatum? productDatum;
}
