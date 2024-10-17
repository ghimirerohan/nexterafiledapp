
import 'package:server_repository/models.dart';
import 'package:server_repository/repository.dart';

class buildingListRepo{
  final QRLocationAdd_Api qrLocationAdd_Api = QRLocationAdd_Api();
  final LocationApiRepository locationApiRepository = LocationApiRepository();

  Future<NEQrLocationAdd> getQRLocationAddData({required id}) async{
    return  await qrLocationAdd_Api.getQRLocationAddData(id);
  }

  Future<CLocation> getLocationFromGPCode({required String gpcode}) async{
        return await locationApiRepository.getLocation(gpcode).then((value){
          return value.data!;
        });
  }
  
}