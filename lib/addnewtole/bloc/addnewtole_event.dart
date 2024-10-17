part of 'addnewtole_bloc.dart';



abstract class AddnewtoleEvent{}

class ChangeWardEvent extends AddnewtoleEvent{
  String ward;
  ChangeWardEvent({required this.ward});
}

class DraftToleAdditionEvent extends AddnewtoleEvent{

  final int ne_qrtoleadd_id;
  final String ward;
  final String toleName;
  final String toleHeadName;
  final String toleHeadPhone;

  DraftToleAdditionEvent({required this.ne_qrtoleadd_id , required this.ward,
    required this.toleName , required this.toleHeadName ,required this.toleHeadPhone});

}

