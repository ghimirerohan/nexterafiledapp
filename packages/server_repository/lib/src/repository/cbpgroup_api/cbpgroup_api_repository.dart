
import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:server_repository/src/data/response/api_response.dart';
import 'package:server_repository/src/models/generic_models/CBPGroup.dart';
import 'package:server_repository/src/repository/cbpgroup_api/cbpgroup_repoistory.dart';

import '../../data/network/base_api_services.dart';
import '../../data/network/network_api_services.dart';

class CBPGroupApiRepostory implements CBPGroupRepository{
  final BaseApiServices _apiServices = NetworkApiService<CBPGroup>() ;


  @override
  Future<ApiResponse<List<CBPGroup>>> getCBPGroups() async{
    FilterBuilder filterBuilder = FilterBuilder();
    filterBuilder.addFilter("isActive", Operators.eq, true);
    ApiResponse<List<CBPGroup>> queryResult = await _apiServices.
    getDataApiResponse(
        select: ['Name','isStoryBased' , 'Value']  ,orderBy: ['Value'] , filter: filterBuilder);
    return queryResult;
  }

}