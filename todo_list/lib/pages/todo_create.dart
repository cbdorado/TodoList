import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TodoCreate extends StatefulWidget {
  final Map<String, dynamic> data;
  const TodoCreate({Key key, this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TodoCreateState();
  }
}

class TodoCreateState extends State<TodoCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _todoTitle = FocusNode();
  final _todoDescription = FocusNode();

  @override
  TodoCreate get widget => super.widget;

  @override
  initState() {
    super.initState();
  }

  Widget _buildTitleTextField(Todo todo) {
    return TextFormField(
      focusNode: _todoTitle,
      initialValue: todo == null ? '' : todo.title,
      decoration: InputDecoration(
          labelText: 'What do you have to do?', border: OutlineInputBorder()),
      onSaved: (String value) {
        widget.data['title'] = value;
      },
    );
  }

  Widget _buildDescriptionTextField(Todo todo) {
    return TextFormField(
      focusNode: _todoDescription,
      initialValue: todo == null ? '' : todo.title,
      decoration: InputDecoration(
          labelText: 'Todo description', border: OutlineInputBorder()),
      onSaved: (String value) {
        widget.data['description'] = value;
      },
      maxLines: 4,
    );
  }

  void _submitForm(
      Function addTodo, Function updateTodo, Function setSelectedTodo,
      [int selectedTodoIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedTodoIndex == -1) {
      addTodo(
        widget.data['task'],
        widget.data['title'],
        widget.data['description'],
      ).then(
        (bool success) {
          if (success) {
            setSelectedTodo(null);
            Navigator.pop(context);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Something went wrong.'),
                  content: Text('Please try again!'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Okay!'),
                    )
                  ],
                );
              },
            );
          }
        },
      );
    } else {
      updateTodo(
        widget.data['task'],
        widget.data['title'],
        widget.data['description'],
      ).then(
        (_) => setSelectedTodo(null),
        Navigator.pop(context),
      );
    }
  }

  Widget _buildPageContent(BuildContext context, Todo todo) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            _buildTitleTextField(todo),
            SizedBox(
              height: 25.0,
            ),
            _buildDescriptionTextField(todo),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return WillPopScope(
          onWillPop: () {
            model.selectTodo(null);
            Navigator.pop(context, false);
          },
          child: Material(
              child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                '${widget.data['task']}',
                style: TextStyle(fontWeight: FontWeight.bold,),
              ),
              elevation: 0.0,
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _submitForm(
                  model.addTodo,
                  model.updateTodo,
                  model.selectTodo,
                  model.selectedTodoIndex,
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: Icon(FontAwesomeIcons.plus),
            ),
            body: _buildPageContent(context, model.selectedTodo),
          )),
        );
      },
    );
  }
}
