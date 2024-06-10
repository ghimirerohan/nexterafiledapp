class CBPartnerID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelName;

  CBPartnerID({this.propertyLabel, this.id, this.identifier, this.modelName});

  CBPartnerID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'];
    id = json['id'];
    identifier = json['identifier'];
    modelName = json['model-name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(propertyLabel != null){
      data['propertyLabel'] = propertyLabel;
    }
    if(id != null){
      data['id'] = id;
    }
    if(identifier != null){
      data['identifier'] = identifier;
    }
    if(modelName != null){
      data['model-name'] = modelName;
    }
    return data;
  }
}