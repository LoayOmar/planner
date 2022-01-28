import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_animation/onboarding_animation.dart';
import 'package:planner/layout/planner_screen.dart';
import 'package:planner/modules/register/register_screen.dart';
import 'package:planner/modules/signin/signin_screen.dart';
import 'package:planner/shared/components/components.dart';
import 'package:planner/shared/cubit/cubit.dart';
import 'package:planner/shared/cubit/states.dart';
import 'package:planner/shared/network/local/cache_helper.dart';
import 'package:planner/shared/styles/colors.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlannerCubit, PlannerStates>(
      listener: (context, state) {
        if(state is PlannerLoginWithGoogleState){
          CacheHelper.saveData(key: 'uId', value: state.userModel.uId);
          CacheHelper.saveData(key: 'googleImage', value: state.userModel.image);
          CacheHelper.saveData(key: 'googleName', value: state.userModel.name);
          CacheHelper.saveData(key: 'googleEmail', value: state.userModel.email);
          CacheHelper.saveData(key: 'googleSignIn', value: true);
          navigateAndFinish(context, PlannerScreen(),);
        }
        if(state is PlannerLoginWithFacebookState){
          CacheHelper.saveData(key: 'uId', value: state.userModel.uId);
          CacheHelper.saveData(key: 'facebookImage', value: state.userModel.image);
          CacheHelper.saveData(key: 'facebookName', value: state.userModel.name);
          CacheHelper.saveData(key: 'facebookEmail', value: state.userModel.email);
          CacheHelper.saveData(key: 'facebookSignIn', value: true);
          navigateAndFinish(context, PlannerScreen(),);
        }
      },
      builder: (context, state) => Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: OnBoardingAnimation(
                    pages: [
                      Column(
                        children: [
                          Expanded(
                            child: Image.network(
                              'https://image.freepik.com/free-photo/calendar-app-tablet_53876-124022.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text(
                            'Daily Schedule',
                            style: Theme.of(context).textTheme.headline4!.copyWith(color: defaultColor),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                            'Pulling together events, tasks, notes and calendars all in one place',
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18, color: defaultColor.withOpacity(0.6)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20,),
                        ],
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: Image.network(
                              'https://image.freepik.com/free-photo/agenda-calendar-appointment-graphic-concept_53876-120937.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text(
                            'Task Manager',
                            style: Theme.of(context).textTheme.headline4!.copyWith(color: defaultColor),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                            'Complete tasks or project with sub-tasks',
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18, color: defaultColor.withOpacity(0.6)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20,),
                        ],
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: Image.network(
                              'https://image.freepik.com/free-photo/planner-calendar-schedule-date-concept_53876-121073.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text(
                            'Sync Anytime',
                            style: Theme.of(context).textTheme.headline4!.copyWith(color: defaultColor),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                            'Sync directly with all your devices',
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18, color: defaultColor.withOpacity(0.6)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20,),
                        ],
                      ),
                    ],
                    indicatorDotHeight: 7.0,
                    indicatorDotWidth: 7.0,
                    indicatorType: IndicatorType.jumpingDots,
                    indicatorPosition: IndicatorPosition.bottomCenter,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: defaultButton(
                            function: () {
                              navigateAndFinish(context, SignInScreen());
                            },
                            text: 'Sign In',
                            context: context,
                            background: defaultColor,
                            textColor: Colors.white,
                            textSize: 24,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        SizedBox(
                          width: double.infinity,
                          child: defaultButton(
                            function: () {
                              navigateAndFinish(context, RegisterScreen());
                            },
                            text: 'Create Account',
                            context: context,
                            background: Colors.white,
                            textColor: defaultColor,
                            textSize: 24,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey[300],
                              ),
                            ),
                            const SizedBox(width: 5,),
                            const Text('or', style: TextStyle(color: Colors.pink),),
                            const SizedBox(width: 5,),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: (){
                                PlannerCubit.get(context).googleLogin();
                              },
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('assets/images/google.png'),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                PlannerCubit.get(context).facebookLogin();
                              },
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('assets/images/facebook.png'),
                              ),
                            ),
                            /*InkWell(
                              onTap: (){},
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('assets/images/twitter.png'),
                              ),
                            ),*/
                          ],
                        )
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
  }

}
