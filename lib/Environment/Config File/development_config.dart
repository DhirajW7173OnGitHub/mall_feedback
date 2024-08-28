import 'package:mall_app/Environment/Config%20File/base_config.dart';

class DevelopmentConfiguration implements BaseConfig {
  @override
  String get apiHost => 'https://malldashboard.onintouch.com/api';

  @override
  String get domainHost => '';

  @override
  String get localDb => '';

  @override
  String get lastSyncId => "";
}
