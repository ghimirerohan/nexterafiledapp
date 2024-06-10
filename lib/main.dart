import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:idempiere_rest/idempiere_rest.dart';

import 'app.dart';
import 'constants/ApiConstants.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async{
  HttpOverrides.global = MyHttpOverrides();
  await IdempiereClient().setBaseUrl(ApiConstants.baseUrl);
  runApp(const App());
}