
import 'package:server_repository/src/data/network/network_api_services.dart';
import 'package:idempiere_rest/idempiere_rest.dart';


class ProcessApiRepository{
  
  NetworkApiService networkApiService = NetworkApiService();

  Future<ProcessSummary?> runGeneralProcess({required String slugName , Map<String,dynamic>? body}) async{
    ProcessSummary? ps = await networkApiService.runProcess(slugName: slugName , body:  body);
    return ps;
  }

  Future<ProcessSummary?> verifyLocationDataOfQR({required int ne_createlocation_ID}) async{
    Map<String,dynamic> body ={
      "CustomerActionList" : "AP",
      "ne_createlocation_ID" : ne_createlocation_ID
    };
    ProcessSummary? ps = await networkApiService.runProcess(
        slugName: "location_addition_process" ,
        body:  body);
    return ps;
  }

  Future<ProcessSummary?> getCustomerCreatedByCollectorTodayAndTotal({required int ad_user_id}) async{
    Map<String,dynamic> body ={
      "AD_User_ID" : ad_user_id
    };
    ProcessSummary? ps = await networkApiService.runProcess(
        slugName: "get-customer-created-number" ,
        body:  body);
    return ps;
  }


}