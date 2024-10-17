
abstract class ToleDataEvent{}

class FetchToleDataEvent extends ToleDataEvent{
  final int toleID;
  FetchToleDataEvent({required this.toleID});
}

class LinkNewBuildingEvent extends ToleDataEvent{
  final int? ne_tole_id;
  final int? c_location_id;
  final int? ne_qrlocation_id;
  final String? gpCode;
  final int? ne_qrcustomer_id;
  LinkNewBuildingEvent({this.ne_tole_id,this.c_location_id, this.ne_qrlocation_id , this.gpCode,this.ne_qrcustomer_id});
}