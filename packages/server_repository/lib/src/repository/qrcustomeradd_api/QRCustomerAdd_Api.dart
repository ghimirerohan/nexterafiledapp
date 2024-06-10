
import 'package:server_repository/models.dart';

import '../../../api_response.dart';
import '../../data/network/network_api_services.dart';

class QRCustomerAddApi{
  final NetworkApiService _networkApiService = NetworkApiService<NEQrCustomerAdd>();

  Future<NEQrCustomerAdd> getQRCustomerAddData(int id) async{
    ApiResponse<NEQrCustomerAdd> response = await _networkApiService.getRecordApiResponse(id);
    if(response.data != null){
      return response.data!;
    }else{
      throw("Qr Error / No data");
    }
  }

}