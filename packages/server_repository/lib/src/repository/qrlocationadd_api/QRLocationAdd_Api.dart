
import 'package:server_repository/api_response.dart';

import '../../../models.dart';
import '../../data/network/network_api_services.dart';

class QRLocationAdd_Api {

  final NetworkApiService _networkApiService = NetworkApiService<NEQrLocationAdd>();

  Future<NEQrLocationAdd> getQRLocationAddData(int id) async{
    ApiResponse<NEQrLocationAdd> response = await _networkApiService.getRecordApiResponse(id);
    if(response.data != null){
      return response.data!;
    }else{
      throw("Qr Error / No data");
    }
  }

}