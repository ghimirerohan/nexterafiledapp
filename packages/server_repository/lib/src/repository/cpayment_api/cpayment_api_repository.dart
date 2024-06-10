

import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:server_repository/src/data/response/api_response.dart';
import 'package:server_repository/src/models/generic_models/CPayment.dart';
import 'package:server_repository/src/repository/cpayment_api/cpayment_repository.dart';
import 'package:intl/intl.dart';

import '../../data/network/network_api_services.dart';

class CPaymentApiRepository implements CPaymentRepository{

  final NetworkApiService _networkApiService = NetworkApiService<CPayment>();

  @override
  Future<ApiResponse<List<CPayment>>> getPaymentsOfCustomer(int c_bpartner_id)  async{
    FilterBuilder filter = FilterBuilder()
        .addFilter("C_BPartner_ID", Operators.eq, c_bpartner_id);
    ApiResponse<List<CPayment>> queryResult = await _networkApiService.
    getDataApiResponse( filter: filter,
        select: ['C_BPartner_ID' , 'From_Period_ID', 'To_Period_ID','DateTrx','PayAmt','DocStatus' , 'SalesRep_ID']);
    return queryResult;
  }

  @override
  Future<ApiResponse<List<CPayment>>> getPaymentsfromCollectors(int ad_user_id) async{
    FilterBuilder filter = FilterBuilder()
        .addFilter("SalesRep_ID", Operators.eq, ad_user_id);
    ApiResponse<List<CPayment>> queryResult = await _networkApiService.
    getDataApiResponse( filter: filter,
        select: ['C_BPartner_ID' , 'From_Period_ID', 'To_Period_ID','DateTrx','PayAmt','DocStatus' , 'SalesRep_ID']);
    return queryResult;
  }

  @override
  Future<ApiResponse<List<CPayment>>> getTodayPaymentsfromCollectors(int ad_user_id) async{
    final DateTime now = DateTime.now();
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final formattedDate = dateFormatter.format(now);
    FilterBuilder filter = FilterBuilder()
        .addFilter("SalesRep_ID", Operators.eq, ad_user_id)
        .and().addFilter("DateTrx", Operators.ge, formattedDate);
    ApiResponse<List<CPayment>> queryResult = await _networkApiService.
    getDataApiResponse( filter: filter,
        select: ['C_BPartner_ID' , 'From_Period_ID', 'To_Period_ID','DateTrx','PayAmt','DocStatus' , 'SalesRep_ID']);
    return queryResult;
  }

  @override
  Future<ApiResponse<CPayment>> postPayment(CPayment data) async{
    final DateTime now = DateTime.now();
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final formattedDate = dateFormatter.format(now);
    ApiResponse<CPayment> reponse = await _networkApiService.getPostApiResponse(data);
    return reponse;
  }

}