
import 'package:server_repository/api_response.dart';
import 'package:server_repository/models.dart';
import 'package:server_repository/repository.dart';
import 'package:auth_repository/services/storage/local_storage.dart';


class HomeRepository{
   HomeRepository();
   final LocalStorage storage = LocalStorage();

  final CPaymentApiRepository cPaymentApiRepository = CPaymentApiRepository();
   final CustomerApiRepository customerApiRepository = CustomerApiRepository();
   final QRLocationAdd_Api qrLocationAdd_Api = QRLocationAdd_Api();
   final QRCustomerAddApi qrCustomerAddApi = QRCustomerAddApi();
   final LocationApiRepository locationApiRepository = LocationApiRepository();

   Future<NEQrCustomerAdd> getQRCustomerData(int id) async{
     return  await qrCustomerAddApi.getQRCustomerAddData(id);
   }

   Future<CLocation> getLocationFromID(int ID) async{
     return await locationApiRepository.getLocationByID(ID);
   }
   Future<NEQrLocationAdd> getQRLocationData(int id) async{
     return  await qrLocationAdd_Api.getQRLocationAddData(id);
   }
   Future<CBpartner?> getCustomerByValueToDirectPay(String value) async{
     ApiResponse<CBpartner?> response = await customerApiRepository.getCustomerFromValue(value);
     return response.data;
   }

   Future<CBpartner?> getCustomerFromID(int id) async{
     CBpartner? response = await customerApiRepository.getCustomerByID(id);
     return response;
   }
   Future<int> getTodayTotalCollectionOfCollector() async{
    String uId = await  storage.readValue("userid");
    int ad_user_id = int.parse(uId);
    int totalAmt = 0;
    ApiResponse<List<CPayment>> response = await cPaymentApiRepository.getTodayPaymentsfromCollectors(ad_user_id);
    for(CPayment pay in response.data!){
      totalAmt = totalAmt + pay.payAmt!;
    }
    return totalAmt;
  }
  bool isQRDataValid(String data){
    if(data.contains("https://plus.codes/")){
      return true;
    }else{
      return false;
    }
  }
}