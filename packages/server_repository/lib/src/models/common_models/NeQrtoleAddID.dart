
class NeQrtoleAddID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelName;

  NeQrtoleAddID({this.propertyLabel, this.id, this.identifier, this.modelName});

  NeQrtoleAddID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'];
    id = json['id'];
    identifier = json['identifier'];
    modelName = json['model-name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['propertyLabel'] = this.propertyLabel;
    data['id'] = this.id;
    data['identifier'] = this.identifier;
    data['model-name'] = this.modelName;
    return data;
  }
}