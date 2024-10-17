import 'package:bloc/bloc.dart';
import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:next_era_collector/toledata/bloc/toledata_event.dart';
import 'package:next_era_collector/toledata/bloc/toledata_state.dart';
import 'package:next_era_collector/toledata/repo/toledata_repo.dart';
import 'package:server_repository/models.dart';

import '../../configs/utils.dart';

class ToleDataBloc extends Bloc<ToleDataEvent, ToleDataState> {
  ToleDataBloc({required this.toleDataRepo}) : super(LoadingState()) {
    on<FetchToleDataEvent>(_fetchData);
    on<LinkNewBuildingEvent>(_linkBuilding);
  }

  final ToleDataRepo toleDataRepo;

  _linkBuilding(LinkNewBuildingEvent event, Emitter<ToleDataState> emit) async {
    try {
      NEQRToleAdd qrToleAdd =
          await toleDataRepo.getQRToleAddData(id: event.ne_tole_id);

      if (event.ne_tole_id != null && event.c_location_id != null) {
        emit(LoadingState());
        ProcessSummary? ps = await toleDataRepo.linkHouseWithTole(
            ne_tole_id: qrToleAdd.neToleID!.id,
            c_location_id: event.c_location_id!);
        if (ps != null) {
          if (!ps.isError!) {
            emit(ToleUpdateSuccessState());
          } else {
            emit(AlertErrorDialogState(
                msg: ps.summary ?? "Failed. Something Went Wrong"));
          }
        } else {
          emit(AlertErrorDialogState(msg: "Failed. Something Went Wrong"));
        }
      } else {
        emit(ScreenDisabledLoadingState());
        if (event.gpCode != null) {
          CLocation loc =
              await toleDataRepo.getLocationFromGPCode(gpcode: event.gpCode!);
          emit(OpenConfirmationDialogueState(
              c_location_id: loc.id!,
              price: loc.ratePerMonth?.toString() ?? "",
              numberOfCustomers: loc.noOfCustomers ?? 0));
        } else if (event.ne_qrlocation_id != null) {
          NEQrLocationAdd qrLocationAdd = await toleDataRepo
              .getQRLocationAddData(id: event.ne_qrlocation_id!);
          if (qrLocationAdd.inProgress!) {
            emit(AlertErrorDialogState(msg: "Location QR in Progress"));
          } else if (!qrLocationAdd.taken! &&
              qrLocationAdd.cLocationID == null) {
            emit(AlertErrorDialogState(msg: "Location QR not linked Yet"));
          } else if (qrLocationAdd.taken! &&
              qrLocationAdd.cLocationID != null) {
            CLocation loc = await toleDataRepo.getLocationByID(
                id: qrLocationAdd.cLocationID!.id!);
            emit(OpenConfirmationDialogueState(
                c_location_id: loc.id!,
                price: loc.ratePerMonth?.toString() ?? "",
                numberOfCustomers: loc.noOfCustomers ?? 0));
          } else {
            emit(AlertErrorDialogState(msg: "SomeThing Went Wrong"));
          }
        } else if (event.ne_qrcustomer_id != null) {
          NEQrCustomerAdd neQrCustomerAdd =
              await toleDataRepo.getQRCustomerData(id: event.ne_qrcustomer_id!);
          if (neQrCustomerAdd.inProgress!) {
            emit(AlertErrorDialogState(msg: "Customer QR in Progress"));
          } else if (!neQrCustomerAdd.taken! &&
              neQrCustomerAdd.cBPartnerID == null) {
            emit(AlertErrorDialogState(msg: "Customer QR not linked Yet"));
          } else if (neQrCustomerAdd.taken! &&
              neQrCustomerAdd.cBPartnerID != null) {
            CBpartner cb = await toleDataRepo.getCustomerFromID(
                id: neQrCustomerAdd.cBPartnerID!.id!);
            CLocation loc =
                await toleDataRepo.getLocationByID(id: cb.cLocationID!.id!);
            emit(OpenConfirmationDialogueState(
                c_location_id: loc.id!,
                price: loc.ratePerMonth?.toString() ?? "",
                numberOfCustomers: loc.noOfCustomers ?? 0));
          } else {
            emit(AlertErrorDialogState(msg: "SomeThing Went Wrong"));
          }
        } else {
          emit(AlertErrorDialogState(msg: "SomeThing Went Wrong"));
        }
      }
    } catch (e) {
      emit(AlertErrorDialogState(msg: e.toString()));
    }
  }

  _fetchData(FetchToleDataEvent event, Emitter<ToleDataState> emit) async {
    try {
      emit(LoadingState());
      NEQRToleAdd qrToleAdd =
          await toleDataRepo.getQRToleAddData(id: event.toleID);
      NETole tole =
          await toleDataRepo.getToleDataFromID(ID: qrToleAdd.neToleID!.id!);
      emit(dataFetchedState(toleData: tole));
    } catch (e) {
      emit(errorState(errorMsg: "Error : " + e.toString()));
      Utils.toastMessage(e.toString());
    }
  }
}
