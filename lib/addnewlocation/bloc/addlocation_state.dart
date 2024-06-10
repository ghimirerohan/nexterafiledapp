import 'package:equatable/equatable.dart';

class AddLocationState extends Equatable {
  final bool isPostLoading;
  final bool isPosted;
  final String? selectedWard;

  const AddLocationState(
      {this.isPostLoading = false, this.isPosted = false, this.selectedWard});

  AddLocationState copyWith({
    bool? isPostLoading,
    bool? isPosted,
    String? selectedWard,
  }) {
    return AddLocationState(
        isPostLoading: isPostLoading ?? this.isPostLoading,
        isPosted: isPosted ?? this.isPosted,
        selectedWard: selectedWard ?? this.selectedWard);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [isPostLoading, isPosted, selectedWard];
}
