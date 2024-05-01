part of 'network_cubit.dart';
/// h
@immutable
sealed class NetworkState {}

final class NetworkInitial extends NetworkState {}

final class NetworkConnected extends NetworkState {}

final class NetworkDisconnected extends NetworkState {}
