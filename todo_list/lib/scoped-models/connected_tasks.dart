import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/authentication.dart';
import '../models/todo.dart';
import 'dart:async';
import 'dart:convert';

User _authenticatedUser;

// create a Model to handle a List of type Todo
mixin ConnectedTodosModel on Model {
  // initialize List of Todo and currently selected Todo ID
  List<Todo> _todos = [];
  String _selTodoId;

  // method adds a todo to the list of Todos, returns a Future which is a callback function
  Future<bool> addTodo(String task, String title, String description) async {
    // initialize a Map variable for todo data
    final Map<String, dynamic> todoData = {
      'task': task,
      'title': title,
      'description': description,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
    };
    // use try catch block to catch firebase api error
    try {
      // performs other tasks while waiting for post request to be finished and encodes the todo data in JSON format
      final http.Response response = await http.post(
          'https://todolist-a943a.firebaseio.com/${_authenticatedUser.id}/todos.json?auth=${_authenticatedUser.token}',
          body: json.encode(todoData));
      // checks response code whether there was an error or not and prints and returns false
      if (response.statusCode != 200 && response.statusCode != 201) {
        print(response.statusCode);
        return false;
      }

      // decodes the response data into a map
      final Map<String, dynamic> responseData = json.decode(response.body);

      // creates a new Todo and assigns the response data id to it
      final Todo newTodo = Todo(
        id: responseData['name'],
        task: task,
        title: title,
        description: description,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id,
      );
      // adds new todo to the list
      _todos.add(newTodo);
      // rebuilds the current widget and all other child widgets to update the UI
      notifyListeners();
      return true;
    } catch (err) {
      return false;
    }
  }
}

// create a new Model that inherits the attributes of the ConnectedTodosModel
mixin TodosModel on ConnectedTodosModel {
  // simple getter that retrieves the list
  List<Todo> get getTodos {
    return List.from(_todos);
  }

  // returns the currently selected id
  String get selectedTodoId {
    return _selTodoId;
  }

  // returns the todo that's selected
  Todo get selectedTodo {
    // if there is no currently selected todo Id, then return a null type object
    if (_selTodoId == null) {
      return null;
    }
    // else look in the list where the todo id is equal to the currently selected todo id and return that todo
    return _todos.firstWhere((Todo todo) {
      return todo.id == _selTodoId;
    });
  }

  // iterates through the list of todos and returns the todo index that matches with selected todo index
  int get selectedTodoIndex {
    return _todos.indexWhere((Todo todo) {
      return todo.id == _selTodoId;
    });
  }

  // updates the selected todo and returning a Future
  Future<bool> updateTodo(String task, String title, String description) {
    // creates a Map of the updated data
    final Map<String, dynamic> updatedData = {
      'task': task,
      'title': title,
      'description': description,
      'userEmail': selectedTodo.userEmail,
      'userId': selectedTodo.id,
    };
    // http put request to firebase api, encodes updated data into JSON format
    return http
        .put(
            'https://todolist-a943a.firebaseio.com/${_authenticatedUser.id}/todos/${selectedTodo.id}.json?auth=${_authenticatedUser.token}',
            body: json.encode(updatedData))
        .then((http.Response response) {
      // updates the selected todo with the updated data
      final Todo updatedTodo = Todo(
        id: selectedTodo.id,
        task: task,
        title: title,
        description: description,
        userEmail: selectedTodo.userEmail,
        userId: selectedTodo.id,
      );
      // sets the value of the selected index to the updatee todo
      _todos[selectedTodoIndex] = updatedTodo;
      // rebuilds current widget and its child widgets
      notifyListeners();
      return true;
    }).catchError((err) {
      return false;
    });
  }

  // deletes a selected todo and returns a Future
  Future<bool> deleteTodo() {
    //create a variable that holds the selected todo id
    final deletedTodoId = selectedTodo.id;
    // remove todo at selected index from the list
    _todos.removeAt(selectedTodoIndex);
    // set the Id to null
    _selTodoId = null;
    // rebuild the widget and it's child widgets to update UI
    notifyListeners();
    // http delete request
    return http
        .delete(
            'https://todolist-a943a.firebaseio.com/${_authenticatedUser.id}/todos/${deletedTodoId}.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      // fetches the list of todos to get the current and updated list of todos
      fetchTodos();
      // rebuilds the widget and it's child widgets to update UI
      notifyListeners();
      return true;
    }).catchError((error) {
      return false;
    });
  }

  // fetches the list of todos, returns a Future
  Future<Null> fetchTodos() {
    // http get request to retrieve todos from authenticated user
    return http
        .get(
            'https://todolist-a943a.firebaseio.com/${_authenticatedUser.id}/todos.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      // create a new empty list of fetched todos
      List<Todo> fetchedTodos = [];
      // decode the json response body to store in a Map variable
      final Map<String, dynamic> todoListData = json.decode(response.body);
      // check if the fetched todos is null
      if (fetchedTodos == null) {
        notifyListeners();
        return;
      }
      // for each key value pair in the decoded json, create a todo with the data and add that todo to the fetched todos list
      todoListData.forEach((String todoId, dynamic todoData) {
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
      // sets the variable _todos to the list of values in fetched todos
      _todos = fetchedTodos;
      // rebuilds the current widget and its descendant widgets
      notifyListeners();
      // set the id to null
      _selTodoId = null;
    }).catchError((error) {
      return;
    });
  }

  // sets the selected todo id to the id that's passed in and rebuilds the widget and child widgets
  void selectTodo(String todoId) {
    _selTodoId = todoId;
    notifyListeners();
  }
}

// create a user model that inherits from the connected todos model
mixin UserModel on ConnectedTodosModel {
  // returns the authenticated user
  User get user {
    return _authenticatedUser;
  }

  // returns a Future of generic type Map
  Future<Map<String, dynamic>> authenticate(String email, String password,
      [LoginMode mode = LoginMode.Login]) async {
    // create a Map variable the holds the authentication data
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    // if the authentication mode is login, verify the password, else sign up the user
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
      print(_authenticatedUser.id);

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
