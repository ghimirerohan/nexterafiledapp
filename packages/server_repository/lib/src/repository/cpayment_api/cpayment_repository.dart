
import 'package:server_repository/src/models/generic_models/CPayment.dart';

import '../../../api_response.dart';

abstract class CPaymentRepository{

  Future<ApiResponse<List<CPayment>>> getPaymentsOfCustomer( int c_bpartner_id);

  Future<ApiResponse<List<CPayment>>> getPaymentsfromCollectors( int ad_user_id);

  Future<ApiResponse<CPayment>> postPayment(CPayment data);
}