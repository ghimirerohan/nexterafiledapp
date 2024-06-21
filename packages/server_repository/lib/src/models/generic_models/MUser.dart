import 'package:idempiere_rest/idempiere_rest.dart';

class MUser extends ModelBase {
  String? uid;
  String? name;
  bool? isDataCollector;
  String? modelName;

  MUser(json) : super(json) {
    id = json['id'];
    uid = json['uid'];
    name = json['Name'];
    isDataCollector = json['isDataCollector'];
    modelName = json['model-name'];
  }

  MUser fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    name = json['Name'];
    isDataCollector = json['isDataCollector'];
    modelName = json['model-name'];
    return this;
  }

// Constructor for creating an empty instance
  MUser.empty() : super({}) {
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
    data['isDataCollector'] = this.isDataCollector;
    data['model-name'] = this.modelName;
    return data;
  }

  static const model = "ad_user";
}
