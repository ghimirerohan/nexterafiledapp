import 'package:bloc/bloc.dart';
import 'package:next_era_collector/addcustomer/bloc/addcustomer_event.dart';
import 'package:next_era_collector/addcustomer/bloc/addcustomer_state.dart';
import 'package:next_era_collector/addcustomer/repo/AddCustomerRepository.dart';
import 'package:next_era_collector/configs/utils.dart';
import 'package:server_repository/api_response.dart';
import 'package:server_repository/models.dart';

class AddCustomerBloc extends Bloc<AddCustomerEvent, AddCustomerState> {
  AddCustomerBloc({required AddCustomerRepository customerRepository})
      : this._customerRepository = customerRepository,
        super(AddCustomerState(
            response: ApiResponse<List<CBPGroup>>.notStarted())) {
    on<FetchCBPGroupEvent>(_fetchCBPGroups);
    on<PostCustomerEvents>(_postCustomer);
    on<ChangeCBPGroupDDEvent>(_changeCBGroupDD);
    on<ChangeHasCardStatus>(_changeHasDataStatus);
    on<OpenCameraForCard>(_captureCard);
  }

  final AddCustomerRepository _customerRepository;

  Future<void> _fetchCBPGroups(
      FetchCBPGroupEvent event, Emitter<AddCustomerState> emit) async {
    try {
      emit(state.copyWith(response: ApiResponse<List<CBPGroup>>.loading()));
      List<CBPGroup> data = await _customerRepository.getCBPGroups();
      Map<String, int> cbGroupIdNameMap = {
        for (CBPGroup item in data) item.englishName!: item.id!
      };
      List<String> ddCBGNames = data.map((item) => item.englishName!).toList();
      emit(state.copyWith(
          response: ApiResponse<List<CBPGroup>>.completed(data),
          cbGroupIdNameMap: cbGroupIdNameMap,
          ddCBGNames: ddCBGNames));
    } catch (e, stacktrace) {
      emit(state.copyWith(
          response: ApiResponse<List<CBPGroup>>.error(e.toString())));
      Utils.toastMessage(e.toString());
    }
  }

  Future<void> _postCustomer(
      PostCustomerEvents event, Emitter<AddCustomerState> emit) async {
    emit(state.copyWith(isPostLoading: true));
    try{
      NECreateCustomer postedData = await _customerRepository.postCustomer(
        billName: event.billName,
        ne_qrcustomeradd_id: event.ne_qrcustomeradd_id,
          cBPGroupID: event.c_bp_group_id,
          cLocationID: event.c_location_id,
          name: event.name,
          phone: event.phone,
          email: event.email,
          housestorynumber: event.housestory,
          taxId: event.taxID,
          hasCard: state.hasCard,
        cardBase64: state.cardBase64
      );
      if (postedData.id != null) {
        emit(state.copyWith(isPosted: true, isPostLoading: false));
      }else{
        emit(state.copyWith(isPosted: false, isPostLoading: false));
        Utils.flushBarErrorMessage("Problem in Server Side Posting Process", event.context);
      }
    }catch(e,stacktrace){
      Utils.flushBarErrorMessage(e.toString(), event.context);
      emit(state.copyWith(isPostLoading: false,isPosted: false));
    }
  }

  void _changeCBGroupDD(
      ChangeCBPGroupDDEvent event, Emitter<AddCustomerState> emit) {
    emit(state.copyWith(selectedDDCBPGroup: event.value));
  }

  void _changeHasDataStatus(ChangeHasCardStatus event ,Emitter<AddCustomerState> emit ){
    emit(state.copyWith(hasCard: event.changedValue));
    // if(state.hasCard){
    //   emit(state.copyWith(hasCard: event.changedValue));
    // }else{
    //   emit(state.copyWith(hasCard: event.changedValue));
    // }
  }

  void _captureCard (OpenCameraForCard event ,Emitter<AddCustomerState> emit ) async{
    try{
      emit(state.copyWith(cardBase64: await _customerRepository.getCardPhoto()));
    }catch(e){
      Utils.toastMessage(e.toString());
    }
  }
}
