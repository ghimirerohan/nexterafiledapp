
import 'package:equatable/equatable.dart';
import 'package:next_era_collector/custlist/custrepo/CustListRepo.dart';
import 'package:server_repository/server_repository.dart';

 class CustListState extends Equatable{

   const CustListState({
     required this.response ,
     this.status = CustListStatus.none,
     this.c_location,
     this.selectedPartner,
     this.currenPeriod,
     this.isUpdateOwnerNameLoading = false,
     this.customerAddMsg = "",
     this.isAddCustomerInProgressorTaken = false,
     this.ne_qrcustomeradd_id = 0,
     this.isOnlyDataCollector = false

 });

   CustListState copyWith({
     ApiResponse<List<CBpartner>>? response,
     CustListStatus? status,
     CLocation? c_location,
     CBpartner? selectedPartner,
     CPeriod?  currenPeriod,
     bool? isUpdateOwnerNameLoading,
     String? customerAddMsg,
     bool? isAddCustomerInProgressorTaken,
     int? ne_qrcustomeradd_id,
     bool? isOnlyDataCollector
   }){
     return CustListState(
         response: response ?? this.response,
       status: status ?? this.status,
       c_location: c_location ?? this.c_location,
       selectedPartner: selectedPartner ?? this.selectedPartner,
       currenPeriod: currenPeriod ?? this.currenPeriod,
       isUpdateOwnerNameLoading:  isUpdateOwnerNameLoading ?? this.isUpdateOwnerNameLoading,
         customerAddMsg: customerAddMsg ?? this.customerAddMsg,
         isAddCustomerInProgressorTaken: isAddCustomerInProgressorTaken ?? this.isAddCustomerInProgressorTaken,
         ne_qrcustomeradd_id : ne_qrcustomeradd_id ?? this.ne_qrcustomeradd_id,
         isOnlyDataCollector : isOnlyDataCollector ?? this.isOnlyDataCollector,
     );
   }
   final ApiResponse<List<CBpartner>> response;
   final CustListStatus status;
   final CLocation? c_location;
   final CBpartner? selectedPartner;
   final CPeriod?  currenPeriod;
   final bool isUpdateOwnerNameLoading;
   final String customerAddMsg;
   final bool isAddCustomerInProgressorTaken;
   final int ne_qrcustomeradd_id;
   final bool isOnlyDataCollector ;


   @override
  // TODO: implement props
  List<Object?> get props => [response,status,c_location,selectedPartner 
    ,currenPeriod , isUpdateOwnerNameLoading,customerAddMsg , isAddCustomerInProgressorTaken , ne_qrcustomeradd_id
   ,isOnlyDataCollector];
}

