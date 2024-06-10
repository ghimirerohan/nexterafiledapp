
import '../../../api_response.dart';
import '../../../models.dart';

abstract class CreateCustomerRepository{

  Future<ApiResponse<List<NECreateCustomer>>> getCreateCustomer(int c_bpartner_id);

  Future<ApiResponse<NECreateCustomer>> postCreateCustomer(NECreateCustomer data);
}