import 'package:bloc/bloc.dart';
import 'package:next_era_collector/addpayment/bloc/addpayment_event.dart';
import 'package:next_era_collector/addpayment/bloc/addpayment_state.dart';
import 'package:server_repository/api_response.dart';
import 'package:server_repository/models.dart';

import '../../configs/utils.dart';
import '../repo/AddPaymentRepo.dart';

class AddPaymentBloc extends Bloc<AddPaymentEvent, AddPaymentState> {
  AddPaymentBloc({required AddPaymentRepo paymentRepository})
      : this._paymentRepository = paymentRepository,
        super(AddPaymentState(
            response: ApiResponse<List<CPeriod>>.notStarted())) {
    on<FetchAddPaymentData>(_fetchPayData);
    on<ChangeDDToPeriod>(_changeDDPeriod);
    on<PostPaymentData>(_postPayment);
  }

  final AddPaymentRepo _paymentRepository;

  Future<void> _fetchPayData(
      FetchAddPaymentData event, Emitter<AddPaymentState> emit) async {
    try {
      emit(state.copyWith(response: ApiResponse<List<CPeriod>>.loading()));
      List<CPeriod> data = await _paymentRepository.getCurrentPeriod(event.c_bpartner_id.currentFromPeriodID!.id!);
      Map<String, int> cPeriodIdNameMap = {
        for (CPeriod item in data) item.name!: item.id!
      };
      List<String> ddCPeriodNames = data.map((item) => item.name!).toList();
      emit(state.copyWith(selectedDDCPeriod: data[0],
          response: ApiResponse<List<CPeriod>>.completed(data),
          cperiodIdNameMap: cPeriodIdNameMap,
          ddCperiodNames: ddCPeriodNames));
    } catch (e, stacktrace) {
      emit(state.copyWith(
          response: ApiResponse<List<CPeriod>>.error(e.toString())));
      Utils.toastMessage(e.toString());
    }
  }

  void _changeDDPeriod(ChangeDDToPeriod event , Emitter<AddPaymentState> emit){
    emit(state.copyWith(selectedDDCPeriod: event.period));
  }

  Future<void> _postPayment(PostPaymentData event , Emitter<AddPaymentState> emit) async{
    emit(state.copyWith(isPostLoading: true));

    try{
      CPayment postedData = await _paymentRepository.postPayment(
          c_bpartner_id: event.c_bpartner_id,
          fromPeriodId: event.fromPeriodID,
          toPeriodId: event.toPeriodID,
          payAmt: event.payAmt);
      if (postedData.id != null) {
        emit(state.copyWith(isPosted: true, isPostLoading: false));
      }else{
        Utils.flushBarErrorMessage("Problem in Server Side Posting Process", event.context);
      }
    }catch(e,stacktrace){
      Utils.flushBarErrorMessage(e.toString(), event.context);
      emit(state.copyWith(isPostLoading: false));
    }

  }
}
