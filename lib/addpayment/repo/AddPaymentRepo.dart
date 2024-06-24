
import 'package:server_repository/api_response.dart';
import 'package:server_repository/models.dart';
import 'package:server_repository/repository.dart';

class AddPaymentRepo{

  final CPeriodApiRepository cPeriodApiRepository = CPeriodApiRepository();
  final CPaymentApiRepository cPaymentApiRepository = CPaymentApiRepository();
  Future<List<CPeriod>> getCurrentPeriod(int c_period_id) async{
    ApiResponse<List<CPeriod>> data = await cPeriodApiRepository.getPeriodsGreaterThanLastPeriod(c_period_id);
    if(data.data!.isEmpty){
      throw("No Next Periods Found");
    }else{
      return data.data!;
    }
  }

  Future<CPayment> postPayment({required int c_bpartner_id , required int fromPeriodId , required int toPeriodId
  ,required double payAmt}) async{
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

    ApiResponse<CPayment> response = await cPaymentApiRepository.postPayment(toPost);
    if(response.data == null){
      throw("Couldn't post data");
    }else{
      return response.data!;
    }


  }

}