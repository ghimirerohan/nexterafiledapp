
import 'dart:convert';

import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:server_repository/src/data/network/network_api_services.dart';
import 'package:server_repository/src/data/response/api_response.dart';
import 'package:server_repository/src/models/generic_models/CBpartner.dart';
import 'package:server_repository/src/repository/customer_api/customer_repository.dart';

class CustomerApiRepository implements CustomerRepository{
  final NetworkApiService _networkApiService = NetworkApiService<CBpartner>();
  @override
  Future<ApiResponse<List<CBpartner>>?> getCustomer(int c_location_id) async{
    FilterBuilder filter = FilterBuilder()
        .addFilter("C_Location_ID", Operators.eq, c_location_id);
    ApiResponse<List<CBpartner>>? queryResult = await _networkApiService.
    getDataApiResponse( filter: filter,
        select: ['Name' , 'Value', 'Name2','C_Location_ID','C_BP_Group_ID','ward','Price' ,'house_storey_number',
          'DocStatus' , 'To_Period_ID' ,'C_Period_ID', 'TaxID' , 'ne_businessno' ]);
    return queryResult;
  }

  @override
  Future<ApiResponse<CBpartner>> postCustomer(CBpartner data) async{
    ApiResponse<CBpartner> reponse = await _networkApiService.getPostApiResponse(data);
    return reponse;
  }

  Future<CBpartner?> getCustomerByID(int id) async{
    ApiResponse<CBpartner> reponse = await _networkApiService.getRecordApiResponse(id);
    return reponse.data;
  }

  Future<CBpartner?> putCustomer(CBpartner model) async{
    ApiResponse<CBpartner?> reponse = await _networkApiService.getPutApiResponse(model);
    return reponse.data;
  }


  @override
  Future<ApiResponse<CBpartner?>> getCustomerFromValue(String value) async{

    FilterBuilder filter = FilterBuilder()
        .addFilter("Value", Operators.eq, value);
    ApiResponse<List<CBpartner>>? queryResult = await _networkApiService.
    getDataApiResponse( filter: filter,
        select: ['Name' , 'Value', 'Name2','C_Location_ID','C_BP_Group_ID','ward','Price' ,
          'DocStatus' , 'To_Period_ID' ,'C_Period_ID' ]);

    return ApiResponse.completed(queryResult?.data?.first);
  }

}