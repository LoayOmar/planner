import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner/modules/onboarding/onboarding_screen.dart';
import 'package:planner/layout/planner_screen.dart';
import 'package:planner/modules/register/register_screen.dart';
import 'package:planner/modules/signin/cubit/cubit.dart';
import 'package:planner/modules/signin/cubit/states.dart';
import 'package:planner/shared/components/components.dart';
import 'package:planner/shared/cubit/cubit.dart';
import 'package:planner/shared/network/local/cache_helper.dart';
import 'package:planner/shared/styles/colors.dart';

class SignInScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId);
            navigateAndFinish(context, PlannerScreen(),);
          }

          if(state is LoginErrorState) {
            showToast(text: state.error.toString(), state: ToastStates.ERROR,);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: backgroundColor,
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.51,
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
                          maxHeight: MediaQuery.of(context).size.height * 0.43,
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
                                                    context, RegisterScreen());
                                              },
                                              text: 'Create Account',
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
                                    'Sign In',
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
                                        0.3,
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
                                              controller: emailController,
                                              type: TextInputType.emailAddress,
                                              validate: (value) {},
                                              onChanged: (value) {
                                                if (emailController
                                                    .text.isEmpty ||
                                                    passwordController
                                                        .text.isEmpty) {
                                                  LoginCubit.get(context)
                                                      .changeButtonColor(
                                                      defaultColor
                                                          .withOpacity(
                                                          0.4));
                                                } else {
                                                  LoginCubit.get(context)
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
                                                if (emailController
                                                        .text.isEmpty ||
                                                    passwordController
                                                        .text.isEmpty) {
                                                  LoginCubit.get(context)
                                                      .changeButtonColor(
                                                      defaultColor
                                                          .withOpacity(
                                                          0.4));
                                                } else {
                                                  LoginCubit.get(context)
                                                      .changeButtonColor(
                                                      defaultColor);
                                                }
                                              },
                                              label: 'Password',
                                              isPassword:
                                                  LoginCubit.get(context)
                                                      .isPassword,
                                              suffix: LoginCubit.get(context)
                                                  .suffix,
                                              suffixPressed: () {
                                                LoginCubit.get(context)
                                                    .changePasswordVisibility();
                                              },
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: state is LoginLoadingState ? Center(child: CircularProgressIndicator()) : defaultButton(
                                                function: emailController
                                                    .text.isNotEmpty &
                                                passwordController
                                                    .text.isNotEmpty
                                                    ? () {
                                                  LoginCubit.get(context).userLogin(
                                                    email: emailController.text,
                                                    password: passwordController.text,
                                                  );
                                                }
                                                    : null,
                                                text: 'Sign In',
                                                context: context,
                                                background: LoginCubit.get(context).buttonColor,
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
