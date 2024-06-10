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

class PostPaymentData implements AddPaymentEvent{
  final int c_bpartner_id;
  final int fromPeriodID;
  final int toPeriodID;
  final int payAmt;
  final BuildContext context;

  PostPaymentData({required this.c_bpartner_id ,
    required this.fromPeriodID , required this.toPeriodID ,
    required this.payAmt,
  required this.context});

}