abstract class RegisterStates{}

class RegisterInitialState extends RegisterStates{}

class RegisterLoadingState extends RegisterStates{}

class RegisterSuccessState extends RegisterStates{
  final String uId;
  RegisterSuccessState(this.uId);
}

class RegisterErrorState extends RegisterStates{
  final String error;

  RegisterErrorState(this.error);
}

class RegisterChangePasswordVisibilityState extends RegisterStates{}

class RegisterChangeButtonColorState extends RegisterStates{}