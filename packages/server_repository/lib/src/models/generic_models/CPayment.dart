import 'package:idempiere_rest/idempiere_rest.dart';

import '../../../models.dart';
import '../common_models/CBPartnerID.dart';

class CPayment extends ModelBase{
  String? uid;
  double? payAmt;
  CBPartnerID? cBPartnerID;
  String? dateTrx;
  bool? isDiscountEnabled;
  CBPartnerID? toPeriodID;
  CBPartnerID? salesRepID;
  CBPartnerID? fromPeriodID;
  DocStatus? docStatus;

  String? modelName;

  CPayment(json) : super(json){
    id = json['id'];
    uid = json['uid'];
    if(json['PayAmt'] != null){
      String priceString = json['PayAmt'].toString();
      if(priceString.contains(".")){
        payAmt = json['PayAmt'];
      }else{
        payAmt = double.parse(priceString);
      }
    }
    cBPartnerID = json['C_BPartner_ID'] != null
        ? CBPartnerID.fromJson(json['C_BPartner_ID'])
        : null;
    dateTrx = json['DateTrx'];
    isDiscountEnabled = json['ne_discount_saved'];
    toPeriodID = json['To_Period_ID'] != null
        ? CBPartnerID.fromJson(json['To_Period_ID'])
        : null;
    salesRepID = json['SalesRep_ID'] != null
        ? CBPartnerID.fromJson(json['SalesRep_ID'])
        : null;
    fromPeriodID = json['From_Period_ID'] != null
        ? CBPartnerID.fromJson(json['From_Period_ID'])
        : null;
    docStatus = json['DocStatus'] != null
        ?  DocStatus.fromJson(json['DocStatus'])
        : null;
    modelName = json['model-name'];
  }

  @override
  CPayment fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    payAmt = json['PayAmt'];
    cBPartnerID = json['C_BPartner_ID'] != null
        ? CBPartnerID.fromJson(json['C_BPartner_ID'])
        : null;
    dateTrx = json['DateTrx'];
    isDiscountEnabled = json['ne_discount_saved'];
    toPeriodID = json['To_Period_ID'] != null
        ? CBPartnerID.fromJson(json['To_Period_ID'])
        : null;
    salesRepID = json['SalesRep_ID'] != null
        ? CBPartnerID.fromJson(json['SalesRep_ID'])
        : null;
    fromPeriodID = json['From_Period_ID'] != null
        ? CBPartnerID.fromJson(json['From_Period_ID'])
        : null;
    modelName = json['model-name'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['PayAmt'] = payAmt;
    data['ne_discount_saved'] = isDiscountEnabled  ;
    if (cBPartnerID != null) {
      data['C_BPartner_ID'] = cBPartnerID!.toJson();
    }
    data['DateTrx'] = dateTrx;
    if (toPeriodID != null) {
      data['To_Period_ID'] = toPeriodID!.toJson();
    }
    if (salesRepID != null) {
      data['SalesRep_ID'] = salesRepID!.toJson();
    }
    if (fromPeriodID != null) {
      data['From_Period_ID'] = fromPeriodID!.toJson();
    }
    if (docStatus != null) {
      data['DocStatus'] = docStatus!.toJson();
    }
    data['model-name'] = modelName;
    return data;
  }

  static const String model = "c_payment";

}


