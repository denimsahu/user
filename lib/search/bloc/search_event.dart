part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

class SearchBusSubmitEvent extends SearchEvent{
  String StartPoint;
  String EndPoint;
  SearchBusSubmitEvent({required this.StartPoint, required this.EndPoint});
}