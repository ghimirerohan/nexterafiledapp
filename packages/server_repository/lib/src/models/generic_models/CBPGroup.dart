
import 'package:idempiere_rest/idempiere_rest.dart';

class CBPGroup extends ModelBase{
  String? uid;
  String? name;
  String? englishName;
  bool? isStoryBased;
  String? modelName;

  CBPGroup(json) : super(json){
    id = json['id'];
    uid = json['uid'];
    name = json['Name'];
    isStoryBased = json['isStoryBased'];
    englishName = json['Value'];
    modelName = json['model-name'];
  }

  CBPGroup fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    name = json['Name'];
    isStoryBased = json['isStoryBased'];
    englishName = json['Value'];
    modelName = json['model-name'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['Name'] = name;
    data['isStoryBased'] = isStoryBased;
    data['Value'] = englishName;
    data['model-name'] = modelName;
    return data;
  }

  static const String model = "c_bp_group";
}
