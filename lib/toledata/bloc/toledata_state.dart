
import 'package:server_repository/models.dart';

abstract class ToleDataState{}

class LoadingState implements ToleDataState{}

class ScreenDisabledLoadingState implements ToleDataState{}

class dataFetchedState implements ToleDataState{
  final NETole toleData;

  dataFetchedState({required this.toleData});
}

class errorState implements ToleDataState{
  final String errorMsg;
  errorState({required this.errorMsg});
}

class AlertErrorDialogState implements ToleDataState{
  final String msg;
  AlertErrorDialogState({required this.msg});
}

class OpenConfirmationDialogueState implements ToleDataState{
  final int c_location_id;
  final int numberOfCustomers;
  final String price;
  OpenConfirmationDialogueState({required this.c_location_id , required this.price , required this.numberOfCustomers});
}

class ToleUpdateSuccessState implements ToleDataState{}