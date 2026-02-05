part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

class SearchBusLoadingState extends SearchState{}

class SearchBusResultState extends SearchState{
  List<BusModel> BusModels;
  SearchBusResultState({required this.BusModels}); 
}

class SearchBusErrorState extends SearchState{
  String? ErrorMessage;
  SearchBusErrorState({this.ErrorMessage});
}
