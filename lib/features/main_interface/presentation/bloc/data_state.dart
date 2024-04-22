part of 'data_cubit.dart';

@immutable
sealed class DataState {}

final class DataInitial extends DataState {}

final class DataFetchLoading extends DataState {}

final class DataFetchLoaded extends DataState {
  final double? horizontalAngle;
  final double? verticalAngle;
  final Map<String, dynamic>? data;


  DataFetchLoaded({this.horizontalAngle, this.verticalAngle, this.data});


}

final class DataFetchError extends DataState {
  final String error;

  DataFetchError(this.error);
}

final class DataSendLoading extends DataState {}


final class DataSendLoaded extends DataState {

}

final class DataSendError extends DataState {
  final String error;

  DataSendError(this.error);
}
