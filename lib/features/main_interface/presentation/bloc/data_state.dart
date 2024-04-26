part of 'data_cubit.dart';

@immutable
sealed class DataState {}

final class DataInitial extends DataState {}

final class DataFetchLoading extends DataState {}

final class DataFetchLoaded extends DataState {
  final ESPData data;


  DataFetchLoaded({required this.data});

}

final class DataFetchError extends DataState {
  final String error;

  DataFetchError({required this.error});
}

final class DataSendError extends DataState {
  final String error;

  DataSendError({required this.error});
}
