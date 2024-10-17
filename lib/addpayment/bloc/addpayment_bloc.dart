import 'package:bloc/bloc.dart';
import 'package:idempiere_rest/idempiere_rest.dart';
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
    on<ChangeDDFromPeriod>(_changeDDFromPeriod);
    on<PostPaymentData>(_postPayment);
    on<UpdatePanNoandBusinessNo>(_updatePanBusinessNo);
    on<OpenAddPanNoBusinessNo>(_openAddPanBusinessNo);
    on<UpdateRateEvent>(_updateCustomerRate);
    on<UpdateQREvent>(_updateCustomerQR);
    on<ConfirmUpdateQREvent>(_confirmQRUpdate);
    on<UpdatePhoneEvent>(_updatePhone);
    on<OpenCustomerReportingForm>(_openCustomerReportingForm);
    on<ReportCustomerAsDefaulter>(_reportCustomerAsDefaulter);
    on<ChangeDiscountEnabledEvent>(_changeDiscountEnabled);
  }

  final AddPaymentRepo _paymentRepository;


  _changeDiscountEnabled(ChangeDiscountEnabledEvent event , Emitter<AddPaymentState> emit) async{
    emit(state.copyWith(isDiscountEnabled:  event.enableDiscount));
  }

  _reportCustomerAsDefaulter(ReportCustomerAsDefaulter event, Emitter<AddPaymentState> emit) async {
    emit(state.copyWith(isPostLoading: true));
    try{
      ProcessSummary? ps = await
      _paymentRepository.postReportCustomerAsDefaulter(
          c_bpartner_id: event.c_bpartner_id,
          reason: event.reason_type,
          remark: event.remark);
      if(ps != null){
        if(!ps!.isError!){
          emit(state.copyWith(isPostLoading: false , isCustomerReported: true));
        }else{
          emit(state.copyWith(isPostLoading: false , isCustomerReported: false));
        }
      }else{
        emit(state.copyWith(isPostLoading: false , isCustomerReported: false));
      }

    }catch(e){
      emit(state.copyWith(isPostLoading: false));
      Utils.toastMessage(e.toString());
    }
  }

  _openCustomerReportingForm(OpenCustomerReportingForm event, Emitter<AddPaymentState> emit) async {
    emit(state.copyWith(isReportingCustomer: event.isOpen));
  }

  Future<void> _updatePhone (
      UpdatePhoneEvent event, Emitter<AddPaymentState> emit) async {

    try{
      emit(state.copyWith(isPostLoading: true));
      ProcessSummary? ps = await _paymentRepository.updateCustomerPhone(
          c_bpartner_id: event.c_bpartner_id, phone : event.phone);
      if(ps != null){
        if(!ps.isError!){
          emit(state.copyWith(isPostLoading: false));
          emit(state.copyWith(isCustomerPhoneUpdated: true ,
              isCustomerPhoneUpdateFailed: false,processMsg:ps.summary ?? "Sucessed" ));
        }else{
          emit(state.copyWith(isPostLoading: false));
          emit(state.copyWith(isCustomerPhoneUpdated: false ,isCustomerPhoneUpdateFailed: true,
              processMsg: ps?.summary ?? "Update Failed" ));
        }
      }else{
        emit(state.copyWith(isPostLoading: false));
        emit(state.copyWith(isCustomerPhoneUpdated: false ,isCustomerPhoneUpdateFailed: true,
            processMsg: ps?.summary ?? "Update Failed" ));
      }
    }catch(e){
      emit(state.copyWith(isPostLoading: false));
      Utils.toastMessage(e.toString());
    }
    emit(state.copyWith(isPostLoading: false , isCustomerPhoneUpdated: false ,isCustomerPhoneUpdateFailed: false));
  }

  Future<void> _confirmQRUpdate(
      ConfirmUpdateQREvent event, Emitter<AddPaymentState> emit) async {
    try {
      emit(state.copyWith(isPostLoading: true));
      ProcessSummary? ps = await _paymentRepository.updateCustomerQR(
          c_bpartner_id: event.c_bpartner_id,
          ne_qrcustomer_add_ID: event.ne_qrcustomeradd_id);
      if (ps != null) {
        if (!ps.isError!) {
          emit(state.copyWith(isPostLoading: false));
          emit(state.copyWith(isCustomerQRUpdated: true,
              isCustomerQRUpdateFailed: false,
              processMsg: ps.summary ?? "Sucessed"));
        } else {
          emit(state.copyWith(isPostLoading: false));
          emit(state.copyWith(isCustomerQRUpdated: false,
              isCustomerQRUpdateFailed: true,
              processMsg: ps?.summary ?? "Update Failed"));
        }
      } else {
        emit(state.copyWith(isPostLoading: false));
        emit(state.copyWith(
            isCustomerQRUpdated: false, isCustomerQRUpdateFailed: true,
            processMsg: ps?.summary ?? "Update Failed"));
      }
    } catch (e) {
      emit(state.copyWith(isPostLoading: false));
      Utils.toastMessage(e.toString());
    }
    emit(state.copyWith(isPostLoading: false , isCustomerQRUpdated: false ,isCustomerQRUpdateFailed: false));
  }

  Future<void> _updateCustomerQR(
      UpdateQREvent event, Emitter<AddPaymentState> emit) async {
    try {
      emit(state.copyWith(isPostLoading: true));
      NEQrCustomerAdd qrCustomerAdd = await _paymentRepository
          .getQRCustomerData(event.ne_qrcustomeradd_id);
      if (qrCustomerAdd.taken! || qrCustomerAdd.inProgress! ||
          qrCustomerAdd.cBPartnerID != null) {
        emit(state.copyWith(isPostLoading: false,
            isCustomerQRUpdateFailed: true,
            processMsg: "QR Already In Use. Use New QR"
        ));
      } else {
        emit(state.copyWith(isPostLoading: false,askQRToUpdate: true));
      }
    }catch(e){
      emit(state.copyWith(isPostLoading: false));
      Utils.toastMessage(e.toString());
    }
    emit(state.copyWith(isPostLoading: false , askQRToUpdate: false , isCustomerQRUpdateFailed : false));
  }

  Future<void> _updateCustomerRate(
      UpdateRateEvent event, Emitter<AddPaymentState> emit) async {
    try{
      emit(state.copyWith(isPostLoading: true));
      ProcessSummary? ps = await _paymentRepository.updateCustomerRatePanAndBusinessNo(
          c_bpartner_id: event.c_bpartner_id, rate: event.rate,
        businessNo: event.businessNo , pan: event.pan
      );
      if(ps != null){
        if(!ps.isError!){
          emit(state.copyWith(isPostLoading: false));
          emit(state.copyWith(isCustomerRateUpdated: true ,
              isCustomerRateUpdateFailed: false,processMsg:"All Updated"));
        }else{
          emit(state.copyWith(isPostLoading: false));
          emit(state.copyWith(isCustomerRateUpdated: false ,isCustomerRateUpdateFailed: true,
              processMsg: ps?.summary ?? "Update Failed" ));
        }
      }else{
        emit(state.copyWith(isPostLoading: false));
        emit(state.copyWith(isCustomerRateUpdated: false ,isCustomerRateUpdateFailed: true,
            processMsg: ps?.summary ?? "Update Failed" ));
      }
    }catch(e){
      emit(state.copyWith(isPostLoading: false));
      Utils.toastMessage(e.toString());
    }
    emit(state.copyWith(isPostLoading: false , isCustomerRateUpdated: false ,isCustomerRateUpdateFailed: false));
  }
  Future<void> _fetchPayData(
      FetchAddPaymentData event, Emitter<AddPaymentState> emit) async {
    try {
      emit(state.copyWith(response: ApiResponse<List<CPeriod>>.loading()));
      // List<CPeriod> data = await _paymentRepository.getCurrentPeriod(event.c_bpartner_id.currentFromPeriodID!.id!);
      List<CPeriod> data = await _paymentRepository.getAllInitialPeriods();

      CPeriod? currentPeriod = data.singleWhere((cp) => cp.id! == event.c_bpartner_id.currentFromPeriodID!.id!);
      Map<String, int> cPeriodIdNameMap = {
        for (CPeriod item in data) item.name!: item.id!
      };
      List<String> ddCPeriodNames = data.map((item) => item.name!).toList();
      emit(state.copyWith(selectedDDCPeriod: currentPeriod ?? data[0],
          selectedDDFromPeriod: currentPeriod ?? data[0],
          response: ApiResponse<List<CPeriod>>.completed(data),
          cperiodIdNameMap: cPeriodIdNameMap,
          ddCperiodNames: ddCPeriodNames,
        model: event.c_bpartner_id,
        isUserAdmin: await _paymentRepository.getIsUserAdmin()
      ));
    } catch (e, stacktrace) {
      emit(state.copyWith(
          response: ApiResponse<List<CPeriod>>.error(e.toString())));
      Utils.toastMessage(e.toString());
    }
  }

  void _changeDDPeriod(ChangeDDToPeriod event , Emitter<AddPaymentState> emit){
    emit(state.copyWith(selectedDDCPeriod: event.period));
  }

  void _changeDDFromPeriod(ChangeDDFromPeriod event , Emitter<AddPaymentState> emit){
    emit(state.copyWith(selectedDDFromPeriod: event.period));
  }

  Future<void> _postPayment(PostPaymentData event , Emitter<AddPaymentState> emit) async{
    emit(state.copyWith(isPostLoading: true));

    try{
      CPayment postedData = await _paymentRepository.postPayment(
          c_bpartner_id: event.c_bpartner_id,
          fromPeriodId: event.fromPeriodID,
          toPeriodId: event.toPeriodID,
          payAmt: event.payAmt,
        isDiscountEnabled: event.isDiscountEnabled
      );
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

  Future<void> _updatePanBusinessNo(UpdatePanNoandBusinessNo event , Emitter<AddPaymentState> emit) async{
   try{
     emit(state.copyWith(isAddPanBusinessLoading: true));
     CBpartner? updated = await _paymentRepository.
     putCustomerForUpdate(event.businessNo, event.panNo,event.phoneNo, event.model);
     if(updated == null){
       Utils.toastMessage("Something went wrong");
     }else{
       if(event.businessNo != null){
         state.model?.businessNo = event.businessNo;
       }
       if(event.panNo != null){
         state.model?.taxId = event.panNo;
       }
       if(event.phoneNo != null){
         state.model?.phone = event.phoneNo;
       }
       emit(state.copyWith(isAddPanBusinessLoading: false,isAddPanBusinessNeeded: false , model: state.model));
     }
     // if(event.model.businessNo == null && event.businessNo != null
     //     && event.model.taxId == null && event.panNo != null){
     //   CBpartner? updated = await _paymentRepository.
     //   putCustomerForUpdate(event.businessNo, event.panNo,event.phoneNo, event.model);
     //   emit(state.copyWith(isAddPanBusinessLoading: false));
     //   if(updated == null){
     //     Utils.toastMessage("Something went wrong");
     //   }else{
     //     emit(state.copyWith(isAddPanBusinessNeeded: false));
     //   }
     // }
     // else if(event.model.businessNo == null && event.businessNo != null){
     //   CBpartner? updated = await _paymentRepository.
     //   putCustomerForUpdate(event.businessNo,null ,event.phoneNo, event.model);
     //   emit(state.copyWith(isAddPanBusinessLoading: false));
     //   if(updated == null){
     //     Utils.toastMessage("Something went wrong");
     //   }else{
     //     emit(state.copyWith(isAddPanBusinessNeeded: false));
     //   }
     // }
     // else if(event.model.taxId == null && event.panNo != null){
     //   CBpartner? updated = await _paymentRepository.
     //   putCustomerForUpdate(null, event.panNo ,event.phoneNo, event.model);
     //   emit(state.copyWith(isAddPanBusinessLoading: false));
     //   if(updated == null){
     //     Utils.toastMessage("Something went wrong");
     //   }else{
     //     emit(state.copyWith(isAddPanBusinessNeeded: false));
     //   }
     // }
     // else{
     //   emit(state.copyWith(isAddPanBusinessLoading: false , isAddPanBusinessNeeded: false));
     // }
   }catch(e){
     emit(state.copyWith(isAddPanBusinessLoading: false));
     Utils.toastMessage(e.toString());
   }
  }

  Future<void> _openAddPanBusinessNo(OpenAddPanNoBusinessNo event ,  Emitter<AddPaymentState> emit) async{
    emit(state.copyWith(isAddPanBusinessNeeded: true , isUserAdmin: await _paymentRepository.getIsUserAdmin() ));
  }
}
