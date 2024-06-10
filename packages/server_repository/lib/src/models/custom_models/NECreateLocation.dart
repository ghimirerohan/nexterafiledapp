
import 'package:idempiere_rest/idempiere_rest.dart';

import '../../../models.dart';

class NECreateLocation extends ModelBase{
  String? uid;
  bool? isActive;
  NeQrlocationAddID? neQrlocationAddID;
  bool? processed;
  String? updated;
  NeQrlocationAddID? updatedBy;
  String? value;
  Ward? ward;
  String? toleDevelopmentCommittee;
  String? streetname;
  String? locLatitude;
  String? locLongitude;
  String? houseOwnerName;
  String? gpCode;
  String? modelName;

  NECreateLocation(json):super(json){
    id = json['id'];
    uid = json['uid'];
    isActive = json['IsActive'];
    neQrlocationAddID = json['ne_qrlocation_add_ID'] != null
        ? NeQrlocationAddID.fromJson(json['ne_qrlocation_add_ID'])
        : null;
    processed = json['Processed'];
    updated = json['Updated'];
    updatedBy = json['UpdatedBy'] != null
        ? NeQrlocationAddID.fromJson(json['UpdatedBy'])
        : null;
    value = json['Value'];
    ward = json['ward'] != null ? Ward.fromJson(json['ward']) : null;
    toleDevelopmentCommittee = json['tole_development_committee'];
    streetname = json['streetname'];
    locLatitude = json['loc_latitude'];
    locLongitude = json['loc_longitude'];
    houseOwnerName = json['house_owner_name'];
    gpCode = json['ne_gpcode'];
    modelName = json['model-name'];
  }

  NECreateLocation fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    isActive = json['IsActive'];
    neQrlocationAddID = json['ne_qrlocation_add_ID'] != null
        ? NeQrlocationAddID.fromJson(json['ne_qrlocation_add_ID'])
        : null;
    processed = json['Processed'];
    updated = json['Updated'];
    updatedBy = json['UpdatedBy'] != null
        ? NeQrlocationAddID.fromJson(json['UpdatedBy'])
        : null;
    value = json['Value'];
    ward = json['ward'] != null ? Ward.fromJson(json['ward']) : null;
    toleDevelopmentCommittee = json['tole_development_committee'];
    streetname = json['streetname'];
    locLatitude = json['loc_latitude'];
    locLongitude = json['loc_longitude'];
    houseOwnerName = json['house_owner_name'];
    gpCode = json['ne_gpcode'];

    modelName = json['model-name'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['uid'] = uid;
    data['IsActive'] = isActive;
    if (neQrlocationAddID != null) {
      data['ne_qrlocation_add_ID'] = neQrlocationAddID!.toJson();
    }
    data['Processed'] = processed;
    data['Updated'] = updated;
    if (updatedBy != null) {
      data['UpdatedBy'] = updatedBy!.toJson();
    }
    data['Value'] = value;
    if (ward != null) {
      data['ward'] = ward!.toJson();
    }
    data['tole_development_committee'] = toleDevelopmentCommittee;
    data['streetname'] = streetname;
    data['loc_latitude'] = locLatitude;
    data['loc_longitude'] = locLongitude;
    data['house_owner_name'] = houseOwnerName;
    data['ne_gpcode'] = gpCode;
    data['model-name'] = modelName;
    return data;
  }


  static const String model = "ne_createlocation";
}



