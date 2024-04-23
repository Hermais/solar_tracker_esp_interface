import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataInitial());


  void setHorizontalAngle(double angle) async{
    emit(DataSendLoading());
    try{
       await FirebaseDatabase.instance.ref('/ESP/HorizontalAngle').set(angle.toInt());
    }catch(e){
      emit(DataSendError(e.toString()));
    }
    emit(DataSendLoaded());
  }

  void setVerticalAngle(double angle) async{
    emit(DataSendLoading());
    try{
       await FirebaseDatabase.instance.ref('/ESP/VerticalAngle').set(angle.toInt());
    }catch(e){
      emit(DataSendError(e.toString()));
    }
    emit(DataSendLoaded());
  }

  void setMode(bool mode) async{
    emit(DataSendLoading());
    try{
       await FirebaseDatabase.instance.ref('/ESP/Mode').set(mode);
    }catch(e){
      print("Set Mode Error: $e");
      emit(DataSendError(e.toString()));
    }
    emit(DataSendLoaded());
  }

  void getDataSnapshot() async {
    emit(DataFetchLoading());
    try {
      final event = await FirebaseDatabase.instance.ref('/ESP').once();
      emit(DataFetchLoaded(
        data: Map<String, dynamic>.from(event.snapshot.value as LinkedHashMap),
      ));
      print("Success.");


    } catch (e) {
      print(e);
      emit(DataFetchError(error: e.toString()));
    }
  }


}

class ESPData {
  final double horizontalAngle;
  final double verticalAngle;
  final Map<String, dynamic> data;

  ESPData({required this.horizontalAngle, required this.verticalAngle, required this.data});

  factory ESPData.fromMap(Map<String, dynamic> map){
    return ESPData(
      horizontalAngle: map['HorizontalAngle'],
      verticalAngle: map['VerticalAngle'],
      data: map,
    );

  }

  @override
  String toString() {
    return 'ESPData(horizontalAngle: $horizontalAngle, verticalAngle: $verticalAngle, data: $data)';
  }
}
