import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());


  void signInAnonymously() async {
    emit(AuthLoading());
    try{
      await FirebaseAuth.instance.signInAnonymously();
    }catch(e){

      emit(AuthError(e.toString()));
    }
    emit(AuthLoaded());
  }




}
