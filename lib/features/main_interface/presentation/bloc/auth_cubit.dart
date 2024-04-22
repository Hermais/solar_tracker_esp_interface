import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // void moveFromSplash() async {
  //
  //   emit(AuthLoading());
  //   await Future.delayed(const Duration(seconds: 1));
  //   emit(AuthLoaded());
  // }

  void signInAnonymously() async {
    emit(AuthLoading());
    try{
      final user = await FirebaseAuth.instance.signInAnonymously();
    }catch(e){
      emit(AuthError(e.toString()));
    }
    emit(AuthLoaded());
  }




}
