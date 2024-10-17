import 'package:server_repository/src/data/network/network_api_services.dart';
import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:server_repository/src/utils/LocalStorage.dart';

class ProcessApiRepository {

  LocalStorage localStorage = LocalStorage();

  NetworkApiService networkApiService = NetworkApiService();

  Future<ProcessSummary?> runGeneralProcess(
      {required String slugName, Map<String, dynamic>? body}) async {
    ProcessSummary? ps =
        await networkApiService.runProcess(slugName: slugName, body: body);
    return ps;
  }

  Future<ProcessSummary?> linkHouseToToleProcess({required int ne_tole_id ,
  required int c_location_id}) async{
    return await runGeneralProcess(slugName: 'link_house_tole',
        body: {
          "ne_tole_ID" : ne_tole_id,
          "C_Location_ID" : c_location_id
        }
    );
  }
  Future<ProcessSummary?> getLocationReachedMapCSV() async{
    return await runGeneralProcess(slugName: 'locationreached_csv_process',
body: {
        "report-type" : "CSV"
        }
    );
  }

  Future<ProcessSummary?> verifyLocationDataOfQR(
      {required int ne_createlocation_ID}) async {
    Map<String, dynamic> body = {
      "CustomerActionList": "AP",
      "ne_createlocation_ID": ne_createlocation_ID
    };
    ProcessSummary? ps = await networkApiService.runProcess(
        slugName: "location_addition_process", body: body);
    return ps;
  }

  Future<ProcessSummary?> getCustomerCreatedByCollectorTodayAndTotal(
      {required int ad_user_id}) async {
    Map<String, dynamic> body = {"AD_User_ID": ad_user_id};
    ProcessSummary? ps = await networkApiService.runProcess(
        slugName: "get-customer-created-number", body: body);
    return ps;
  }

  Future<ProcessSummary?> reportCustomerDefaultProcess(
      {required int c_bpartner_id , required String reason , required String remark}) async {
    Map<String, dynamic> body =
    {"C_BPartner_ID": c_bpartner_id ,
    "ne_customerdefault_reason" : reason,
    "Description" : remark};
    ProcessSummary? ps = await networkApiService.runProcess(
        slugName: "post-defaulter-customer", body: body);
    return ps;
  }

  Future<ProcessSummary?> updateCustomerDetails(
      {required Map<String, dynamic> body}) async {
    String slug = "change_customer_details_process";

    ProcessSummary? ps = await networkApiService.runProcess(
        slugName: slug, body: body);

    return ps;
  }

  Future<ProcessSummary?> updateCustomerRate({required int c_bpartner_id , required int rate}) async{
    return await updateCustomerDetails(
        body:
        {
          "C_BPartner_ID" : c_bpartner_id,
          "Price": rate
        }
    );
  }

  Future<ProcessSummary?> updateCustomerRatePanAndBusinessNo({
    required int c_bpartner_id , required String rate,
    required String pan , required String businessNo}) async{
    return await updateCustomerDetails(
        body:
        {
          "C_BPartner_ID" : c_bpartner_id,
          "Price": rate == "" ? 0 : int.parse(rate),
          "TaxID" : pan,
          "ne_businessno" : businessNo
        }
    );
  }

  Future<ProcessSummary?> updateCustomerPhone({required int c_bpartner_id , required String phone}) async{
    return await updateCustomerDetails(
        body:
        {
          "C_BPartner_ID" : c_bpartner_id,
          "Name2": phone
        }
    );
  }

  Future<ProcessSummary?> updateCustomerQR({required int c_bpartner_id , required ne_qrcustomer_add_ID }) async{
    return await updateCustomerDetails(
        body:
        {
          "C_BPartner_ID" : c_bpartner_id,
          "ne_qrcustomer_add_ID": ne_qrcustomer_add_ID
        }
    );
  }
}
