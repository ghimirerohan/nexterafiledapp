import 'package:flutter/material.dart';
import 'package:server_repository/models.dart';

abstract class AddPaymentEvent{}

class FetchAddPaymentData implements AddPaymentEvent{

  final CBpartner c_bpartner_id;

  FetchAddPaymentData({required this.c_bpartner_id});
}

class ChangeDDToPeriod implements AddPaymentEvent{
  final CPeriod period;

  ChangeDDToPeriod({required this.period});
}

class ChangeDDFromPeriod implements AddPaymentEvent{
  final CPeriod period;

  ChangeDDFromPeriod({required this.period});
}

class PostPaymentData implements AddPaymentEvent{
  final int c_bpartner_id;
  final int fromPeriodID;
  final int toPeriodID;
  final double payAmt;
  final isDiscountEnabled;
  final BuildContext context;

  PostPaymentData({required this.c_bpartner_id ,
    required this.fromPeriodID , required this.toPeriodID ,
    required this.payAmt,
    required this.isDiscountEnabled,
  required this.context});

}

class ReportCustomerAsDefaulter implements AddPaymentEvent{
  final int c_bpartner_id;
  final String reason_type;
  final String remark;

  ReportCustomerAsDefaulter({required this.c_bpartner_id ,
    required this.reason_type , required this.remark});
}

class OpenCustomerReportingForm implements AddPaymentEvent{
  final bool isOpen;
  OpenCustomerReportingForm({required this.isOpen});
}

class UpdatePanNoandBusinessNo implements AddPaymentEvent{
  final String? panNo;
  final String? businessNo;
  final String? phoneNo;
  final CBpartner model;

  UpdatePanNoandBusinessNo({this.businessNo , this.panNo , this.phoneNo, required this.model});
}

class OpenAddPanNoBusinessNo implements AddPaymentEvent{}

class UpdateRateEvent implements AddPaymentEvent{
  final int c_bpartner_id;
  final String rate;
  final String pan;
  final String businessNo;


  UpdateRateEvent({required this.c_bpartner_id , required this.rate ,
  required this.pan , required this.businessNo});
}

class UpdatePhoneEvent implements AddPaymentEvent{
  final int c_bpartner_id;
  final String phone;

  UpdatePhoneEvent({required this.c_bpartner_id , required this.phone});
}

class UpdateQREvent implements AddPaymentEvent{
  final int c_bpartner_id;
  final int ne_qrcustomeradd_id;

  UpdateQREvent({required this.c_bpartner_id , required this.ne_qrcustomeradd_id});
}

class ConfirmUpdateQREvent implements AddPaymentEvent{
  final int c_bpartner_id;
  final int ne_qrcustomeradd_id;

  ConfirmUpdateQREvent({required this.c_bpartner_id , required this.ne_qrcustomeradd_id});
}

class ChangeDiscountEnabledEvent implements AddPaymentEvent{
  final bool enableDiscount;
  ChangeDiscountEnabledEvent({required this.enableDiscount});
}