import 'dart:core';
import 'dart:ffi';
export 'task.dart';

class Task {
  int? id;
  String? title;
  String? description; // Missing semicolon after description
  int? isCompleted; // Consider using a bool for completion state
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  Task({
    this.id,
    this.title, // Provide default value for optional fields
    this.description,
    this.isCompleted, // Provide default value for optional fields
    this.date,
    this.startTime,
    this.endTime,
    this.color, // Provide default value for optional fields
  });
  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    isCompleted = json['isCompleted'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    color = json['color'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['isCompleted'] = this.isCompleted;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['color'] = this.color;
    data['date'] = this.date;
    return data;
  }
}
