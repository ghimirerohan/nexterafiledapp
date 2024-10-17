
part of 'addnewtole_bloc.dart';


class AddnewtoleState extends Equatable {
  final bool isPostLoading;
  final bool isPosted;
  final String? selectedWard;

  const AddnewtoleState(
      {this.isPostLoading = false, this.isPosted = false, this.selectedWard});

  AddnewtoleState copyWith({
    bool? isPostLoading,
    bool? isPosted,
    String? selectedWard,
  }) {
    return AddnewtoleState(
        isPostLoading: isPostLoading ?? this.isPostLoading,
        isPosted: isPosted ?? this.isPosted,
        selectedWard: selectedWard ?? this.selectedWard);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [isPostLoading, isPosted, selectedWard];
}