import 'package:idempiere_rest/idempiere_rest.dart';

class CLocation extends ModelBase{
  String? uid;
  String? gpcode;
  String? housecode;
  String? ownerName;
  int? noOfCustomers;
  double? ratePerMonth;
  String? modelName;

  CLocation(json):super(json){
  id = json['id'];
  uid = json['uid'];
  gpcode = json['Address5'];
  housecode = json['Address4'];
  ownerName = json['City'];
  noOfCustomers = json['noOfCustomers'];
  if(json['Price'] != null){
    String priceString = json['Price'].toString();
    if(priceString.contains(".")){
      ratePerMonth = json['Price'];
    }else{
      ratePerMonth = double.parse(priceString);
    }
  }
  modelName = json['model-name'];
}
  @override
  CLocation fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    gpcode = json['Address5'];
    housecode = json['Address4'];
    ownerName = json['City'];
    noOfCustomers = json['noOfCustomers'];
    if(json['Price'] != null){
      String priceString = json['Price'].toString();
      if(priceString.contains(".")){
        ratePerMonth = json['Price'];
      }else{
        ratePerMonth = double.parse(priceString);
      }
    }
    modelName = json['model-name'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['Address5'] = gpcode;
    data['Address4'] = housecode;
    data['City'] = ownerName;
    data['noOfCustomers'] =noOfCustomers ;
    data['Price'] = ratePerMonth;
    data['model-name'] = modelName;
    return data;
  }
  static const model = "c_location";
}
