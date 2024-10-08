

import 'package:get_it/get_it.dart';
import 'package:solar_tracker_esp_interface/features/main_interface/presentation/bloc/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:solar_tracker_esp_interface/features/main_interface/presentation/bloc/data_cubit.dart';
import 'package:solar_tracker_esp_interface/features/main_interface/presentation/bloc/network_cubit.dart';
import 'package:solar_tracker_esp_interface/firebase_options.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


final sl = GetIt.instance;

Future<void> initDependencies() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  sl.registerLazySingleton(() => AuthCubit());

  sl.registerLazySingleton(() => DataCubit());

  sl.registerLazySingleton(() => Connectivity());

  sl.registerLazySingleton(() => NetworkCubit(connectivity: sl() ));
}