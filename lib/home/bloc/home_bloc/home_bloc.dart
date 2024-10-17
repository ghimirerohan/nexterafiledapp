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
    on<ToleAddQRScannedEvent>(_toleAddFunction);
    on<OpenCustListAfterDirectPayScanned>(_openCustList);
    on<OpenDirectAfterDirectPayScanned>(_openDirectPay);
    on<LocationOpenFromCode>(_openLocationFromCode);
    on<CustomerOpenFromCode>(_openCustomerFromCode);
  }

  final HomeRepository homeRepository;
  final AuthenticationRepository authenticationRepository;

  Future<void>_openCustomerFromCode(CustomerOpenFromCode event ,  Emitter<HomeState> emit) async{
    try{
      emit(state.copyWith(
          isLoading: true));
      NEQrCustomerAdd qrCustomerAdd =
      await homeRepository.getQRCustomerData(event.customerQRCode);
      if (qrCustomerAdd.inProgress!) {
        emit(state.copyWith(
            isLoading: false,
            isQRValid: false,
            newLocationAddInProgressOrTaken: true,
            locationAddMsg: "Customer QR Data in Progress"));
      } else if (qrCustomerAdd.cBPartnerID == null) {
        emit(state.copyWith(
            isLoading: false,
            isQRValid: false,
            newLocationAddInProgressOrTaken: true,
            locationAddMsg: "Customer QR Data Not linked yet"));
      } else {
        CBpartner? custModel = await homeRepository
            .getCustomerFromID(qrCustomerAdd.cBPartnerID!.id!);
        CLocation location = await homeRepository
            .getLocationFromID(custModel!.cLocationID!.id!);
        emit(state.copyWith(
            isLoading: false,
            qrData: location.gpcode,
            isQRValid: false,
            isDirectPayment: true,
            custModel: custModel,
            optionBeforeDirectPay: true));
      }
      emit(
        state.copyWith(
            isLoading: false,
            isQRValid: false,
            newLocationAddInProgressOrTaken: false,
            isDirectPayment: false),
      );
    } catch (e, stacktrace) {
      emit(
        state.copyWith(
            isLoading: false,
            isQRValid: false,
            newLocationAddInProgressOrTaken: false,
            isDirectPayment: false),
      );
      Utils.toastMessage(e.toString());
    }
  }

  Future<void>_openLocationFromCode(LocationOpenFromCode event ,  Emitter<HomeState> emit) async{
    emit(state.copyWith(
        isLoading: false,
        qrData: event.locationCode,
        isQRValid: true,
        isDirectPayment: false));
  }

  Future<void> _openCustList(OpenCustListAfterDirectPayScanned event ,  Emitter<HomeState> emit) async{
    emit(state.copyWith(
      isLoading: false,));
    emit(state.copyWith(
        isLoading: false,
        isQRValid: true,
        isDirectPayment: false,
        optionBeforeDirectPay: false));

  }

  Future<void> _openDirectPay(OpenDirectAfterDirectPayScanned event ,  Emitter<HomeState> emit) async{

    emit(state.copyWith(
        isLoading: false,));
    emit(state.copyWith(
        isLoading: false,
        isQRValid: true,
        isDirectPayment: true,
        optionBeforeDirectPay: false));


  }

  Future<void> _fetchTodayAmont(
      FetchTotalCollectionAmount event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        isAddLocationOkay: false,
        newLocationAddInProgressOrTaken: false,
        isQRValid: false,
        isDirectPayment: false,
        isTotalAmountLoading: true));
    bool isUserADataCollector =
        await authenticationRepository.isUserADataCollector();
    String? todayandtotalcustcreated = await homeRepository
        .getNoOfCreateCustomerByCollectorTodayandTotalString();
    emit(state.copyWith(
        isTotalAmountLoading: false,
        todayTotalCustCreatedString: todayandtotalcustcreated,
        isDatacollector: isUserADataCollector));
  }

  void _onChangeSelection(ChangeSelectionEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(selection: event.selection));
  }

  void _openQRScanner(QRScannedEvent event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(
        isLoading: true,
        newLocationAddInProgressOrTaken: false,
      ));
      if (event.isDirectPayment) {
        String value =
            event.qrData.substring(event.qrData.lastIndexOf("=") + 1);
        NEQrCustomerAdd qrCustomerAdd =
            await homeRepository.getQRCustomerData(int.parse(value));
        if (qrCustomerAdd.inProgress!) {
          emit(state.copyWith(
              isLoading: false,
              isQRValid: false,
              newLocationAddInProgressOrTaken: true,
              locationAddMsg: "Customer QR Data in Progress"));
        } else if (qrCustomerAdd.cBPartnerID == null) {
          emit(state.copyWith(
              isLoading: false,
              isQRValid: false,
              newLocationAddInProgressOrTaken: true,
              locationAddMsg: "Customer QR Data Not linked yet"));
        } else {
          CBpartner? custModel = await homeRepository
              .getCustomerFromID(qrCustomerAdd.cBPartnerID!.id!);
          CLocation location = await homeRepository
              .getLocationFromID(custModel!.cLocationID!.id!);
          emit(state.copyWith(
              isLoading: false,
              qrData: location.gpcode,
              isQRValid: false,
              isDirectPayment: true,
              custModel: custModel,
          optionBeforeDirectPay: true));
        }
      } else {
        String gpLink = "";
        String gpcode = "";
        if (event.qrData.contains("https://www.google.com/maps/place/")) {
          gpLink = event.qrData.substring(0, event.qrData.length - 1);
          gpcode = gpLink.substring(gpLink.lastIndexOf('/') + 1);
          emit(state.copyWith(
              isLoading: false,
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
                isLoading: false,
                isQRValid: false,
                newLocationAddInProgressOrTaken: true,
                locationAddMsg: "Location QR Data in Progress"));
          } else if (qrLocationAdd.cLocationID == null) {
            emit(state.copyWith(
                isLoading: false,
                isQRValid: false,
                newLocationAddInProgressOrTaken: true,
                locationAddMsg: "Location QR Data Not linked yet"));
          } else {
            CLocation location = await homeRepository
                .getLocationFromID(qrLocationAdd.cLocationID!.id!);
            gpcode = location.gpcode!;
            emit(state.copyWith(
                isLoading: false,
                qrData: gpcode,
                isQRValid: event.isQRValid,
                isDirectPayment: false));
          }
        }
        else if (event.qrData
            .contains("https://nexteraportal.com/tole/?id=")) {
          String dataFinal =
          event.qrData.substring(event.qrData.lastIndexOf("=") + 1);

          NEQRToleAdd qrToleAdd=
          await homeRepository.getQRToleData(int.parse(dataFinal));
          if (qrToleAdd.inProgress!) {
            emit(state.copyWith(
                isLoading: false,
                isQRValid: false,
                newLocationAddInProgressOrTaken: true,
                locationAddMsg: "Tole QR Data in Progress"));
          } else if (qrToleAdd.neToleID == null) {
            emit(state.copyWith(
                isLoading: false,
                isQRValid: false,
                newLocationAddInProgressOrTaken: true,
                locationAddMsg: "Tole QR Data Not linked yet"));
          } else {
            NETole tole = await homeRepository
                .getToleFromID(qrToleAdd.neToleID!.id!);
            emit(state.copyWith(
                isLoading: false,
                qrData: "Tole:${qrToleAdd.id!}",
                isQRValid: event.isQRValid,
                isDirectPayment: false));
          }
        }
      }

      emit(
        state.copyWith(
            isLoading: false,
            isQRValid: false,
            newLocationAddInProgressOrTaken: false,
            isDirectPayment: false),
      );
    } catch (e, stacktrace) {
      emit(
        state.copyWith(
            isLoading: false,
            isQRValid: false,
            newLocationAddInProgressOrTaken: false,
            isDirectPayment: false),
      );
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
      emit(state.copyWith(isLoading: true));

      int ID = int.parse(event.id);
      NEQrLocationAdd neQrLocationAdd =
          await homeRepository.getQRLocationData(ID);
      if (neQrLocationAdd.inProgress!) {
        emit(state.copyWith(
            isQRValid: false,
            isLoading: false,
            newLocationAddInProgressOrTaken: true,
            isAddToleOkay: false,
            locationAddMsg: "Location Addition in Progress"));
      } else if (neQrLocationAdd.taken!) {
        emit(state.copyWith(
            isQRValid: false,
            isLoading: false,
            isAddToleOkay: false,
            newLocationAddInProgressOrTaken: true,
            locationAddMsg: "Location Already In Use"));
      } else if (!neQrLocationAdd.inProgress! &&
          !neQrLocationAdd.taken! &&
          neQrLocationAdd.cLocationID == null) {
        emit(state.copyWith(
            isQRValid: false,
            isLoading: false,
            isAddToleOkay: false,
            isAddLocationOkay: true,
            newLocationAddInProgressOrTaken: false,
            locationAddMsg: neQrLocationAdd.id!.toString()));
      }

      emit(state.copyWith(
        isQRValid: false,
        isLoading: false,
        isAddLocationOkay: false,
        isAddToleOkay: false,
        newLocationAddInProgressOrTaken: false,
      ));
    } catch (e) {
      Utils.toastMessage(e.toString());
    }
  }

  void _toleAddFunction(
      ToleAddQRScannedEvent event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      int ID = int.parse(event.id);
      NEQRToleAdd neQrToleAdd =
      await homeRepository.getQRToleData(ID);
      if (neQrToleAdd.inProgress!) {
        emit(state.copyWith(
            isQRValid: false,
            isLoading: false,
            newLocationAddInProgressOrTaken: true,
            isAddToleOkay: false,
            isAddLocationOkay: false,
            locationAddMsg: "Tole Addition in Progress"));
      } else if (neQrToleAdd.taken!) {
        emit(state.copyWith(
            isQRValid: false,
            isLoading: false,
            isAddToleOkay: false,
            isAddLocationOkay: false,
            newLocationAddInProgressOrTaken: true,
            locationAddMsg: "Tole ID Already In Use"));
      } else if (!neQrToleAdd.inProgress! &&
          !neQrToleAdd.taken! &&
          neQrToleAdd.neToleID == null) {
        emit(state.copyWith(
            isQRValid: false,
            isLoading: false,
            isAddToleOkay: true,
            isAddLocationOkay: false,
            newLocationAddInProgressOrTaken: false,
            locationAddMsg: neQrToleAdd.id!.toString()));
      }

      emit(state.copyWith(
        isQRValid: false,
        isLoading: false,
        isAddLocationOkay: false,
        isAddToleOkay: false,
        newLocationAddInProgressOrTaken: false,
      ));
    } catch (e) {
      Utils.toastMessage(e.toString());
    }
  }
}
