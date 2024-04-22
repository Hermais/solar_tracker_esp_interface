import 'package:firebase_auth/firebase_auth.dart';

abstract interface class RemoteDataSourceContract {

  Future<void> signInAnonymously();
}


class RemoteDataSource implements RemoteDataSourceContract {
  final FirebaseAuth _firebaseAuth;

  RemoteDataSource(this._firebaseAuth);

  @override
  Future<void> signInAnonymously() async {
    await _firebaseAuth.signInAnonymously();

  }
}