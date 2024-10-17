
import 'package:auth_repository/auth_repository.dart';
import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:server_repository/api_response.dart';
import 'package:server_repository/models.dart';
import 'package:server_repository/repository.dart';

class AddPaymentRepo{

  final CPeriodApiRepository cPeriodApiRepository = CPeriodApiRepository();
  final CPaymentApiRepository cPaymentApiRepository = CPaymentApiRepository();
  final CustomerApiRepository customerApiRepository = CustomerApiRepository();
  final AuthenticationRepository authenticationRepository = AuthenticationRepository();
  final ProcessApiRepository processApiRepository = ProcessApiRepository();
  final QRCustomerAddApi qrCustomerAddApi = QRCustomerAddApi();



  Future<NEQrCustomerAdd> getQRCustomerData(int id) async{
    return  await qrCustomerAddApi.getQRCustomerAddData(id);
  }

  Future<ProcessSummary?> updateCustomerRatePanAndBusinessNo({required int c_bpartner_id
  , required String rate , required String pan , required String businessNo}) async{
    return await processApiRepository.updateCustomerRatePanAndBusinessNo(
        c_bpartner_id: c_bpartner_id, rate: rate , pan: pan , businessNo: businessNo);
  }

  Future<ProcessSummary?> updateCustomerPhone({required int c_bpartner_id
    , required String phone}) async{
    return await processApiRepository.updateCustomerPhone(c_bpartner_id: c_bpartner_id, phone: phone);
  }

  Future<ProcessSummary?> postReportCustomerAsDefaulter({required int c_bpartner_id
    , required String reason , required String remark}) async{
    return await processApiRepository.reportCustomerDefaultProcess
      (c_bpartner_id: c_bpartner_id, reason: reason, remark: remark);
  }

  Future<ProcessSummary?> updateCustomerQR({required int c_bpartner_id
    , required int ne_qrcustomer_add_ID}) async{
    return await processApiRepository.updateCustomerQR(
        c_bpartner_id: c_bpartner_id, ne_qrcustomer_add_ID: ne_qrcustomer_add_ID);
  }

  Future<CBpartner?> putCustomerForUpdate(String? businessNo , String? panNo , String? phoneNo, CBpartner model) async{
    if(phoneNo != null){
      if(phoneNo != "" && phoneNo != "9800000000"){
        model.phone = phoneNo;
      }
    }
    if(businessNo != null && panNo != null){
      model.taxId = panNo;
      model.businessNo = businessNo;
    }else if(businessNo != null){
      model.businessNo = businessNo;
    }else if(panNo != null){
      model.taxId = panNo;
    }
    return await customerApiRepository.putCustomer(model);

  }

  Future<bool> getIsUserAdmin() async{
    return await authenticationRepository.isUserAAdminFromCache();
  }

  Future<List<CPeriod>> getCurrentPeriod(int c_period_id) async{
    ApiResponse<List<CPeriod>> data = await cPeriodApiRepository.getPeriodsGreaterThanLastPeriod(c_period_id);
    if(data.data!.isEmpty){
      throw("No Next Periods Found");
    }else{
      return data.data!;
    }
  }

  Future<List<CPeriod>> getAllInitialPeriods() async{
    ApiResponse<List<CPeriod>> data = await cPeriodApiRepository.getAllInitialsPeriods();
    if(data.data!.isEmpty){
      throw("No  Periods Found");
    }else{
      return data.data!;
    }
  }

  Future<CPayment> postPayment({required int c_bpartner_id , required int fromPeriodId , required int toPeriodId
  ,required double payAmt , required bool isDiscountEnabled}) async{
    CPayment toPost = CPayment(<String,dynamic>{});
    CBPartnerID cbId = CBPartnerID();
    cbId.id = c_bpartner_id;
    toPost.cBPartnerID = cbId;

    CBPartnerID fromId = CBPartnerID();
    fromId.id = fromPeriodId;
    toPost.fromPeriodID = fromId;

    CBPartnerID toId = CBPartnerID();
    toId.id = toPeriodId;
    toPost.toPeriodID = toId;

    toPost.payAmt = payAmt;

    toPost.isDiscountEnabled = !isDiscountEnabled;

    ApiResponse<CPayment> response = await cPaymentApiRepository.postPayment(toPost);
    if(response.data == null){
      throw("Couldn't post data");
    }else{
      return response.data!;
    }


  }

}