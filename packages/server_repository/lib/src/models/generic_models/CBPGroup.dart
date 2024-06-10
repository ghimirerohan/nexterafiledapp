
import 'package:idempiere_rest/idempiere_rest.dart';

class CBPGroup extends ModelBase{
  String? uid;
  String? name;
  bool? isStoryBased;
  String? modelName;

  CBPGroup(json) : super(json){
    id = json['id'];
    uid = json['uid'];
    name = json['Name'];
    isStoryBased = json['isStoryBased'];
    modelName = json['model-name'];
  }

  CBPGroup fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    name = json['Name'];
    isStoryBased = json['isStoryBased'];
    modelName = json['model-name'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['Name'] = this.name;
    data['isStoryBased'] = this.isStoryBased;
    data['model-name'] = this.modelName;
    return data;
  }

  static const String model = "c_bp_group";
}
