import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:server_repository/models.dart';


class CBpartner extends ModelBase{
  String? uid;
  String? value;
  String? name;
  String? phone;
  CBPGroupID? cBPGroupID;
  Ward? ward;
  CBPGroupID? cLocationID;
  CBPGroupID? toPeriodID;
  CBPGroupID? currentFromPeriodID;
  bool? hasCard;
  String? email;
  double? housestoreynumber;
  double? ratePerMonth;
  DocStatus? lastPayStatus;
  String? taxId;
  String? businessNo;
  String? modelName;

   CBpartner(json):super(json){
    id = json['id'];
    uid = json['uid'];
    value = json['Value'];
    name = json['Name'];
    phone = json['Name2'];
    hasCard = json['HasCard'];
    email =json['EMail'];
    if(json['house_storey_number'] != null){
      String housetala = json['house_storey_number'].toString();
      if(housetala.contains(".")){
        housestoreynumber = json['house_storey_number'];
      }else{
        housestoreynumber = double.parse(housetala);
      }
    }
    if(json['Price'] != null){
      String priceString = json['Price'].toString();
      if(priceString.contains(".")){
        ratePerMonth = json['Price'];
      }else{
        ratePerMonth = double.parse(priceString);
      }
    }

    cBPGroupID = json['C_BP_Group_ID'] != null
        ? CBPGroupID.fromJson(json['C_BP_Group_ID'])
        : null;
    ward = json['ward'] != null ? Ward.fromJson(json['ward']) : null;
    cLocationID = json['C_Location_ID'] != null
        ? CBPGroupID.fromJson(json['C_Location_ID'])
        : null;
    lastPayStatus = json['DocStatus'] != null
        ? DocStatus.fromJson(json['DocStatus'])
        : null;
    toPeriodID = json['To_Period_ID'] != null
        ? CBPGroupID.fromJson(json['To_Period_ID'])
        : null;
    currentFromPeriodID = json['C_Period_ID'] != null
        ? CBPGroupID.fromJson(json['C_Period_ID'])
        : null;

    taxId = json['TaxID'];
    businessNo = json['ne_businessno'];
    modelName = json['model-name'];
  }

  CBpartner newModel(){
  return this;
  }
   CBpartner copyWith({
    String? name,
    String? phone,
     String? email,
     bool? hasCard,
     int? housestoreynumber,
    int? cBPGroupID,
    int? ward,
    int? cLocationID
}){
    return CBpartner(
      {
        'Value' : phone.toString(),
        'Name' : name ?? this.name,
        'Name2' : phone ?? this.phone,
        'HasCard' : hasCard ?? this.hasCard,
        'EMail' : email ?? this.email,
        'house_storey_number' : housestoreynumber ?? this.housestoreynumber,
        'C_BP_Group_ID' : CBPGroupID.copyWith(
          id: cBPGroupID
        ).toJson(),
        'ward' : Ward.copyWith(
          identifier: ward,
          id: ward
        ).toJson(),
        'C_Location_ID' : CBPGroupID.copyWith(
            id: cLocationID
        ).toJson()
      }
    );
}

  @override
  CBpartner fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    value = json['Value'];
    name = json['Name'];
    phone = json['Name2'];
    hasCard = json['HasCard'];
    email =json['EMail'];
    housestoreynumber = json['house_storey_number'];
    cBPGroupID = json['C_BP_Group_ID'] != null
        ? CBPGroupID.fromJson(json['C_BP_Group_ID'])
        : null;
    ward = json['ward'] != null ? Ward.fromJson(json['ward']) : null;
    cLocationID = json['C_Location_ID'] != null
        ? CBPGroupID.fromJson(json['C_Location_ID'])
        : null;
    lastPayStatus = json['DocStatus'] != null
        ? DocStatus.fromJson(json['DocStatus'])
        : null;
    toPeriodID = json['To_Period_ID'] != null
        ? CBPGroupID.fromJson(json['To_Period_ID'])
        : null;
    currentFromPeriodID = json['C_Period_ID'] != null
        ? CBPGroupID.fromJson(json['C_Period_ID'])
        : null;
    taxId = json['TaxID'];
    businessNo = json['ne_businessno'];
    ratePerMonth = json['Price'];
    modelName = json['model-name'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['Value'] = value;
    data['Name'] = name;
    data['Name2'] = phone;
    data['HasCard']=hasCard;
    data['EMail'] = email;
    data['house_storey_number'] = housestoreynumber;
    if (cBPGroupID != null) {
      data['C_BP_Group_ID'] = cBPGroupID!.toJson();
    }
    if (ward != null) {
      data['ward'] = ward!.toJson();
    }
    if (cLocationID != null) {
      data['C_Location_ID'] = cLocationID!.toJson();
    }
    if (lastPayStatus != null) {
      data['DocStatus'] = lastPayStatus!.toJson();
    }
    if (toPeriodID != null) {
      data['To_Period_ID'] = toPeriodID!.toJson();
    }
    if (currentFromPeriodID != null) {
      data['C_Period_ID'] = currentFromPeriodID!.toJson();
    }
    data['TaxID'] = taxId;
    data['ne_businessno'] = businessNo;
    data['model-name'] = modelName;
    data['Price'] = ratePerMonth;
    return data;
  }

  static const String model = "c_bpartner";
}





