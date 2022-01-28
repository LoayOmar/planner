import 'package:flutter/material.dart';
import 'package:planner/modules/onboarding/onboarding_screen.dart';
import 'package:planner/shared/components/components.dart';
import 'package:planner/shared/cubit/cubit.dart';
import 'package:planner/shared/network/local/cache_helper.dart';

void signOut(BuildContext context) {
  CacheHelper.removeData(key: 'googleSignIn');
  CacheHelper.removeData(key: 'googleName');
  CacheHelper.removeData(key: 'googleEmail');
  CacheHelper.removeData(key: 'googleImage');
  CacheHelper.removeData(key: 'facebookSignIn');
  CacheHelper.removeData(key: 'facebookName');
  CacheHelper.removeData(key: 'facebookEmail');
  CacheHelper.removeData(key: 'facebookImage');
  CacheHelper.removeData(key: 'uId').then((value) {
    if (value == true) {
      uId = '';
      navigateAndFinish(context, OnBoardingScreen());
      PlannerCubit.get(context).changePageSelected(0);
    }
  });
}

String? uId = '';