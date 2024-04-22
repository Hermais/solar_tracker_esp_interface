import 'package:firebase_auth/firebase_auth.dart';
import 'package:solar_tracker_esp_interface/core/usecase/usecase.dart';
import 'package:solar_tracker_esp_interface/features/main_interface/domain/repository/auth_repository_contract.dart';

import '../../data/repository/auth_repository.dart';

class LogInAnon implements UseCaseContract<Empty, NoParams> {
  AuthRepositoryContract repository;

  LogInAnon(this.repository);


  @override
  Future<void> call() async {
    await repository.signInAnonymously();

  }


}

class Empty{

}
class NoParams{

}