import 'package:bloc/bloc.dart';
import 'package:next_era_collector/configs/utils.dart';
import 'package:next_era_collector/custlist/bloc/custlist_events.dart';
import 'package:next_era_collector/custlist/bloc/custlist_states.dart';
import 'package:next_era_collector/custlist/custrepo/CustListRepo.dart';
import 'package:server_repository/server_repository.dart';

class CustListBloc extends Bloc<CustListEvent, CustListState> {
  CustListBloc({required CustListRepo repo})
      : this._repo = repo,
        super(CustListState(
            response: ApiResponse<List<CBpartner>>.notStarted())) {
    on<FetchDataEvent>(_fetchData);
    on<OpenPaymentEvent>(_openPayment);
    on<AddCustEvent>(_addCust);
    on<UpdateOwnerName>(_updateOwnerName);
    on<QRScannedCustEvent>(_qrscanned);
  }

  final CustListRepo _repo;

  Future<void> _fetchData(
      FetchDataEvent event, Emitter<CustListState> emit) async {
    try {
      emit(state.copyWith(
          response: ApiResponse<List<CBpartner>>.loading(),
          status: CustListStatus.none));
      CLocation location = (await _repo.getLocationFromGPCode(event.GPCode))!;
      List<CBpartner>? customers = await _repo.getCustomersList(location.id!);
      CPeriod currentPeriod = await _repo.getCurrentPeriod();
      emit(state.copyWith(isOnlyDataCollector: await _repo.getisDataCollector(),
          response: ApiResponse<List<CBpartner>>.completed(customers ?? []),
          status: CustListStatus.none,
          c_location: location,
          currenPeriod: currentPeriod));
    } catch (e, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(
          status: CustListStatus.error,
          response: ApiResponse<List<CBpartner>>.error(e.toString())));
    }
  }

  Future<void> _openPayment(
      OpenPaymentEvent event, Emitter<CustListState> emit) async {
    emit(state.copyWith(
        status: CustListStatus.openPayment, selectedPartner: event.cBpartner));
  }

  Future<void> _addCust(AddCustEvent event, Emitter<CustListState> emit) async {
    emit(state.copyWith(status: CustListStatus.addNew));
    emit(state.copyWith(status: CustListStatus.none));
  }

  Future<void> _updateOwnerName(
      UpdateOwnerName event, Emitter<CustListState> emit) async {
    try {
      emit(state.copyWith(isUpdateOwnerNameLoading: true));
      CLocation locationToUpdate = state.c_location!;
      locationToUpdate.ownerName = event.name;
      CLocation? updated = await _repo.updateLocation(locationToUpdate);
      if (updated != null) {
        Utils.toastMessage("Updated Owner Name Successfully");
        emit(
            state.copyWith(
                c_location: updated, isUpdateOwnerNameLoading: false));
      }
    }catch(e , stacktrace){
      Utils.toastMessage(e.toString());
      emit(state.copyWith(isUpdateOwnerNameLoading: false));
    }

  }

  Future<void> _qrscanned(QRScannedCustEvent event , Emitter<CustListState> emit) async{
    try{
      NEQrCustomerAdd qrCustomerAdd = await _repo.getQRCustomerData(event.ne_qrcustomeradd_id);
      if(qrCustomerAdd.inProgress!){
        emit(state.copyWith(isAddCustomerInProgressorTaken: true , customerAddMsg: "Customer Qr Data in progress"));
      }else if(qrCustomerAdd.taken!){
        emit(state.copyWith(isAddCustomerInProgressorTaken: true , customerAddMsg: "Customer Qr Data Already Taken"));
      }else{
        emit(state.copyWith(status: CustListStatus.addNew , isAddCustomerInProgressorTaken: false , ne_qrcustomeradd_id: qrCustomerAdd.id!));
      }

      emit(state.copyWith(isAddCustomerInProgressorTaken: false , status: CustListStatus.none));

    }catch(e , stacktrace){
      Utils.toastMessage(e.toString());
    }
  }
}
