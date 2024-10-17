

import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:server_repository/src/data/response/api_response.dart';
import 'package:server_repository/src/models/generic_models/CPeriod.dart';
import 'package:server_repository/src/repository/cperiod_api/cperiod_repository.dart';
import 'package:intl/intl.dart';

import '../../data/network/base_api_services.dart';
import '../../data/network/network_api_services.dart';

class CPeriodApiRepository implements CPeriodRepository{

  final BaseApiServices _apiServices = NetworkApiService<CPeriod>() ;

  @override
  Future<ApiResponse<List<CPeriod>>> getCurrentPeriod() async{
    final DateTime now = DateTime.now();
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final formattedDate = dateFormatter.format(now);

    FilterBuilder filterBuilder = FilterBuilder().
        addFilter("AD_Client_ID", Operators.eq, 1000000)
    .and().addFilter("StartDate", Operators.le, formattedDate)
    .and().addFilter("EndDate", Operators.ge, formattedDate);
    ApiResponse<List<CPeriod>> queryResult = await _apiServices.
    getDataApiResponse(
      filter: filterBuilder,
        select: ['Name']);
    return queryResult;
  }

  @override
  Future<ApiResponse<List<CPeriod>>> getPeriodsGreaterThanLastPeriod(int c_period_id) async{
    FilterBuilder filterBuilder = FilterBuilder().
    addFilter("AD_Client_ID", Operators.eq, 1000000)
        .and().addFilter("C_Period_ID", Operators.ge, c_period_id);

    ApiResponse<List<CPeriod>> queryResult = await _apiServices.
    getDataApiResponse(
        filter: filterBuilder,
        select: ['Name']);
    return queryResult;
  }

  Future<ApiResponse<List<CPeriod>>> getAllInitialsPeriods() async{
    FilterBuilder filterBuilder = FilterBuilder().
    addFilter("AD_Client_ID", Operators.eq, 1000000)
        .and().addFilter("C_Period_ID", Operators.ge, 1000000);

    ApiResponse<List<CPeriod>> queryResult = await _apiServices.
    getDataApiResponse(
        filter: filterBuilder,
        select: ['Name']);
    return queryResult;
  }
  
  
}