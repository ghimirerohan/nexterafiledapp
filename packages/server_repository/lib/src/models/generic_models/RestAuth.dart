
import 'package:idempiere_rest/idempiere_rest.dart';

class RestAuth extends ModelBase{
  String? uid;
  String? token;
  String? modelName;

  RestAuth(json):super(json){
    id = json['id'];
    uid = json['uid'];
    token = json['Token'];
    modelName = json['model-name'];
  }

  RestAuth fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    token = json['Token'];
    modelName = json['model-name'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['Token'] = this.token;
    data['model-name'] = this.modelName;
    return data;
  }

  static const model = "rest_authtoken";
}
