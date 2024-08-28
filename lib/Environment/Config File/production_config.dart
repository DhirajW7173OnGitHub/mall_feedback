import 'package:mall_app/Environment/Config%20File/base_config.dart';

class ProductionConfiguration implements BaseConfig {
  @override
  String get apiHost => '';

  @override
  String get domainHost => '';

  @override
  String get localDb => 'econnect_production.db';

  @override
  String get lastSyncId => "238080"; //"299408"; //"298865"; //'33582';
}
