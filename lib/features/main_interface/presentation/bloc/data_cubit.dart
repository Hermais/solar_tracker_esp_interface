
import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataInitial());

  void setHorizontalAngle(double angle) async {
    try {
      await FirebaseDatabase.instance.ref('/ESP/HorizontalAngle').set(angle.toInt());
    } catch (e) {
      emit(DataSendError(error: e.toString()));
    }
  }

  void setVerticalAngle(double angle) async {
    try {
      await FirebaseDatabase.instance.ref('/ESP/VerticalAngle').set(angle.toInt());
    } catch (e) {
      emit(DataSendError(error: e.toString()));

    }
  }

  void setMode(bool mode) async {
    try {
      await FirebaseDatabase.instance.ref('/ESP/Mode').set(mode);
    } catch (e) {
      print("Set Mode Error: $e");
      emit(DataSendError(error: e.toString()));

    }
  }

  void getDataSnapshot() async {
    emit(DataFetchLoading());
    try {
      final event = await FirebaseDatabase.instance.ref('/ESP').once();
      emit(DataFetchLoaded(
          data: ESPData.fromMap(
        Map<String, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>),
      )));
      print("Success. ESPData: ${(state as DataFetchLoaded).data}");
    } catch (e) {
      print(e);
      emit(DataFetchError(error: e.toString()));
    }
  }

  void forceFailure(){
    emit(DataFetchError(error: "Forced Failure"));
  }
}

class ESPData {
  final double horizontalAngle;
  final double verticalAngle;
  final bool mode;
  final double cellCurrent;
  final double cellVoltage;

  ESPData({
    required this.horizontalAngle,
    required this.verticalAngle,
    required this.mode,
    required this.cellCurrent,
    required this.cellVoltage,
  });

  factory ESPData.fromMap(Map<String, dynamic> map) {
    return ESPData(
      horizontalAngle: map['HorizontalAngle'],
      verticalAngle: map['VerticalAngle'],
      mode: map['Mode'],
      cellCurrent: map['CellCurrent'],
      cellVoltage: map['CellVoltage'],
    );
  }

  @override
  String toString() {
    return 'ESPData(horizontalAngle: $horizontalAngle, verticalAngle: $verticalAngle, '
        'mode: $mode, cellCurrent: $cellCurrent, cellVoltage: $cellVoltage)';
  }
}
