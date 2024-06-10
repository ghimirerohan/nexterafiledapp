
import 'package:idempiere_rest/idempiere_rest.dart';

class CPeriod extends ModelBase{
  String? uid;
  String? name;
  String? modelName;

  CPeriod(json):super(json){
    id = json['id'];
    uid = json['uid'];
    name = json['Name'];
    modelName = json['model-name'];
  }

  CPeriod fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    name = json['Name'];
    modelName = json['model-name'];
    return this;
  }



// Constructor for creating an empty instance
  CPeriod.empty() : super({}) {
    id = null;
    uid = null;
    name = null;
    modelName = null;
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['Name'] = this.name;
    data['model-name'] = this.modelName;
    return data;
  }

  static const model = "c_period";
}