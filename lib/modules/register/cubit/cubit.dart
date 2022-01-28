import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner/models/user_model.dart';
import 'package:planner/modules/register/cubit/states.dart';
import 'package:planner/shared/styles/colors.dart';



class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);


  void userRegister({
    required String name,
    required String email,
    required String password,
  }) {
    emit(RegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(
        name: name,
        email: email,
        uId: value.user!.uid,
      );
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String uId,
  }) {
    UserModel model = UserModel(
      name: name,
      email: email,
      uId: uId,
      image: 'https://image.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg',
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(RegisterSuccessState(uId));
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterChangePasswordVisibilityState());
  }

  Color buttonColor = defaultColor.withOpacity(0.4);

  void changeButtonColor(Color color) {
    buttonColor = color;
    emit(RegisterChangeButtonColorState());
  }
}
