
import 'package:equatable/equatable.dart';
import 'package:server_repository/api_response.dart';
import 'package:server_repository/models.dart';

class AddCustomerState extends Equatable{

  final ApiResponse<List<CBPGroup>> response;
  final CBPGroup? selectedDDCBPGroup;
  final bool isPostLoading;
  final bool isPosted;
  final bool hasCard;
  final Map<String,int> cbGroupIdNameMap;
  final List<String> ddCBGNames;
  String? cardBase64;

   AddCustomerState({
    required this.response,
  this.selectedDDCBPGroup,
  this.isPostLoading = false,
    this.isPosted = false,
    this.hasCard = false,
    this.cbGroupIdNameMap = const {},
    this.ddCBGNames = const [],
    this.cardBase64
});

  AddCustomerState copyWith({
     ApiResponse<List<CBPGroup>>? response,
    CBPGroup? selectedDDCBPGroup,
     bool? isPostLoading,
    bool? isPosted,
    bool? hasCard,
     Map<String,int>? cbGroupIdNameMap,
     List<String>? ddCBGNames,
    String? cardBase64
}){
    return AddCustomerState(
        response: response ?? this.response,
      selectedDDCBPGroup: selectedDDCBPGroup ?? this.selectedDDCBPGroup,
      isPostLoading: isPostLoading ?? this.isPostLoading,
      isPosted: isPosted ?? this.isPosted,
      hasCard:  hasCard ?? this.hasCard,
      cbGroupIdNameMap: cbGroupIdNameMap ?? this.cbGroupIdNameMap,
      ddCBGNames: ddCBGNames ?? this.ddCBGNames,
        cardBase64 : cardBase64 ?? this.cardBase64
    );
  }


  @override
  // TODO: implement props
  List<Object?> get props => [response ,selectedDDCBPGroup ,
    isPostLoading ,isPosted , cbGroupIdNameMap ,ddCBGNames,
    hasCard,cardBase64];

}