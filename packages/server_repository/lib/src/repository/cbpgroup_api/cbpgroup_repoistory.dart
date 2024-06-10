
import 'package:server_repository/models.dart';

import '../../../api_response.dart';

abstract class CBPGroupRepository{

  Future<ApiResponse<List<CBPGroup>>> getCBPGroups();
}