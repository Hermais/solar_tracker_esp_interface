abstract interface class UseCaseContract<Type, Params> {
  Future<dynamic> call();
}

