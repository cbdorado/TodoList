import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/authentication.dart';
import 'dart:async';
import 'dart:convert';

User _authenticatedUser;

mixin ConnectedTasksModel on Model {

}
mixin UserModel on ConnectedTasksModel {
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