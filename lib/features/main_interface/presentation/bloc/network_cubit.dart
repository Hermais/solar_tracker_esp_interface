import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final Connectivity connectivity;
  List<ConnectivityResult> _connectionStatus = <ConnectivityResult>[
    ConnectivityResult.none
  ];


  late StreamSubscription connectivitySubscription;

  NetworkCubit({required this.connectivity}) : super(NetworkInitial()) {
    initConnectivity();
    monitorInternetConnection();
  }

  StreamSubscription<List<ConnectivityResult>> monitorInternetConnection() {

    return connectivitySubscription =
        connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await connectivity.checkConnectivity();
    }  catch (e) {
      print('Couldn\'t check connectivity status $e');
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;

    print("Called to check connection. $_connectionStatus");
    if (_connectionStatus.contains(ConnectivityResult.none) ) {
      emit(NetworkDisconnected());
    } else {
      emit(NetworkConnected());
    }
  }
}
