

import 'package:idempiere_rest/idempiere_rest.dart';

import '../../../models.dart';

class NEQRToleAdd extends ModelBase{
  String? uid;
  NeToleID? neToleID;
  bool? inProgress;
  bool? isActive;
  bool? taken;
  String? modelName;

  NEQRToleAdd(json):super(json){
    id = json['id'];
    uid = json['uid'];
    neToleID = json['ne_tole_ID'] != null
        ? new NeToleID.fromJson(json['ne_tole_ID'])
        : null;
    inProgress = json['inProgress'];
    isActive = json['IsActive'];
    taken = json['taken'];
    modelName = json['model-name'];
  }

  NEQRToleAdd fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    neToleID = json['ne_tole_ID'] != null
        ? new NeToleID.fromJson(json['ne_tole_ID'])
        : null;
    inProgress = json['inProgress'];
    isActive = json['IsActive'];
    taken = json['taken'];
    modelName = json['model-name'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    if (this.neToleID != null) {
      data['ne_tole_ID'] = this.neToleID!.toJson();
    }
    data['inProgress'] = this.inProgress;
    data['IsActive'] = this.isActive;
    data['taken'] = this.taken;
    data['model-name'] = this.modelName;
    return data;
  }
  static const String model = "ne_qrtole_add";

}


