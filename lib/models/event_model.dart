import 'package:flutter/material.dart';

class EventModel {
  String? uId;
  String? eventTitle;
  String? location;
  String? notification;
  String? note;
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? colorName;

  EventModel({
    required this.uId,
    required this.eventTitle,
    required this.location,
    required this.notification,
    required this.note,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.colorName,
  });
}
