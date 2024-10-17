
import 'package:flutter/cupertino.dart';
import 'package:server_repository/models.dart';

abstract class AddCustomerEvent{}

class FetchCBPGroupEvent implements AddCustomerEvent{}

class PostCustomerEvents implements AddCustomerEvent{

  final String name;
  final String phone;
  final String billName;
  final int c_bp_group_id;
  final int c_location_id;
  final double? housestory;
  final String? email;
  final String? taxID;
  final int ne_qrcustomeradd_id;
  final String? businessNo;
  final BuildContext context;

  const PostCustomerEvents({
    required this.name,
    required this.phone,
    required this.c_bp_group_id,
    required this.c_location_id,
    this.email,
    this.housestory,
    required this.billName,
    this.taxID,
    required this.ne_qrcustomeradd_id,
    this.businessNo,
    required this.context
});
}

class ChangeCBPGroupDDEvent implements AddCustomerEvent{
  final CBPGroup value;

  const ChangeCBPGroupDDEvent({required this.value});
}

class ChangeHasCardStatus implements AddCustomerEvent{
  final bool changedValue;

  const ChangeHasCardStatus({required this.changedValue});
}

class OpenCameraForCard extends AddCustomerEvent{}