import 'package:flutter/material.dart';
import 'package:todo/pages/home_layout/converted_time.dart';

class TaskModel {
  String? id;
  String title;
  String description;
  bool isDone;
  DateTime dateTime;
  TimeOfDay timeOfDay;

  TaskModel(
      {this.id,
      required this.title,
      required this.description,
      required this.isDone,
      required this.dateTime,
      required this.timeOfDay});

  factory TaskModel.fromFireStore(Map<String, dynamic> json) {
    return TaskModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        isDone: json['isDone'],
        dateTime: DateTime.fromMillisecondsSinceEpoch(
          json['dateTime'],
        ),
        timeOfDay: TimeOfDay(
            hour: json['timeOfDay']['hour'],
            minute: json['timeOfDay']['minute']));
  }

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'dateTime': ConvertedTime.getDate(dateTime).millisecondsSinceEpoch,
      'timeOfDay': {"hour": timeOfDay.hour, "minute": timeOfDay.minute}
    };
  }
}
