import 'package:flutter/material.dart';

class TaskModel {
  String uId;
  String taskTitle;
  String note;
  List<String> subTasks;
  List<bool> subTasksBool;
  DateTime date;
  TimeOfDay time;
  bool state;

  TaskModel({
    required this.uId,
    required this.taskTitle,
    required this.subTasks,
    required this.subTasksBool,
    required this.date,
    required this.time,
    required this.note,
    required this.state,
  });
}
