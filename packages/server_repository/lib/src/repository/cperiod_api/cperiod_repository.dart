
import '../../../api_response.dart';
import '../../../models.dart';

abstract class CPeriodRepository{

  Future<ApiResponse<List<CPeriod>>> getCurrentPeriod();

  Future<ApiResponse<List<CPeriod>>> getPeriodsGreaterThanLastPeriod(int c_period_id);
}