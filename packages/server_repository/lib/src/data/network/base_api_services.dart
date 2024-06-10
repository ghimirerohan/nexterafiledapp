

import 'package:idempiere_rest/idempiere_rest.dart';

abstract class BaseApiServices {

  Future<dynamic> getRecordApiResponse( int id );

  Future<dynamic> getDataApiResponse({FilterBuilder? filter , List<String>? select});

  Future<dynamic> getPostApiResponse(dynamic data);

  Future<dynamic> getPutApiResponse(dynamic data);

  Future<bool> authenticate({required String username, required String password,
    required int clientId, required int roleId, required String lang});

}