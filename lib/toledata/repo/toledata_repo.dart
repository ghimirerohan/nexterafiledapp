

import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:server_repository/api_response.dart';
import 'package:server_repository/models.dart';
import 'package:server_repository/repository.dart';

class ToleDataRepo{
  final QRLocationAdd_Api qrLocationAdd_Api = QRLocationAdd_Api();
  final QRToleAdd_Api qrToleAdd_Api = QRToleAdd_Api();
  final LocationApiRepository locationApiRepository = LocationApiRepository();
  final ToleApiRepo toleApiRepo = ToleApiRepo();
  final QRCustomerAddApi qrCustomerAddApi = QRCustomerAddApi();
  final CustomerApiRepository customerApiRepository = CustomerApiRepository();
  final ProcessApiRepository processApiRepository = ProcessApiRepository();

  Future<NEQrCustomerAdd> getQRCustomerData({required int id}) async{
    return  await qrCustomerAddApi.getQRCustomerAddData(id);
  }

  Future<NEQrLocationAdd> getQRLocationAddData({required id}) async{
    return await qrLocationAdd_Api.getQRLocationAddData(id);
  }

  Future<NEQRToleAdd> getQRToleAddData({required id}) async{
    return await qrToleAdd_Api.getQRToleAddData(id);
  }

  Future<CLocation> getLocationFromGPCode({required String gpcode}) async{
    return await locationApiRepository.getLocation(gpcode).then((value){
      return value.data!;
    });
  }

  Future<CLocation> getLocationByID({required id}) async{
    return  await locationApiRepository.getLocationByID(id);
  }

  Future<NETole> getToleDataFromID({required int ID}) async{
    NETole tole = await toleApiRepo.getToleByID(id: ID);
    return tole;
  }

  Future<ProcessSummary?> linkHouseWithTole({required ne_tole_id ,
  required c_location_id }) async{
    return await processApiRepository.linkHouseToToleProcess(
        ne_tole_id: ne_tole_id, c_location_id: c_location_id);
  }

  Future<CBpartner> getCustomerFromID({required int id}) async{
    CBpartner? response = await customerApiRepository.getCustomerByID(id);
    if(response != null){
      return response;
    }else{
      throw ("Error in Fetching Customer QR's Data");
    }
  }

  Future<CBpartner> getCustomerToGetLocationByQRValue({required String customerQR}) async{
    ApiResponse<CBpartner?> response = await customerApiRepository.getCustomerFromValue(customerQR);
    if(response.data != null){
      return response.data!;
    }else{
      throw ("Error in Fetching Customer QR's Data");
    }
  }
}