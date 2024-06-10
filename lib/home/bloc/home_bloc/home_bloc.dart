import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:next_era_collector/home/bloc/home_bloc/home_events.dart';
import 'package:next_era_collector/home/bloc/home_bloc/home_states.dart';
import 'package:next_era_collector/home/repository/home_reposioty.dart';
import 'package:server_repository/models.dart';

import '../../../configs/utils.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
      {required this.authenticationRepository, required this.homeRepository})
      : super(const HomeState()) {
    on<ChangeSelectionEvent>(_onChangeSelection);
    on<QRScannedEvent>(_openQRScanner);
    on<LogOutEvent>(_logOut);
    on<FetchTotalCollectionAmount>(_fetchTodayAmont);
    on<LocationAddQRScannedEvent>(_locationAddFunction);
  }

  final HomeRepository homeRepository;
  final AuthenticationRepository authenticationRepository;

  Future<void> _fetchTodayAmont(
      FetchTotalCollectionAmount event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isTotalAmountLoading: true));
    int totalAmt = await homeRepository.getTodayTotalCollectionOfCollector();
    emit(state.copyWith(isTotalAmountLoading: false, totalCollected: totalAmt));
  }

  void _onChangeSelection(ChangeSelectionEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(selection: event.selection));
  }

  void _openQRScanner(QRScannedEvent event, Emitter<HomeState> emit) async {
    try {
      // emit(state.copyWith(isLoading: true));
      if (event.isDirectPayment) {
        String value =
            event.qrData.substring(event.qrData.lastIndexOf("=") + 1);
        NEQrCustomerAdd qrCustomerAdd =
            await homeRepository.getQRCustomerData(int.parse(value));
        if (qrCustomerAdd.inProgress!) {
          emit(state.copyWith(
              isQRValid: false,
              newLocationAddInProgressOrTaken: true,
              locationAddMsg: "Customer QR Data in Progress"));
        } else if (qrCustomerAdd.cBPartnerID == null) {
          emit(state.copyWith(
              isQRValid: false,
              newLocationAddInProgressOrTaken: true,
              locationAddMsg: "Customer QR Data Not linked yet"));
        } else {
          CBpartner? custModel = await homeRepository
              .getCustomerFromID(qrCustomerAdd.cBPartnerID!.id!);
          emit(state.copyWith(
              qrData: event.qrData,
              isQRValid: event.isQRValid,
              isDirectPayment: true,
              custModel: custModel));
        }
      } else {
        String gpLink = "";
        String gpcode = "";
        if (event.qrData.contains("https://www.google.com/maps/place/")) {
          gpLink = event.qrData.substring(0, event.qrData.length - 1);
          gpcode = gpLink.substring(gpLink.lastIndexOf('/') + 1);
          emit(state.copyWith(
              newLocationAddInProgressOrTaken: false,
              isAddLocationOkay: false,
              qrData: gpcode,
              isQRValid: true,
              isDirectPayment: false));
        } else if (event.qrData
            .contains("https://nexteraportal.com/location")) {
          String dataFinal =
              event.qrData.substring(event.qrData.lastIndexOf("=") + 1);

          NEQrLocationAdd qrLocationAdd =
              await homeRepository.getQRLocationData(int.parse(dataFinal));
          if (qrLocationAdd.inProgress!) {
            emit(state.copyWith(
                isQRValid: false,
                newLocationAddInProgressOrTaken: true,
                locationAddMsg: "Location QR Data in Progress"));
          } else if (qrLocationAdd.cLocationID == null) {
            emit(state.copyWith(
                isQRValid: false,
                newLocationAddInProgressOrTaken: true,
                locationAddMsg: "Location QR Data Not linked yet"));
          } else {
            CLocation location = await homeRepository
                .getLocationFromID(qrLocationAdd.cLocationID!.id!);
            gpcode = location.gpcode!;
            emit(state.copyWith(
                qrData: gpcode,
                isQRValid: event.isQRValid,
                isDirectPayment: false));
          }
        }
        emit(state.copyWith(
          newLocationAddInProgressOrTaken: false,
            isAddLocationOkay: false,
            qrData: gpcode,
            isQRValid: false,
            isDirectPayment: false));
      }
    } catch (e, stacktrace) {
      Utils.toastMessage(e.toString());
    }
  }

  void _logOut(LogOutEvent event, Emitter<HomeState> emit) async {
    await authenticationRepository.logOut();
    emit(state.copyWith(logOutRequested: true));
  }

  void _locationAddFunction(
      LocationAddQRScannedEvent event, Emitter<HomeState> emit) async {
    try {
      int ID = int.parse(event.id);
      NEQrLocationAdd neQrLocationAdd =
          await homeRepository.getQRLocationData(ID);
      if (neQrLocationAdd.inProgress!) {
        emit(state.copyWith(
          isQRValid: false,
            newLocationAddInProgressOrTaken: true,
            locationAddMsg: "Location Addition in Progress"));
      }
      if (neQrLocationAdd.taken!) {
        emit(state.copyWith(
            isQRValid: false,
            newLocationAddInProgressOrTaken: true,
            locationAddMsg: "Location Already In Use"));
      }
      if (!neQrLocationAdd.inProgress! && !neQrLocationAdd.taken!) {
        emit(state.copyWith(
            isQRValid: false,
            isAddLocationOkay: true,
            newLocationAddInProgressOrTaken: false,
            locationAddMsg: neQrLocationAdd.id!.toString()));
      }

      emit(state.copyWith(
          newLocationAddInProgressOrTaken: false,
          isAddLocationOkay: false,
          isQRValid: false,
          isDirectPayment: false));
    } catch (e) {
      Utils.toastMessage(e.toString());
    }
  }
}
