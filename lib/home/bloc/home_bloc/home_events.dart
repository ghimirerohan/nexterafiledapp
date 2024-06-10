
import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable{
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchTotalCollectionAmount extends HomeEvent{

}

class ChangeSelectionEvent extends HomeEvent{
  final int selection;

  const ChangeSelectionEvent({required this.selection});

  @override
  List<Object> get props => [selection];
}

class QRScannedEvent extends HomeEvent{
  final bool isQRValid;
  final bool isDirectPayment;
  final String qrData;
   const QRScannedEvent({required this.qrData, required this.isQRValid , required this.isDirectPayment});
  @override
  List<Object> get props => [isQRValid,qrData,isDirectPayment];

}

class LogOutEvent extends HomeEvent{}

class LocationAddQRScannedEvent extends HomeEvent{
  final String id;

  const LocationAddQRScannedEvent({required this.id});

  @override
  List<Object> get props => [id];
}