


import 'package:server_repository/api_response.dart';
import 'package:server_repository/src/models/custom_models/NEQRToleAdd.dart';

import '../../../models.dart';
import '../../data/network/network_api_services.dart';

class QRToleAdd_Api {

  final NetworkApiService _networkApiService = NetworkApiService<NEQRToleAdd>();

  Future<NEQRToleAdd> getQRToleAddData(int id) async{
    ApiResponse<NEQRToleAdd> response = await _networkApiService.getRecordApiResponse(id);
    if(response.data != null){
      return response.data!;
    }else{
      throw("Qr Error / No data");
    }
  }

}