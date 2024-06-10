

import 'package:idempiere_rest/idempiere_rest.dart';

import '../../../models.dart';

class NEQrCustomerAdd extends ModelBase{

  String? uid;
  bool? isActive;
  String? value;
  String? name;
  bool? inProgress;
  bool? taken;
  CBPartnerID? cBPartnerID;
  String? modelName;

  NEQrCustomerAdd(json):super(json){
    id = json['id'];
    uid = json['uid'];
    isActive = json['IsActive'];
    value = json['Value'];
    name = json['Name'];
    inProgress = json['inProgress'];
    taken = json['taken'];
    cBPartnerID = json['C_BPartner_ID'] != null
        ? CBPartnerID.fromJson(json['C_BPartner_ID'])
        : null;
    modelName = json['model-name'];
  }

  NEQrCustomerAdd fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    isActive = json['IsActive'];
    value = json['Value'];
    name = json['Name'];
    inProgress = json['inProgress'];
    taken = json['taken'];
    cBPartnerID = json['C_BPartner_ID'] != null
        ? CBPartnerID.fromJson(json['C_BPartner_ID'])
        : null;
    modelName = json['model-name'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['IsActive'] = isActive;
    data['Value'] = value;
    data['Name'] = name;
    data['inProgress'] = inProgress;
    data['taken'] = taken;
    if (cBPartnerID != null) {
      data['C_BPartner_ID'] = cBPartnerID!.toJson();
    }
    data['model-name'] = modelName;
    return data;
  }

  static const String model = "ne_qrcustomer_add";

}

