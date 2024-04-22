import 'package:solar_tracker_esp_interface/features/main_interface/domain/repository/auth_repository_contract.dart';

import '../firebase_data_source/firebase_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository implements AuthRepositoryContract {
  final RemoteDataSourceContract _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  @override
  Future<void> signInAnonymously() async {
    await _remoteDataSource.signInAnonymously();

  }
}