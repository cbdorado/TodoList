import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/authentication.dart';
import '../models/todo.dart';
import 'dart:async';
import 'dart:convert';

User _authenticatedUser;

mixin ConnectedTodosModel on Model {
  List<Todo> _todos = [];
  String _selTodoId;

  Future<bool> addTodo(String task, String title, String description) async {
    final Map<String, dynamic> todoData = {
      'task': task,
      'title': title,
      'description': description,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
    };
    try {
      final http.Response response = await http.post(
          'https://todolist-a943a.firebaseio.com/${_authenticatedUser.id}/todos.json?auth=${_authenticatedUser.token}',
          body: json.encode(todoData));
      if (response.statusCode != 200 && response.statusCode != 201) {
        print(response.statusCode);
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);

      final Todo newTodo = Todo(
        id: responseData['name'],
        task: task,
        title: title,
        description: description,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id,
      );

      _todos.add(newTodo);
      notifyListeners();
      return true;
    } catch (err) {
      return false;
    }
  }
}

mixin TodosModel on ConnectedTodosModel {
  List<Todo> get getTodos {
    return List.from(_todos);
  }

  String get selectedTodoId {
    return _selTodoId;
  }

  Todo get selectedTodo {
    if (_selTodoId == null) {
      return null;
    }
    return _todos.firstWhere((Todo todo) {
      return todo.id == _selTodoId;
    });
  }

  int get selectedTodoIndex {
    return _todos.indexWhere((Todo todo) {
      return todo.id == _selTodoId;
    });
  }

  Future<bool> updateTodo(String task, String title, String description) {
    final Map<String, dynamic> updatedData = {
      'task': task,
      'title': title,
      'description': description,
      'userEmail': selectedTodo.userEmail,
      'userId': selectedTodo.id,
    };

    return http
        .put(
            'https://todolist-a943a.firebaseio.com/${_authenticatedUser.id}/todos/${selectedTodo.id}.json?auth=${_authenticatedUser.token}',
            body: json.encode(updatedData))
        .then((http.Response response) {
      final Todo updatedTodo = Todo(
        id: selectedTodo.id,
        task: task,
        title: title,
        description: description,
        userEmail: selectedTodo.userEmail,
        userId: selectedTodo.id,
      );
      _todos[selectedTodoIndex] = updatedTodo;
      notifyListeners();
      return true;
    }).catchError((err) {
      return false;
    });
  }

  Future<bool> deleteTodo() {
    final deletedTodoId = selectedTodo.id;
    _todos.removeAt(selectedTodoIndex);
    _selTodoId = null;
    notifyListeners();
    return http
        .delete(
            'https://todolist-a943a.firebaseio.com/${_authenticatedUser.id}/todos/${deletedTodoId}.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      fetchTodos();
      notifyListeners();
      return true;
    }).catchError((error) {
      return false;
    });
  }

  Future<Null> fetchTodos() {
    return http
        .get(
            'https://todolist-a943a.firebaseio.com/${_authenticatedUser.id}/todos.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      List<Todo> fetchedTodos = [];
      final Map<String, dynamic> todoData = json.decode(response.body);
      if (fetchedTodos == null) {
        notifyListeners();
        return;
      }
      todoData.forEach((String todoId, dynamic todoData) {
        final Todo todo = Todo(
          id: todoId,
          task: todoData['task'],
          title: todoData['title'],
          description: todoData['description'],
          userEmail: todoData['userEmail'],
          userId: todoData['userId'],
        );
        fetchedTodos.add(todo);
      });
      _todos = fetchedTodos;
      notifyListeners();
      _selTodoId = null;
    }).catchError((err) {
      return 'Error has occured!';
    });
  }

  void selectTodo(String todoId) {
    _selTodoId = todoId;
    notifyListeners();
  }
}

mixin UserModel on ConnectedTodosModel {
  User get user {
    return _authenticatedUser;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [LoginMode mode = LoginMode.Login]) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    http.Response response;
    if (mode == LoginMode.Login) {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyCNFfkWcrhAX_5f87G7z0XuOvmZ6qRd2UU',
        body: json.encode(authData),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    } else {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyCNFfkWcrhAX_5f87G7z0XuOvmZ6qRd2UU',
        body: json.encode(authData),
        // we have to explicitly say where we are sending this encoded data to
        headers: {
          'Content-Type': 'application/json',
        },
      );
    }

    // create the response data map which is the decoded response body
    // assumes there is an error at first
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    // if response data body contains string idToken there is no error, creates a new User
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded';
      _authenticatedUser = User(
        id: responseData['localId'],
        email: email,
        token: responseData['idToken'],
      );

      // gets access to shared preferences to store user token
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    }
    // if email exists change message
    else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    // returning a Future map that contains whether the user has logged in successfully
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // gets string key 'token'
    final String token = prefs.getString('token');

    // check if we got a token and authenticate the user
    if (token != null) {
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');

      _authenticatedUser = User(id: userId, email: userEmail, token: token);

      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }
}
