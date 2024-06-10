


import 'package:idempiere_rest/idempiere_rest.dart';

import '../../../models.dart';

class NEQrLocationAdd extends ModelBase{

  String? uid;
  bool? isActive;
  String? value;
  String? name;
  bool? inProgress;
  bool? taken;
  CLocationID? cLocationID;
  String? modelName;

  NEQrLocationAdd(json):super(json){
    id = json['id'];
    uid = json['uid'];
    isActive = json['IsActive'];
    value = json['Value'];
    name = json['Name'];
    inProgress = json['inProgress'];
    taken = json['taken'];
    cLocationID = json['C_Location_ID'] != null
        ? CLocationID.fromJson(json['C_Location_ID'])
        : null;
    modelName = json['model-name'];
  }

  NEQrLocationAdd fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    isActive = json['IsActive'];
    value = json['Value'];
    name = json['Name'];
    inProgress = json['inProgress'];
    taken = json['taken'];
    cLocationID = json['C_Location_ID'] != null
        ? CLocationID.fromJson(json['C_Location_ID'])
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
    if (cLocationID != null) {
      data['C_Location_ID'] = cLocationID!.toJson();
    }
    data['model-name'] = modelName;
    return data;
  }

  static const String model = "ne_qrlocation_add";

}

