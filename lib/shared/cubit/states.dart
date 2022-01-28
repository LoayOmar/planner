import 'package:planner/models/user_model.dart';

abstract class PlannerStates {}

class PlannerInitialState extends PlannerStates {}

class PlannerChangeFocusedMonthState extends PlannerStates {}

class PlannerChangeFocusedDayState extends PlannerStates {}

class PlannerChangeCurrentDateState extends PlannerStates {}

class PlannerChangePageSelectedState extends PlannerStates {}

class PlannerProfileImagePickedSuccessState extends PlannerStates {}

class PlannerProfileImagePickedErrorState extends PlannerStates {}

class PlannerUserUpdateProfileLoadingState extends PlannerStates {}

class PlannerUploadProfileImageErrorState extends PlannerStates {}

class PlannerUserUpdateErrorState extends PlannerStates {}

class PlannerUserUpdateLoadingState extends PlannerStates {}

class PlannerChangeThemeModeState extends PlannerStates {}

class PlannerChangeEventColorState extends PlannerStates {}

class PlannerChangeCurrentTimeState extends PlannerStates {}

class PlannerClearTaskDataState extends PlannerStates {}

class PlannerEmitState extends PlannerStates {}

class PlannerChangeSubTaskValueState extends PlannerStates {}

class PlannerAddSubTaskState extends PlannerStates {}

class PlannerDeleteSubTaskState extends PlannerStates {}

class PlannerGetUserLoadingStates extends PlannerStates {}

class PlannerGetUserSuccessStates extends PlannerStates {}

class PlannerGetUserErrorStates extends PlannerStates {
  final String error;

  PlannerGetUserErrorStates(this.error);
}

class PlannerGetAllUsersSuccessStates extends PlannerStates {}

class PlannerGetAllUsersErrorStates extends PlannerStates {
  final String error;

  PlannerGetAllUsersErrorStates(this.error);
}

class PlannerChangeInitialDateState extends PlannerStates {}

class PlannerCreateDatabaseState extends PlannerStates {}

class PlannerGetDatabaseLoadingState extends PlannerStates {}

class PlannerGetDatabaseState extends PlannerStates {}

class PlannerInsertDatabaseState extends PlannerStates {}

class PlannerUpdateDatabaseState extends PlannerStates {}

class PlannerDeleteDatabaseState extends PlannerStates {}

class PlannerLoginWithGoogleState extends PlannerStates {
  final UserModel userModel;

  PlannerLoginWithGoogleState(this.userModel);
}

class PlannerLoginWithFacebookState extends PlannerStates {
  final UserModel userModel;

  PlannerLoginWithFacebookState(this.userModel);
}

class PlannerUploadProfileImageSuccessState extends PlannerStates {}
