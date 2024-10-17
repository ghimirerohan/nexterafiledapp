
import 'package:equatable/equatable.dart';
import 'package:server_repository/api_response.dart';
import 'package:server_repository/models.dart';

class AddPaymentState extends Equatable{

  final ApiResponse<List<CPeriod>> response;
  final CPeriod? selectedDDCPeriod;
  final CPeriod? selectedDDFromPeriod;
  final bool isReportingCustomer;
  final bool isPostLoading;
  final bool isPosted;
  final bool hasCard;
  final bool isAddPanBusinessLoading;
  final bool isAddPanBusinessNeeded;
  final bool isUserAdmin;
  final bool isCustomerRateUpdated;
  final bool isCustomerRateUpdateFailed;
  final bool isCustomerQRUpdated;
  final bool isCustomerQRUpdateFailed;
  final String? processMsg;
  final bool askQRToUpdate;
  final bool askCustomerToDeactivate;
  final bool isCustomerPhoneUpdated;
  final bool isCustomerPhoneUpdateFailed;
  final bool? isCustomerReported;
  final bool? isDiscountEnabled;
  final Map<String,int> cperiodIdNameMap;
  final List<String> ddCperiodNames;
  final CBpartner? model;

  const AddPaymentState({
    required this.response,
    this.selectedDDCPeriod,
    this.isPostLoading = false,
    this.isPosted = false,
    this.hasCard = false,
    this.isAddPanBusinessLoading = false,
    this.isAddPanBusinessNeeded = false,
    this.cperiodIdNameMap = const {},
    this.selectedDDFromPeriod,
    this.ddCperiodNames = const [],
    this.isUserAdmin = false,
    this.processMsg,
    this.isCustomerRateUpdated = false,
    this.isCustomerRateUpdateFailed = false,
    this.isCustomerQRUpdated = false,
    this.isCustomerQRUpdateFailed = false,
    this.askQRToUpdate = false,
    this.askCustomerToDeactivate = false,
    this.isCustomerPhoneUpdated = false,
    this.isCustomerPhoneUpdateFailed = false,
    this.isReportingCustomer = false,
    this.isDiscountEnabled = true,
    this.isCustomerReported,
    this.model
  });

  AddPaymentState copyWith({
    ApiResponse<List<CPeriod>>? response,
    CPeriod? selectedDDCPeriod,
    CPeriod? selectedDDFromPeriod,
    bool? isPostLoading,
    bool? isPosted,
    bool? hasCard,
    bool? isAddPanBusinessLoading,
    bool? isAddPanBusinessNeeded,
    Map<String,int>? cperiodIdNameMap,
    List<String>? ddCperiodNames,
    bool? isUserAdmin,
    String? processMsg,
    bool? isCustomerRateUpdated,
    bool? isCustomerRateUpdateFailed,
    bool? isCustomerQRUpdated,
    bool? isCustomerQRUpdateFailed,
    bool? askQRToUpdate,
    bool? askCustomerToDeactivate,
    bool? isCustomerPhoneUpdated,
    bool? isCustomerPhoneUpdateFailed,
    bool? isReportingCustomer,
    bool? isCustomerReported,
    bool? isDiscountEnabled,
    CBpartner? model

  }){
    return AddPaymentState(
        response: response ?? this.response,
        selectedDDCPeriod: selectedDDCPeriod ?? this.selectedDDCPeriod,
        selectedDDFromPeriod : selectedDDFromPeriod ?? this.selectedDDFromPeriod,
        isPostLoading: isPostLoading ?? this.isPostLoading,
        isPosted: isPosted ?? this.isPosted,
        hasCard:  hasCard ?? this.hasCard,
        isAddPanBusinessLoading : isAddPanBusinessLoading ?? this.isAddPanBusinessLoading,
        isAddPanBusinessNeeded : isAddPanBusinessNeeded ?? this.isAddPanBusinessNeeded,
        cperiodIdNameMap: cperiodIdNameMap ?? this.cperiodIdNameMap,
        ddCperiodNames: ddCperiodNames ?? this.ddCperiodNames,
        isUserAdmin : isUserAdmin ?? this.isUserAdmin,
        processMsg: processMsg ?? this.processMsg,
        isCustomerRateUpdated : isCustomerRateUpdated ?? this.isCustomerRateUpdated,
        isCustomerRateUpdateFailed : isCustomerRateUpdateFailed ?? this.isCustomerRateUpdateFailed,
        isCustomerQRUpdated : isCustomerQRUpdated ?? this.isCustomerQRUpdated,
        isCustomerQRUpdateFailed : isCustomerQRUpdateFailed ??this.isCustomerQRUpdateFailed,
      askQRToUpdate: askQRToUpdate ?? this.askQRToUpdate,
        askCustomerToDeactivate : askCustomerToDeactivate ?? this.askCustomerToDeactivate,
        isCustomerPhoneUpdated : isCustomerPhoneUpdated ?? this.isCustomerPhoneUpdated,
        isCustomerPhoneUpdateFailed : isCustomerPhoneUpdateFailed ?? this.isCustomerPhoneUpdateFailed,
        isReportingCustomer : isReportingCustomer ?? this.isReportingCustomer,
        isCustomerReported  : isCustomerReported ?? this.isCustomerReported,
        isDiscountEnabled : isDiscountEnabled ?? this.isDiscountEnabled,
      model: model ?? this.model


    );
  }


  @override
  // TODO: implement props
  List<Object?> get props => [response ,selectedDDCPeriod , isPostLoading ,isPosted ,
    isAddPanBusinessLoading,isAddPanBusinessNeeded,selectedDDFromPeriod,
    cperiodIdNameMap ,ddCperiodNames,hasCard,isUserAdmin,processMsg,isCustomerRateUpdateFailed
    ,isCustomerRateUpdated , isCustomerQRUpdated , isCustomerQRUpdateFailed,
    askCustomerToDeactivate , askQRToUpdate,isCustomerPhoneUpdated ,
    isCustomerPhoneUpdateFailed,isReportingCustomer , isCustomerReported , isDiscountEnabled
    , model];

}