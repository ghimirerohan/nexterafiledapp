import 'package:auth_repository/auth_repository.dart';
import 'package:server_repository/server_repository.dart';

enum CustListStatus { none ,error, openPayment , addNew}

class CustListRepo{

  final LocationApiRepository locationRepository = LocationApiRepository();
  final CustomerApiRepository customerApiRepository = CustomerApiRepository();
  final CPeriodApiRepository cPeriodApiRepository = CPeriodApiRepository();
  final QRCustomerAddApi qrCustomerAddApi = QRCustomerAddApi();
  final AuthenticationRepository authenticationRepository = AuthenticationRepository();
  final CreateCustomerApiRepository createCustomerApiRepository = CreateCustomerApiRepository();


  Future<NEQrCustomerAdd> getQRCustomerData(int id) async{
    return  await qrCustomerAddApi.getQRCustomerAddData(id);
  }

  Future<CLocation?> getLocationFromGPCode(String code) async{
    ApiResponse<CLocation> data = await locationRepository.getLocation(code);
    if(data.data == null){
      throw("No Location Code In Database");
    }else{
      return data.data;
    }
  }

  Future<bool> getisDataCollector() async{
    return await authenticationRepository.isUserADataCollectorFromCache();
  }
  Future<CLocation?> updateLocation(CLocation data) async{
    ApiResponse<CLocation> response = await locationRepository.updateLocation(data);
    return response.data;
  }

  Future<CPeriod> getCurrentPeriod() async{
    ApiResponse<List<CPeriod>> data = await cPeriodApiRepository.getCurrentPeriod();
    if(data.data!.isEmpty){
      throw("No Current Period");
    }else{
      return data.data![0];
    }
  }

  Future<List<CBpartner>?> getCustomersList(int c_location_id) async{
    ApiResponse<List<CBpartner>>? data = await customerApiRepository.getCustomer(c_location_id);
    return data?.data;
  }



}