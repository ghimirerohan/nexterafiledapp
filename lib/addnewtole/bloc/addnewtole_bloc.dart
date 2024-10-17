import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:next_era_collector/addnewtole/repo/AddNewToleRepo.dart';
import 'package:equatable/equatable.dart';

import '../../configs/utils.dart';


part 'addnewtole_event.dart';
part 'addnewtole_state.dart';

class AddNewToleBloc extends Bloc<AddnewtoleEvent, AddnewtoleState> {
  AddNewToleBloc({required this.addnewtoleRepo})
      :super(const AddnewtoleState()) {
    on<ChangeWardEvent>(_changeWard);
    on<DraftToleAdditionEvent>(_draftTole);
  }


  final AddNewToleRepo addnewtoleRepo;

  void _changeWard(
      ChangeWardEvent event, Emitter<AddnewtoleState> emit) async {
    emit(state.copyWith(selectedWard: event.ward));
  }

  void _draftTole(DraftToleAdditionEvent event , Emitter<AddnewtoleState> emit) async{
    try{
      emit(state.copyWith(isPostLoading: true));
      bool posted = await addnewtoleRepo.postNewTole(
          ne_qrtole_add_id: event.ne_qrtoleadd_id, toleName: event.toleName,
          toleHeadName: event.toleHeadName, toleHeadPhoneNumber: event.toleHeadPhone,
          ward: event.ward);
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
