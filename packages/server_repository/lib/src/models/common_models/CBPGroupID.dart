class CBPGroupID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelName;

  CBPGroupID({this.propertyLabel, this.id, this.identifier, this.modelName});

  CBPGroupID.copyWith({
    String? propertyLabel,
    int? id,
    String? identifier,
    String? modelName,
  }){
    this.id = id ?? this.id;
    this.identifier = identifier ?? this.identifier ;
    this.propertyLabel = propertyLabel ?? this.propertyLabel ;
    this.modelName = modelName ?? this.modelName;
  }
  CBPGroupID.fromJson(Map<String, dynamic> json) {
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