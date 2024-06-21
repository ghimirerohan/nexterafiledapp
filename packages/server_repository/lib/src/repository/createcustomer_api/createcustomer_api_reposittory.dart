

import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:server_repository/src/data/response/api_response.dart';
import 'package:server_repository/src/models/custom_models/NECreateCustomer.dart';
import 'package:server_repository/src/repository/createcustomer_api/createcustomer_repository.dart';
import '../../data/network/network_api_services.dart';
import 'package:intl/intl.dart';


class CreateCustomerApiRepository implements CreateCustomerRepository{

  final NetworkApiService _networkApiService = NetworkApiService<NECreateCustomer>();
  @override
  Future<ApiResponse<List<NECreateCustomer>>> getCreateCustomer(int c_bpartner_id) async{
    FilterBuilder filter = FilterBuilder()
        .addFilter("C_BPartner_ID", Operators.eq, c_bpartner_id);
    ApiResponse<List<NECreateCustomer>> queryResult = await _networkApiService.
    getDataApiResponse( filter: filter,
        select: ['Name' , 'Value', 'Name2','C_Location_ID','C_BP_Group_ID']);
    return queryResult;
  }

  Future<List<NECreateCustomer>?> getNoOfCreateCustomerByCollector({required int ad_user_id}) async{
    final DateTime now = DateTime.now();
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final formattedDate = dateFormatter.format(now);
    FilterBuilder filter = FilterBuilder()
        .addFilter("CreatedBy", Operators.eq, ad_user_id)
        .and().addFilter("Created", Operators.ge, formattedDate);
    ApiResponse<List<NECreateCustomer>> queryResult = await _networkApiService.
    getDataApiResponse( filter: filter,
        select: ['Name' , 'Value', 'Name2','C_Location_ID','C_BP_Group_ID',]);
    return queryResult.data;
  }
  @override
  Future<ApiResponse<NECreateCustomer>> postCreateCustomer(NECreateCustomer data) async{
    ApiResponse<NECreateCustomer> reponse = await _networkApiService.getPostApiResponse(data);
    return reponse;
  }

}