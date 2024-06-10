
import 'package:equatable/equatable.dart';
import 'package:next_era_collector/custlist/custrepo/CustListRepo.dart';
import 'package:server_repository/models.dart';

abstract class CustListEvent {
  const CustListEvent();
}

class FetchDataEvent implements CustListEvent{
  final String GPCode;

  const FetchDataEvent({
    required this.GPCode
});
}

class AddCustEvent implements CustListEvent{
  final CustListStatus status;

  const AddCustEvent({
    this.status = CustListStatus.addNew
});

}

class UpdateOwnerName implements CustListEvent{
  final String name;

  const UpdateOwnerName({
    required this.name
  });

}

class OpenPaymentEvent implements CustListEvent{
  final CustListStatus status;
  final CBpartner cBpartner;

  const OpenPaymentEvent({
    this.status = CustListStatus.openPayment,
    required this.cBpartner
  });
}

class QRScannedCustEvent implements CustListEvent{
  final int ne_qrcustomeradd_id ;
  QRScannedCustEvent({ required this.ne_qrcustomeradd_id});
}