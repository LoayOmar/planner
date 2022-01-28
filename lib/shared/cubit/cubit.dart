import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:planner/models/event_model.dart';
import 'package:planner/models/note_model.dart';
import 'package:planner/models/task_model.dart';
import 'package:planner/models/user_model.dart';
import 'package:planner/modules/calendar/calendar_screen.dart';
import 'package:planner/modules/notes/notes_screen.dart';
import 'package:planner/modules/settings/settings_screen.dart';
import 'package:planner/modules/tasks/tasks_screen.dart';
import 'package:planner/shared/components/components.dart';
import 'package:planner/shared/components/constants.dart';
import 'package:planner/shared/cubit/states.dart';
import 'package:planner/shared/network/local/cache_helper.dart';
import 'package:sqflite/sqflite.dart';

class PlannerCubit extends Cubit<PlannerStates> {
  PlannerCubit() : super(PlannerInitialState());

  static PlannerCubit get(context) => BlocProvider.of(context);

  ThemeMode themeMode = ThemeMode.light;
  String themeModeTitle = 'Dark Mode';
  Color themeModeIconColor = Colors.black;

  void changeThemeMode (){
    if(themeMode == ThemeMode.light){
      themeMode = ThemeMode.dark;
      themeModeTitle = 'Light Mode';
      themeModeIconColor = Colors.orange;
      //CacheHelper.saveData(key: 'isDark', value: true).then((value) => emit(PlannerChangeThemeModeState()));
    } else {
      themeMode = ThemeMode.light;
      themeModeTitle = 'DarkMode';
      themeModeIconColor = Colors.black;
      //CacheHelper.saveData(key: 'isDark', value: false).then((value) => emit(PlannerChangeThemeModeState()));
    }
    emit(PlannerChangeThemeModeState());
  }

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  Future googleLogin () async {
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    userModel = UserModel(
      email: _user!.email,
      uId: _user!.id,
      image: _user!.photoUrl,
      name: _user!.displayName,
    );
    uId = _user!.id;

    emit(PlannerLoginWithGoogleState(userModel!));
  }

  Future facebookLogin () async {
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final facebookAuthCredential = FacebookAuthProvider.credential(facebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      userModel = UserModel(
        email: userData['email'],
        uId: userData['id'],
        image: userData['picture']['data']['url'],
        name: userData['name'],
      );
      uId = userData['id'];

      emit(PlannerLoginWithFacebookState(userModel!));
    } catch (error){
      showToast(text: error.toString(), state: ToastStates.ERROR);
    }
  }

  UserModel? userModel;

  void getUserData() {
    emit(PlannerGetUserLoadingStates());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(PlannerGetUserSuccessStates());
    }).catchError((error) {
      emit(PlannerGetUserErrorStates(error.toString()));
    });
  }

  List<UserModel> users = [];

  void getUsers() {
    if (users.length == 0) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel!.uId) {
            users.add(
              UserModel.fromJson(
                element.data(),
              ),
            );
          }
        });
        emit(PlannerGetAllUsersSuccessStates());
      }).catchError((error) {
        print(error.toString());
        emit(PlannerGetAllUsersErrorStates(error.toString()));
      });
    }
  }

  int pageSelected = 0;

  void changePageSelected(int index) {
    pageSelected = index;
    emit(PlannerChangePageSelectedState());
  }

  List<Widget> screens = [
    CalenderScreen(),
    TasksScreen(),
    NotesScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    '',
    'Tasks',
    'Notes',
    'Settings',
  ];

  DateTime focusedMonth = DateTime.now();

  void changeFocusedMonth (DateTime date) {
    focusedMonth = date;
    emit(PlannerChangeFocusedMonthState());
  }

  DateTime focusedDay = DateTime.now();

  void changeFocusedDay (DateTime date) {
    focusedDay = date;
    emit(PlannerChangeFocusedDayState());
  }

  DateTime currentDate = DateTime.now();

  void changeCurrentDate (DateTime date) {
    currentDate = date;
    emit(PlannerChangeCurrentDateState());
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(PlannerProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(PlannerProfileImagePickedErrorState());
    }
  }

  void uploadProfileImage() {
    emit(PlannerUserUpdateProfileLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(image: value);
      }).catchError((error) {
        emit(PlannerUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(PlannerUploadProfileImageErrorState());
    });
  }

  void updateUser({
    String? image,
  }) {
    emit(PlannerUserUpdateLoadingState());

    UserModel model = UserModel(
      name: userModel!.name,
      email: userModel!.email,
      image: image,
      uId: userModel!.uId,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      profileImage = null;
      getUserData();
    }).catchError((error) {
      emit(PlannerUserUpdateErrorState());
    });
  }

  void plannerEmitState () {
    emit(PlannerEmitState());
  }

  int tasksLength = -1;
  void increaseTasksLength(){
    tasksLength++;
  }

  // New Task *****************************************************************************************************
  int? subTaskIndex;

  void changeSubTaskIndex(int index) {
    subTaskIndex = index;
  }

  DateTime currentTaskDate = DateTime.now();
  void changeCurrentTaskDate (DateTime date) {
    currentTaskDate = date;
    emit(PlannerChangeCurrentDateState());
  }

  TimeOfDay currentTaskTime = TimeOfDay.now();
  void changeCurrentTaskTime (TimeOfDay time) {
    currentTaskTime = time;
    emit(PlannerChangeCurrentTimeState());
  }

  List<String> subTasks = [];
  List<bool> subTasksBool = [];

  void addNewSubTask (String title) {
    subTasks.add(title);
    subTasksBool.add(false);
    emit(PlannerAddSubTaskState());
  }

  void deleteSubTask (int index) {
    subTasks.removeAt(index);
    subTasksBool.removeAt(index);

    emit(PlannerDeleteSubTaskState());
  }


  void changeSubTaskValue (int index) {
    subTasksBool[index] = !subTasksBool[index];

    emit(PlannerChangeSubTaskValueState());
  }
  void clearTaskData () {
    subTasks = [];
    subTasksBool = [];
    currentTaskTime = TimeOfDay.now();
    currentTaskDate = DateTime.now();

    emit(PlannerClearTaskDataState());
  }

  List tasks = [];
  List subText = [];
  List subBool = [];
  List tasksToday = [];
  List states = [];
  late Database taskDatabase;

  void addSubText (List<String> sub) {
    subText.add(sub);
    //emit(PlannerEmitState());
  }

  void addSubBool (List<bool> sub) {
    subBool.add(sub);
  }

  void addState (bool state) {
    states.add(state);
  }

  void changeState(int index) {
    states[index] = !states[index];
    emit(PlannerEmitState());
  }

  void changeSubBool(int index, int idx) {
    subBool[index][idx] = !subBool[index][idx];
    emit(PlannerEmitState());
  }

  void createTasksDatabase() {
    openDatabase(
      'plannerTasks.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, uId TEXT, taskTitle TEXT, time TEXT, date TEXT, note TEXT, subTasks TEXT ARRAY, subTasksBool TEXT ARRAY, State TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getTasksDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      taskDatabase = value;
      emit(PlannerCreateDatabaseState());
    });
  }

  void getTasksDataFromDatabase(database) {
    emit(PlannerGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      print(value);
      tasks = [];
      tasksToday = [];
      value.forEach((element) {
        if (element['uId'] == userModel!.uId) {
          tasks.add(element);
          if(DateFormat.yMMMd().format(DateTime.parse(element['date'])) == DateFormat.yMMMd().format(DateTime.now())){
            tasksToday.add(element);
          }
        }
      });
      emit(PlannerGetDatabaseState());
    });
  }

  insertTaskToDatabase({
    required TaskModel taskModel,
    required BuildContext context,
  }) async {
    await taskDatabase.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO tasks(uId, taskTitle, time, date, note, subTasks, subTasksBool, state) VALUES("${taskModel.uId}", "${taskModel.taskTitle}", "${taskModel.time.toString()}", "${taskModel.date.toString()}", "${taskModel.note}", "${taskModel.subTasks}", "${taskModel.subTasksBool}", "${taskModel.state}")')
          .then((value) {
        print('$value inserted successfully');
        emit(PlannerInsertDatabaseState());
        getTasksDataFromDatabase(taskDatabase);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });

      return null;
    });
  }

  void updateTaskData({
    required TaskModel taskModel,
    required int id,
  }) async {
    taskDatabase.rawUpdate(
      'UPDATE tasks SET uId = ?, taskTitle = ?, time = ?, date = ?, note = ?, subTasks = ?, subTasksBool = ?, state = ? WHERE id = ?',
      ['${taskModel.uId}', '${taskModel.taskTitle}', '${taskModel.time.toString()}', '${taskModel.date.toString()}', '${taskModel.note}', '${taskModel.subTasks}', '${taskModel.subTasksBool}', '${taskModel.state}', id],
    ).then((value) {
      getTasksDataFromDatabase(taskDatabase);
      emit(PlannerUpdateDatabaseState());
    });
  }

  void deleteTaskData({
    required int id,
  }) {
    taskDatabase.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);

    getTasksDataFromDatabase(taskDatabase);

    emit(PlannerDeleteDatabaseState());
  }





  // New Event *****************************************************************************************************
  Color eventColor = Colors.tealAccent;
  String eventColorName = 'Default';
  late Database eventDatabase;
  List events = [];

  void changeEventColor(Color color, String colorName) {
    eventColor = color;
    eventColorName = colorName;

    emit(PlannerChangeEventColorState());
  }

  DateTime currentEventStartDate = DateTime.now();
  DateTime currentEventEndDate = DateTime.now();
  TimeOfDay currentEventStartTime = TimeOfDay.now();
  TimeOfDay currentEventEndTime = TimeOfDay.now();

  void changeCurrentEventStartDate (DateTime date) {
    currentEventStartDate = date;
    emit(PlannerChangeCurrentDateState());
  }

  void changeCurrentEventEndDate (DateTime date) {
    currentEventEndDate = date;
    emit(PlannerChangeCurrentDateState());
  }

  void changeCurrentEventStartTime (TimeOfDay time) {
    currentEventStartTime = time;
    emit(PlannerChangeCurrentTimeState());
  }

  void changeCurrentEventEndTime (TimeOfDay time) {
    currentEventEndTime = time;
    emit(PlannerChangeCurrentTimeState());
  }

  void createEventsDatabase() {
    openDatabase(
      'plannerEvents.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
            'CREATE TABLE events (id INTEGER PRIMARY KEY, uId TEXT, eventTitle TEXT, location TEXT, notification TEXT, note TEXT, startDate TEXT, endDate TEXT, startTime TEXT, endTime TEXT, colorName TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getEventsDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      eventDatabase = value;
      emit(PlannerCreateDatabaseState());
    });
  }

  void getEventsDataFromDatabase(database) {
    emit(PlannerGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM events').then((value) {
      print(value);
      events = [];
      value.forEach((element) {
        if (element['uId'] == userModel!.uId) {
          events.add(element);
        }
      });
      emit(PlannerGetDatabaseState());
    });
  }

  insertEventToDatabase({
    required EventModel eventModel,
    required BuildContext context,
  }) async {
    await eventDatabase.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO events(uId, eventTitle, location, notification, note, startDate, endDate, startTime, endTime, colorName) VALUES("${eventModel.uId}", "${eventModel.eventTitle}", "${eventModel.location}", "${eventModel.notification}", "${eventModel.note}", "${eventModel.startDate}", "${eventModel.endDate}", "${eventModel.startTime}", "${eventModel.endTime}", "${eventModel.colorName}")')
          .then((value) {
        print('$value inserted successfully');
        emit(PlannerInsertDatabaseState());
        getEventsDataFromDatabase(eventDatabase);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });

      return null;
    });
  }

  void updateEventData({
    required EventModel eventModel,
    required int id,
  }) async {
    eventDatabase.rawUpdate(
      'UPDATE events SET uId = ?, eventTitle = ?, location = ?, notification = ?, note = ?, startDate = ?, endDate = ?, startTime = ?, endTime = ?, colorName = ? WHERE id = ?',
      ['${eventModel.uId}', '${eventModel.eventTitle}', '${eventModel.location}', '${eventModel.notification}', '${eventModel.note}', '${eventModel.startDate}', '${eventModel.endDate}', '${eventModel.startTime}', '${eventModel.endTime}', '${eventModel.colorName}', id],
    ).then((value) {
      getEventsDataFromDatabase(eventDatabase);
      emit(PlannerUpdateDatabaseState());
    });
  }

  void deleteEventData({
    required int id,
  }) {
    eventDatabase.rawDelete('DELETE FROM events WHERE id = ?', [id]);

    getEventsDataFromDatabase(eventDatabase);

    emit(PlannerDeleteDatabaseState());
  }





  // New News *****************************************************************************************************
  List<Map> notes = [];

  late Database noteDatabase;

  DateTime initialNewNoteDate = DateTime.now();

  void changeNewNoteInitialDate (DateTime date) {
    initialNewNoteDate = date;
    emit(PlannerChangeInitialDateState());
  }

  File? noteImage;
  String? noteImageUrl;

  Future<void> getNoteImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      noteImage = File(pickedFile.path);
      emit(PlannerProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(PlannerProfileImagePickedErrorState());
    }
  }

  void uploadNoteImage() {
    emit(PlannerUserUpdateProfileLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('notes/${Uri.file(noteImage!.path).pathSegments.last}')
        .putFile(noteImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        noteImageUrl = value;
        noteImage = null;
        emit(PlannerUploadProfileImageSuccessState());
      }).catchError((error) {
        emit(PlannerUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(PlannerUploadProfileImageErrorState());
    });
  }

  void createNotesDatabase() {
    openDatabase(
      'plannerNotes.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
            'CREATE TABLE notes (id INTEGER PRIMARY KEY, uId TEXT, description TEXT, imageUrl TEXT, date TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getNotesDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      noteDatabase = value;
      emit(PlannerCreateDatabaseState());
    });
  }

  void getNotesDataFromDatabase(database) {
    emit(PlannerGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM notes').then((value) {
      print(value);
      notes = [];
      value.forEach((element) {
        if (element['uId'] == userModel!.uId) {
          notes.add(element);
        }
      });
      emit(PlannerGetDatabaseState());
    });
  }

  insertNoteToDatabase({
    required NoteModel noteModel,
    required BuildContext context,
  }) async {
    await noteDatabase.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO notes(uId, description, imageUrl, date) VALUES("${noteModel.uId}", "${noteModel.description}", "${noteModel.imageUrl}", "${noteModel.date.toString()}")')
          .then((value) {
        print('$value inserted successfully');
        noteImageUrl = null;
        emit(PlannerInsertDatabaseState());
        getNotesDataFromDatabase(noteDatabase);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });

      return null;
    });
  }

  void updateNoteData({
    required NoteModel noteModel,
    required int id,
  }) async {
    noteDatabase.rawUpdate(
      'UPDATE notes SET uId = ?, description = ?, imageUrl = ?, date = ? WHERE id = ?',
      ['${noteModel.uId}', '${noteModel.description}', '${noteModel.imageUrl}', '${noteModel.date.toString()}', id],
    ).then((value) {
      getNotesDataFromDatabase(noteDatabase);
      emit(PlannerUpdateDatabaseState());
    });
  }

  void deleteNoteData({
    required int id,
  }) {
    noteDatabase.rawDelete('DELETE FROM notes WHERE id = ?', [id]);

    getNotesDataFromDatabase(noteDatabase);

    emit(PlannerDeleteDatabaseState());
  }

}