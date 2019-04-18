import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/todo.dart';
import '../pages/todo_create.dart';

class CategoryPicker extends StatelessWidget {
  CategoryPicker({Key key}) : super(key: key);
  Map<String, dynamic> formData;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Material(
        color: Colors.amber[300],
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              Container(
                child: Text('What would you like to do today?',
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: <Widget>[
                  Transform(
                    transform: new Matrix4.identity()..scale(1.5),
                    child: ActionChip(
                      backgroundColor: Colors.pink[500],
                      avatar: CircleAvatar(
                        child: Icon(
                          FontAwesomeIcons.briefcase,
                          size: 15.0,
                        ),
                      ),
                      label: Text(
                        'Work',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoCreate(
                                  data: formData = {
                                    'task': 'Work',
                                    'title': null,
                                    'description': null,
                                  },
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 50.0,
                  ),
                  Transform(
                    transform: new Matrix4.identity()..scale(1.5),
                    child: ActionChip(
                      backgroundColor: Colors.pink[500],
                      avatar: CircleAvatar(
                        child: Icon(
                          FontAwesomeIcons.running,
                          size: 15.0,
                        ),
                      ),
                      label: Text(
                        'Exercise',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoCreate(
                                  data: formData = {
                                    'task': 'Exercise',
                                    'title': null,
                                    'description': null,
                                  },
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                children: <Widget>[
                  Transform(
                    transform: new Matrix4.identity()..scale(1.5),
                    child: ActionChip(
                      backgroundColor: Colors.pink[500],
                      avatar: CircleAvatar(
                        child: Icon(
                          FontAwesomeIcons.utensils,
                          size: 15.0,
                        ),
                      ),
                      label: Text(
                        'Eat',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoCreate(
                                  data: formData = {
                                    'task': 'Eat',
                                    'title': null,
                                    'description': null,
                                  },
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 50.0,
                  ),
                  Transform(
                    transform: new Matrix4.identity()..scale(1.5),
                    child: ActionChip(
                      backgroundColor: Colors.pink[500],
                      avatar: CircleAvatar(
                        child: Icon(
                          FontAwesomeIcons.bed,
                          size: 10.0,
                        ),
                      ),
                      label: Text(
                        'Rest',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoCreate(
                                  data: formData = {
                                    'task': 'Rest',
                                    'title': null,
                                    'description': null,
                                  },
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                children: <Widget>[
                  Transform(
                    transform: new Matrix4.identity()..scale(1.5),
                    child: ActionChip(
                      backgroundColor: Colors.pink[500],
                      avatar: CircleAvatar(
                        child: Icon(
                          FontAwesomeIcons.sun,
                          size: 15.0,
                        ),
                      ),
                      label: Text(
                        'Mindfulness',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoCreate(
                                  data: formData = {
                                    'task': 'Mindfulness',
                                    'title': null,
                                    'description': null,
                                  },
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 70.0,
                  ),
                  Transform(
                    transform: new Matrix4.identity()..scale(1.5),
                    child: ActionChip(
                      backgroundColor: Colors.pink[500],
                      avatar: CircleAvatar(
                        child: Icon(
                          FontAwesomeIcons.shoppingBasket,
                          size: 15.0,
                        ),
                      ),
                      label: Text(
                        'Groceries',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoCreate(
                                  data: formData = {
                                    'task': 'Groceries',
                                    'title': null,
                                    'description': null,
                                  },
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                children: <Widget>[
                  Transform(
                    transform: new Matrix4.identity()..scale(1.5),
                    child: ActionChip(
                      backgroundColor: Colors.pink[500],
                      avatar: CircleAvatar(
                        child: Icon(
                          FontAwesomeIcons.users,
                          size: 10.0,
                        ),
                      ),
                      label: Text(
                        'Social',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoCreate(
                                  data: formData = {
                                    'task': 'Social',
                                    'title': null,
                                    'description': null,
                                  },
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 50.0,
                  ),
                  Transform(
                    transform: new Matrix4.identity()..scale(1.5),
                    child: ActionChip(
                      backgroundColor: Colors.pink[500],
                      avatar: CircleAvatar(
                        child: Icon(
                          FontAwesomeIcons.heart,
                          size: 15.0,
                        ),
                      ),
                      label: Text(
                        'Self-Care',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoCreate(
                                  data: formData = {
                                    'task': 'Self-Care',
                                    'title': null,
                                    'description': null,
                                  },
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                children: <Widget>[
                  Transform(
                    transform: new Matrix4.identity()..scale(1.5),
                    child: ActionChip(
                      backgroundColor: Colors.pink[500],
                      avatar: CircleAvatar(
                        child: Icon(
                          FontAwesomeIcons.tasks,
                          size: 15.0,
                        ),
                      ),
                      label: Text(
                        'Other',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoCreate(
                                  data: formData = {
                                    'task': 'Other',
                                    'title': null,
                                    'description': null,
                                  },
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
