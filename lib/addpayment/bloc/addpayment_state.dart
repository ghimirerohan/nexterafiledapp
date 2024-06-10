
import 'package:equatable/equatable.dart';
import 'package:server_repository/api_response.dart';
import 'package:server_repository/models.dart';

class AddPaymentState extends Equatable{

  final ApiResponse<List<CPeriod>> response;
  final CPeriod? selectedDDCPeriod;
  final bool isPostLoading;
  final bool isPosted;
  final bool hasCard;
  final Map<String,int> cperiodIdNameMap;
  final List<String> ddCperiodNames;

  const AddPaymentState({
    required this.response,
    this.selectedDDCPeriod,
    this.isPostLoading = false,
    this.isPosted = false,
    this.hasCard = false,
    this.cperiodIdNameMap = const {},
    this.ddCperiodNames = const []
  });

  AddPaymentState copyWith({
    ApiResponse<List<CPeriod>>? response,
    CPeriod? selectedDDCPeriod,
    bool? isPostLoading,
    bool? isPosted,
    bool? hasCard,
    Map<String,int>? cperiodIdNameMap,
    List<String>? ddCperiodNames
  }){
    return AddPaymentState(
        response: response ?? this.response,
        selectedDDCPeriod: selectedDDCPeriod ?? this.selectedDDCPeriod,
        isPostLoading: isPostLoading ?? this.isPostLoading,
        isPosted: isPosted ?? this.isPosted,
        hasCard:  hasCard ?? this.hasCard,
        cperiodIdNameMap: cperiodIdNameMap ?? this.cperiodIdNameMap,
        ddCperiodNames: ddCperiodNames ?? this.ddCperiodNames
    );
  }


  @override
  // TODO: implement props
  List<Object?> get props => [response ,selectedDDCPeriod , isPostLoading ,isPosted , cperiodIdNameMap ,ddCperiodNames,hasCard];

}