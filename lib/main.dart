import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:planner/http_overrides.dart';
import 'package:planner/models/user_model.dart';
import 'package:planner/modules/onboarding/onboarding_screen.dart';
import 'package:planner/layout/planner_screen.dart';
import 'package:planner/shared/bloc_observer.dart';
import 'package:planner/shared/components/constants.dart';
import 'package:planner/shared/cubit/cubit.dart';
import 'package:planner/shared/cubit/states.dart';
import 'package:planner/shared/network/local/cache_helper.dart';
import 'package:planner/shared/network/local/noitification_service.dart';
import 'package:planner/shared/styles/colors.dart';
import 'package:planner/shared/styles/themes.dart';
import 'package:timezone/data/latest.dart' as tz;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await CacheHelper.init();

  tz.initializeTimeZones();

  NotificationService().initNotification();

  uId = CacheHelper.getData(key: 'uId');
  print('Cache $uId');

  HttpOverrides.global = MyHttpOverrides();

  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlannerCubit()..getUserData()..getUsers()..createTasksDatabase()..createNotesDatabase()..createEventsDatabase(),
      child: BlocConsumer<PlannerCubit, PlannerStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if(CacheHelper.getData(key: 'googleSignIn') == true){
            PlannerCubit.get(context).userModel = UserModel(
              name: CacheHelper.getData(key: 'googleName'),
              email: CacheHelper.getData(key: 'googleEmail'),
              uId: CacheHelper.getData(key: 'uId'),
              image: CacheHelper.getData(key: 'googleImage'),
            );
          } else if(CacheHelper.getData(key: 'facebookSignIn') == true){
            PlannerCubit.get(context).userModel = UserModel(
              name: CacheHelper.getData(key: 'facebookName'),
              email: CacheHelper.getData(key: 'facebookEmail'),
              uId: CacheHelper.getData(key: 'uId'),
              image: CacheHelper.getData(key: 'facebookImage'),
            );
          }

          return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          home: uId == null
              ? OnBoardingScreen()
              : PlannerCubit.get(context).userModel == null
                  ? Container(
                      color: Colors.pink.shade50,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: defaultColor,
                        ),
                      ))
                  : PlannerScreen(),
        );
        },
      ),
    );
  }
}
