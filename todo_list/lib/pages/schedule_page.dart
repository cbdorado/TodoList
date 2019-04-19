import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main_model.dart';
import '../pages/todo_create.dart';

class SchedulePage extends StatefulWidget {
  final MainModel model;
  SchedulePage(this.model);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SchedulePageState();
  }
}

class SchedulePageState extends State<SchedulePage> {
  @override
  SchedulePage get widget => super.widget;
  @override
  void initState() {
    widget.model.fetchTodos();
    super.initState();
  }

  Widget _buildScheduleList(List<Todo> todos) {
    Widget scheduleList;
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        if (todos.length > 0) {
          scheduleList = ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(
                  todos[index].title,
                ),
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.startToEnd ||
                      direction == DismissDirection.endToStart) {
                    model.selectTodo(todos[index].id);
                    model.deleteTodo();
                  }
                },
                background: Container(color: Colors.red),
                child: InkWell(
                  child: Card(
                    child: ListTile(
                      leading: Text(todos[index].task),
                      title: Text(todos[index].title),
                      subtitle: Text(
                        todos[index].description,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                  onTap: () {
                    model.selectTodo(todos[index].id);
                    print(index);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodoCreate(
                              data: {
                                'task': todos[index].task,
                              },
                            ),
                      ),
                    );
                  },
                ),
              );
            },
            itemCount: todos.length,
          );
        } else {
          scheduleList = Container();
        }
        return scheduleList;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Material(
          color: Colors.amber[300],
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.pink[600],
              title: Text(
                'SCHEDULE',
                style: TextStyle(fontSize: 25.0, color: Colors.white),
              ),
              elevation: 0.0,
              centerTitle: true,
            ),
            body: Container(
                color: Colors.amber[300],
                child: _buildScheduleList(model.getTodos)),
          ),
        );
      },
    );
  }
}
