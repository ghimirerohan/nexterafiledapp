import 'package:equatable/equatable.dart';
import 'package:server_repository/models.dart';

class HomeState extends Equatable {

  const HomeState({
    this.selection = 0,
    this.isQRValid = false,
    this.qrData = "",
    this.logOutRequested = false,
    this.isTotalAmountLoading = false,
    this.isDirectPayment = false,
    this.totalCollected = 0,
    this.custModel,
    this.newLocationAddInProgressOrTaken = false,
    this.locationAddMsg = "",
    this.todayTotalCustCreatedString = "",
    this.isAddLocationOkay = false,
    this.isLoading = false,
    this.isDatacollector = false,
    this.optionBeforeDirectPay = false,
    this.isAddToleOkay = false
  });

  final int selection;
  final bool isQRValid;
  final String qrData;
  final bool logOutRequested;
  final bool isTotalAmountLoading;
  final bool isDirectPayment;
  final double totalCollected;
  final CBpartner? custModel;
  final bool newLocationAddInProgressOrTaken;
  final String locationAddMsg;
  final bool isAddLocationOkay;
  final bool isAddToleOkay;
  final bool isLoading;
  final String todayTotalCustCreatedString;
  final bool isDatacollector;
  final bool optionBeforeDirectPay;

  HomeState copyWith({
    int? selection,
    bool? isQRValid,
    String? qrData,
    bool? logOutRequested,
    bool? isTotalAmountLoading,
    bool? isDirectPayment,
    double? totalCollected,
    CBpartner? custModel,
    bool? newLocationAddInProgressOrTaken,
    String? locationAddMsg,
    bool? isAddLocationOkay,
    bool? isAddToleOkay,
    bool? isLoading,
    bool? isDatacollector,
    String? todayTotalCustCreatedString,
    bool? optionBeforeDirectPay
  }) {
    return HomeState(
        selection: selection ?? this.selection,
        isQRValid: isQRValid ?? this.isQRValid,
        qrData: qrData ?? this.qrData,
        logOutRequested: logOutRequested ?? this.logOutRequested,
        isTotalAmountLoading: isTotalAmountLoading ?? this.isTotalAmountLoading,
        isDirectPayment: isDirectPayment ?? this.isDirectPayment,
        totalCollected: totalCollected ?? this.totalCollected,
        custModel: custModel ?? this.custModel,
        newLocationAddInProgressOrTaken: newLocationAddInProgressOrTaken ??
            this.newLocationAddInProgressOrTaken,
        locationAddMsg: locationAddMsg ?? this.locationAddMsg,
        isAddLocationOkay: isAddLocationOkay ?? this.isAddLocationOkay,
        isAddToleOkay : isAddToleOkay ?? this.isAddToleOkay,
        isLoading : isLoading ?? this.isLoading,
      isDatacollector:  isDatacollector ?? this.isDatacollector,
        todayTotalCustCreatedString : todayTotalCustCreatedString ?? this.todayTotalCustCreatedString,
        optionBeforeDirectPay : optionBeforeDirectPay ?? this.optionBeforeDirectPay
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [
        selection,
        isQRValid,
        qrData,
        logOutRequested,
        totalCollected
        ,
        isAddToleOkay,
        optionBeforeDirectPay,
        isLoading,
        isDirectPayment,
        isTotalAmountLoading,
        custModel,
        newLocationAddInProgressOrTaken,
        locationAddMsg,
        isAddLocationOkay,
        isDatacollector,
        todayTotalCustCreatedString
      ];

}