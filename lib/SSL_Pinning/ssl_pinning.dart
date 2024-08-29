import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:mall_app/Environment/environment.dart';

Future<SecurityContext> get globalContext async {
  const String environment = String.fromEnvironment(
    "ENVIRONMENT",
    defaultValue: Environment.DEV,
  );
  final sslCert;
  if (environment == "DEV") {
    log('DEVELOPMENT SERVER RUN');
    sslCert = await rootBundle.load('assets/certificate_dev.pem');
  } else if (environment == "PROD") {
    log('PRODUCTION SERVER RUN');
    sslCert = await rootBundle.load('assets/certificate_prod.pem');
  } else {
    log('DEVELOPMENT SERVER RUN');
    sslCert = await rootBundle.load('assets/certificate_dev.pem');
  }
  SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());

  return securityContext;
}

//Get SSL Pinning Certificate
Future<http.Client> getSSLPinningClient() async {
  HttpClient client = HttpClient(context: await globalContext);

  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => false;

  IOClient ioClient = IOClient(client);

  return ioClient;
}
