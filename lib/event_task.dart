import 'package:flutter/material.dart';

class EventTask {
  String title;
  String description;
  bool completed;
  bool receiveAlerts;
  // String priority;

  EventTask(this.title, this.description, this.completed, this.receiveAlerts);
}
