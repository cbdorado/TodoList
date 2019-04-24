import 'package:flutter/material.dart';

class Todo {
  final String id;
  final String task;
  final String title;
  final String description;
  final String userEmail;
  final String userId;

  Todo({
    @required this.id,
    @required this.task,
    @required this.title,
    @required this.description,
    @required this.userEmail,
    @required this.userId,
  });
}
