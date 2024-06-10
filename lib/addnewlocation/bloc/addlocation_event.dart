

abstract class AddLocationEvent{}

class ChangeWardEvent extends AddLocationEvent{
  String ward;
  ChangeWardEvent({required this.ward});
}

class DraftLocationAdditionEvent extends AddLocationEvent{

  final int ne_qrlocationadd_id;
  final String ward;
  final String tole;
  final String? street;
  final String? owner;

  DraftLocationAdditionEvent({required this.ne_qrlocationadd_id , required this.ward,
  required this.tole , this.owner  ,this.street});

}