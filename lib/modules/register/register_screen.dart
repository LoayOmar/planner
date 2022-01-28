import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner/modules/onboarding/onboarding_screen.dart';
import 'package:planner/modules/register/cubit/cubit.dart';
import 'package:planner/modules/register/cubit/states.dart';
import 'package:planner/modules/signin/signin_screen.dart';
import 'package:planner/shared/components/components.dart';
import 'package:planner/shared/styles/colors.dart';

class RegisterScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            navigateAndFinish(
              context,
              SignInScreen(),
            );
          }
          if (state is RegisterErrorState) {
            showToast(
              text: state.error.toString(),
              state: ToastStates.ERROR,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: backgroundColor,
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.58,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    overflow: Overflow.visible,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        color: defaultColor,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () {
                            navigateAndFinish(context, OnBoardingScreen());
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: OverflowBox(
                          alignment: Alignment.bottomCenter,
                          maxHeight: MediaQuery.of(context).size.height * 0.51,
                          child: Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: OverflowBox(
                                  alignment: Alignment.bottomCenter,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: defaultTextButton(
                                              function: () {
                                                navigateAndFinish(
                                                    context, SignInScreen());
                                              },
                                              text: 'Sign In',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Create Account',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            color: Colors.white, fontSize: 25),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.38,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Card(
                                      elevation: 5,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 8),
                                        child: Column(
                                          children: [
                                            defaultTextFormField(
                                              controller: nameController,
                                              type: TextInputType.name,
                                              validate: (value) {},
                                              onChanged: (value) {
                                                if (nameController
                                                        .text.isEmpty ||
                                                    emailController
                                                        .text.isEmpty ||
                                                    passwordController
                                                        .text.isEmpty) {
                                                  RegisterCubit.get(context)
                                                      .changeButtonColor(
                                                          defaultColor
                                                              .withOpacity(
                                                                  0.4));
                                                } else {
                                                  RegisterCubit.get(context)
                                                      .changeButtonColor(
                                                          defaultColor);
                                                }
                                              },
                                              label: 'Name',
                                            ),
                                            defaultTextFormField(
                                              controller: emailController,
                                              type: TextInputType.emailAddress,
                                              validate: (value) {},
                                              onChanged: (value) {
                                                if (nameController
                                                        .text.isEmpty ||
                                                    emailController
                                                        .text.isEmpty ||
                                                    passwordController
                                                        .text.isEmpty) {
                                                  RegisterCubit.get(context)
                                                      .changeButtonColor(
                                                          defaultColor
                                                              .withOpacity(
                                                                  0.4));
                                                } else {
                                                  RegisterCubit.get(context)
                                                      .changeButtonColor(
                                                          defaultColor);
                                                }
                                              },
                                              label: 'Email',
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            defaultTextFormField(
                                              controller: passwordController,
                                              type: TextInputType.visiblePassword,
                                              validate: (value) {},
                                              onChanged: (value) {
                                                if (nameController
                                                        .text.isEmpty ||
                                                    emailController
                                                        .text.isEmpty ||
                                                    passwordController
                                                        .text.isEmpty) {
                                                  RegisterCubit.get(context)
                                                      .changeButtonColor(
                                                          defaultColor
                                                              .withOpacity(
                                                                  0.4));
                                                } else {
                                                  RegisterCubit.get(context)
                                                      .changeButtonColor(
                                                          defaultColor);
                                                }
                                              },
                                              label: 'Password',
                                              isPassword:
                                                  RegisterCubit.get(context)
                                                      .isPassword,
                                              suffix: RegisterCubit.get(context)
                                                  .suffix,
                                              suffixPressed: () {
                                                RegisterCubit.get(context)
                                                    .changePasswordVisibility();
                                              },
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: state
                                                      is RegisterLoadingState
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator())
                                                  : defaultButton(
                                                      function: nameController
                                                                  .text
                                                                  .isNotEmpty &
                                                              emailController
                                                                  .text
                                                                  .isNotEmpty &
                                                              passwordController
                                                                  .text
                                                                  .isNotEmpty
                                                          ? () {
                                                              RegisterCubit.get(
                                                                      context)
                                                                  .userRegister(
                                                                name:
                                                                    nameController
                                                                        .text,
                                                                email:
                                                                    emailController
                                                                        .text,
                                                                password:
                                                                    passwordController
                                                                        .text,
                                                              );
                                                            }
                                                          : null,
                                                      text: 'Create Account',
                                                      context: context,
                                                      background:
                                                          RegisterCubit.get(
                                                                  context)
                                                              .buttonColor,
                                                      textColor: Colors.white,
                                                      textSize: 24,
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
