import 'package:bloc/bloc.dart';
import 'package:next_era_collector/addnewlocation/repo/AddNewLocationRepo.dart';

import '../../configs/utils.dart';
import 'addlocation_event.dart';
import 'addlocation_state.dart';

class AddLocationBloc extends Bloc<AddLocationEvent, AddLocationState> {
  AddLocationBloc({required this.addnewlocationRepo})
      :super(const AddLocationState()) {
    on<ChangeWardEvent>(_changeWard);
    on<DraftLocationAdditionEvent>(_draftLocation);
  }


  final AddnewlocationRepo addnewlocationRepo;

  void _changeWard(
      ChangeWardEvent event, Emitter<AddLocationState> emit) async {
    emit(state.copyWith(selectedWard: event.ward));
  }

  void _draftLocation(DraftLocationAdditionEvent event , Emitter<AddLocationState> emit) async{
    try{
      emit(state.copyWith(isPostLoading: true));
      bool posted = await addnewlocationRepo.postNewLocation(ne_qrlocationadd_id: event.ne_qrlocationadd_id,
          ward: event.ward, tole: event.tole  ,owner: event.owner , street: event.street);
      if(posted){
        emit(state.copyWith(isPostLoading: false ,isPosted: true));
      }else{
        emit(state.copyWith(isPostLoading: false ,isPosted: false ));
        Utils.toastMessage("Something went wrong");

      }
    }catch(e){
      emit(state.copyWith(isPostLoading: false));
      Utils.toastMessage(e.toString());

    }
  }
}