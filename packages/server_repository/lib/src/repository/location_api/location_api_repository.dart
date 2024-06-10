
import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:server_repository/src/data/response/api_response.dart';
import 'package:server_repository/src/models/generic_models/CLocation.dart';
import 'package:server_repository/src/repository/location_api/location_repository.dart';

import '../../data/network/base_api_services.dart';
import '../../data/network/network_api_services.dart';

class LocationApiRepository implements LocationRepository{
  final BaseApiServices _apiServices = NetworkApiService<CLocation>() ;

  @override
  Future<ApiResponse<CLocation>> getLocation(String gpcode) async {
    ///Replacing '+' in string as java backend becomes black and need to be replaced with '%2B'
    if(gpcode.contains('+')){
      gpcode = gpcode.replaceAll('+', '%2B');
    }
    FilterBuilder filter = FilterBuilder()
        .addFilter("Address5", Operators.eq, gpcode);
    ApiResponse<List<CLocation>> queryResult = await _apiServices.getDataApiResponse(filter:  filter,
        select: ['Address5','City']);
    if(queryResult.data!.isEmpty){
      throw("No Location Code In DataBase");
    }
    ApiResponse<CLocation> returnLocation = ApiResponse<CLocation>.completed(queryResult.data?[0]);
    return returnLocation;
  }

  @override
  Future<ApiResponse<CLocation>> updateLocation(CLocation data) async{
    return await _apiServices.getPutApiResponse(data);
  }

  Future<CLocation> getLocationByID(int ID) async{

    ApiResponse<CLocation> response =  await _apiServices.getRecordApiResponse(ID);
    if(response.data == null){
      throw("Some Thing Wrong to get CLocation");
    }
    return response.data!;
  }

}