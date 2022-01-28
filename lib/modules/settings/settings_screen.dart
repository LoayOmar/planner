import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner/models/user_model.dart';
import 'package:planner/layout/planner_screen.dart';
import 'package:planner/shared/components/components.dart';
import 'package:planner/shared/components/constants.dart';
import 'package:planner/shared/cubit/cubit.dart';
import 'package:planner/shared/cubit/states.dart';
import 'package:planner/shared/network/local/cache_helper.dart';
import 'package:planner/shared/styles/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlannerCubit, PlannerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = PlannerCubit.get(context);
        return ListView(
          children: [
            InkWell(
              onTap: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  body: Column(
                    children: [
                      if(CacheHelper.getData(key: 'googleSignIn') == null && CacheHelper.getData(key: 'facebookSignIn') == null)
                      drawerItem(
                        context: context,
                        function: () {
                          cubit.getProfileImage();
                        },
                        color: secondaryColor,
                        title: 'Change Profile Photo',
                        iconData: Icons.logout,
                      ),
                      if(CacheHelper.getData(key: 'googleSignIn') == null && CacheHelper.getData(key: 'facebookSignIn') == null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: myDivider(),
                      ),
                      drawerItem(
                        context: context,
                        function: () {
                          signOut(context);
                        },
                        color: secondaryColor,
                        title: 'Sign Out',
                        iconData: Icons.logout,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: myDivider(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if(CacheHelper.getData(key: 'googleSignIn') == null && CacheHelper.getData(key: 'facebookSignIn') == null)
                            defaultButton(
                              function: () {
                                if(cubit.profileImage != null) {
                                  showToast(text: 'Done, Just Wait A Few Seconds', state: ToastStates.SUCCESS);
                                  cubit.uploadProfileImage();
                                } else {
                                  showToast(text: 'No Image Picked', state: ToastStates.ERROR);
                                }
                                navigateAndFinish(context, PlannerScreen());
                              },
                              text: 'Save',
                              context: context,
                            ),
                            defaultButton(
                              function: () {
                                Navigator.pop(context);
                              },
                              text: 'Close',
                              context: context,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).show();
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 10,
                      child: Container(
                        width: 50,
                        height: 50,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25)),
                        child: Image(
                          image: NetworkImage(cubit.userModel!.image!),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      cubit.userModel!.name!,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: secondaryColor,
                    ),
                  ],
                ),
              ),
            ),
            myDivider(),
            defaultItemPressed(
              context: context,
              iconData: Icons.wb_sunny_outlined,
              title: cubit.themeModeTitle,
              widget: Icon(
                Icons.arrow_forward_ios,
                color: secondaryColor,
              ),
              iconColor: cubit.themeModeIconColor,
              function: () {
                cubit.changeThemeMode();
              },
            ),
            myDivider(),
          ],
        );
      },
    );
  }
}
