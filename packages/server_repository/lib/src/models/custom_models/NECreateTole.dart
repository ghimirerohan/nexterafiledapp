

import 'package:idempiere_rest/idempiere_rest.dart';

import '../common_models/NeQrtoleAddID.dart';
import '../common_models/Ward.dart';

class NECreateTole extends ModelBase{
  String? uid;
  String? name;
  String? neToleheadName;
  String? neToleheadPhoneno;
  Ward? ward;
  NeQrtoleAddID? neQrtoleAddID;
  String? modelName;

  NECreateTole(json):super(json){
    id = json['id'];
    uid = json['uid'];
    name = json['Name'];
    neToleheadName = json['ne_tolehead_name'];
    neToleheadPhoneno = json['ne_tolehead_phoneno'];
    ward = json['ward'] != null ? new Ward.fromJson(json['ward']) : null;
    neQrtoleAddID = json['ne_qrtole_add_ID'] != null
        ? new NeQrtoleAddID.fromJson(json['ne_qrtole_add_ID'])
        : null;
    modelName = json['model-name'];
  }

  NECreateTole fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    name = json['Name'];
    neToleheadName = json['ne_tolehead_name'];
    neToleheadPhoneno = json['ne_tolehead_phoneno'];
    ward = json['ward'] != null ? new Ward.fromJson(json['ward']) : null;
    neQrtoleAddID = json['ne_qrtole_add_ID'] != null
        ? new NeQrtoleAddID.fromJson(json['ne_qrtole_add_ID'])
        : null;
    modelName = json['model-name'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['Name'] = this.name;
    data['ne_tolehead_name'] = this.neToleheadName;
    data['ne_tolehead_phoneno'] = this.neToleheadPhoneno;
    if (this.ward != null) {
      data['ward'] = this.ward!.toJson();
    }
    if (this.neQrtoleAddID != null) {
      data['ne_qrtole_add_ID'] = this.neQrtoleAddID!.toJson();
    }
    data['model-name'] = this.modelName;
    return data;
  }

  static const String model = "ne_createtoles";
}




