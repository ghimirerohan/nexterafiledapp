

import 'package:idempiere_rest/idempiere_rest.dart';

import '../../../models.dart';

class NETole extends ModelBase{
  String? uid;
  String? name;
  Ward? ward;
  String? neToleheadName;
  String? neToleheadPhoneno;
  double? neToleNoofhouses;
  double? neToleNoofcustomers;
  double? price;
  String? modelName;

  NETole(json):super(json){
    id = json['id'];
    uid = json['uid'];
    name = json['Name'];
    ward = json['ward'] != null ? new Ward.fromJson(json['ward']) : null;
    neToleheadName = json['ne_tolehead_name'];
    neToleheadPhoneno = json['ne_tolehead_phoneno'];

    if(json['ne_tole_noofhouses'] != null){
      String noofhouses = json['ne_tole_noofhouses'].toString();
      if(noofhouses.contains(".")){
        neToleNoofhouses = json['ne_tole_noofhouses'];
      }else{
        neToleNoofhouses = double.parse(noofhouses);
      }
    }

    if(json['ne_tole_noofcustomers'] != null){
      String noofcustomers = json['ne_tole_noofcustomers'].toString();
      if(noofcustomers.contains(".")){
        neToleNoofcustomers = json['ne_tole_noofcustomers'];
      }else{
        neToleNoofcustomers = double.parse(noofcustomers);
      }
    }

    if(json['Price'] != null){
      String priceAmt = json['Price'].toString();
      if(priceAmt.contains(".")){
        price = json['Price'];
      }else{
        price = double.parse(priceAmt);
      }
    }
    // neToleNoofhouses = json['ne_tole_noofhouses'];
    // neToleNoofcustomers = json['ne_tole_noofcustomers'];
    // price = json['Price'];
    modelName = json['model-name'];
  }

  NETole fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    name = json['Name'];
    ward = json['ward'] != null ? new Ward.fromJson(json['ward']) : null;
    neToleheadName = json['ne_tolehead_name'];
    neToleheadPhoneno = json['ne_tolehead_phoneno'];
    neToleNoofhouses = json['ne_tole_noofhouses'];
    neToleNoofcustomers = json['ne_tole_noofcustomers'];
    price = json['Price'];
    modelName = json['model-name'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['Name'] = this.name;
    if (this.ward != null) {
      data['ward'] = this.ward!.toJson();
    }
    data['ne_tolehead_name'] = this.neToleheadName;
    data['ne_tolehead_phoneno'] = this.neToleheadPhoneno;
    data['ne_tole_noofhouses'] = this.neToleNoofhouses;
    data['ne_tole_noofcustomers'] = this.neToleNoofcustomers;
    data['Price'] = this.price;
    data['model-name'] = this.modelName;
    return data;
  }

  static const model = "ne_tole";

}


