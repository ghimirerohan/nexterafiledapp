class Ward {
  String? propertyLabel;
  String? id;
  String? identifier;
  String? modelName;

  Ward({this.propertyLabel, this.id, this.identifier, this.modelName});

  Ward.copyWith({
    String? propertyLabel,
    int? id,
    int? identifier,
    String? modelName,
  }){
    this.id = id != null ? (id < 10 ?  id!.toString().padLeft(2, '0') : id!.toString()): this.id;
    this.identifier = identifier != null ? (identifier < 10 ?  identifier!.toString().padLeft(2, '0') : identifier!.toString()): this.id;
    this.propertyLabel = propertyLabel ?? this.propertyLabel ;
    this.modelName = modelName ?? this.modelName;
  }

  Ward.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'];
    id = json['id'];
    identifier = json['identifier'];
    modelName = json['model-name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
