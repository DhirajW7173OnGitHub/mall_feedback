import 'package:mall_app/Environment/Config%20File/base_config.dart';
import 'package:mall_app/Environment/Config%20File/development_config.dart';
import 'package:mall_app/Environment/Config%20File/production_config.dart';
import 'package:mall_app/Environment/Config%20File/stagging_config.dart';
import 'package:mall_app/Environment/base_data.dart';

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String DEV = 'DEV';
  static const String STAGING = 'STAGING';
  static const String PROD = 'PROD';

  BaseConfig? config;

  void initConfig(String environment) {
    config = _getConfig(environment);
    _mapToPreviousEnvs();
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.PROD:
        return ProductionConfiguration();
      case Environment.STAGING:
        return StagingConfiguration();
      default:
        return DevelopmentConfiguration();
    }
  }

  void _mapToPreviousEnvs() {
    baseUrl = config!.apiHost;
    domain = config!.domainHost;
    dbName = config!.localDb;
    lastSyncId = config!.lastSyncId;
  }
}
